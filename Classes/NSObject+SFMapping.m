//
//  NSObject(SFObjectMapping)
//  SFObjectMapping
//
//  Created by Paul Taykalo on 6/7/12.
//  Copyright (c) 2012 Stanfy LLC. All rights reserved.
//
#import <objc/runtime.h>
#import "NSObject+SFMapping.h"
#import "SFMappingCore.h"


@implementation NSObject (SFMapping)

static char *sfMappingInfoKeyKey;

+ (id)SFMappingInfo {
    NSArray *array = objc_getAssociatedObject(self, &sfMappingInfoKeyKey);
    return array;
}


+ (void)setSFMappingInfo:(id)object, ... {
    if (!object) {
        objc_setAssociatedObject(self, &sfMappingInfoKeyKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
    va_list args;
    va_start(args, object);

    NSMutableArray *bindingInfoObjects = [NSMutableArray arrayWithArray:[self SFMappingInfo]];

    [bindingInfoObjects addObject:object];

    id arg = nil;
    while ((arg = va_arg(args, id))) {
        [bindingInfoObjects addObject:arg];
    }

    va_end(args);

    objc_setAssociatedObject(self, &sfMappingInfoKeyKey, bindingInfoObjects, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (BOOL)applyMappingsFromObject:(id)sourceObject {
    return [self applyMappingsFromObject:sourceObject error:nil];
}


- (BOOL)applyMappingsFromObject:(id)sourceObject error:(NSError **)error {
    return [SFMappingCore applyMappingsOnObject:self fromObject:sourceObject error:error];
}


@end