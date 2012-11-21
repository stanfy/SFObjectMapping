//
//  NSObject(SFXMLMapping)
//  Nemlig-iPad
//
//  Created by Paul Taykalo on 6/7/12.
//  Copyright (c) 2012 Stanfy LLC. All rights reserved.
//
#import <objc/runtime.h>
#import "NSObject+SFMapping.h"
#import "SFMappingCore.h"


@implementation NSObject (SFMapping)



static char * sfMappingInfoKeyKey;


+ (id)SFMappingInfo {
   NSArray * array = objc_getAssociatedObject(self, &sfMappingInfoKeyKey);
   return array;
}


+ (void)setSFMappingInfo:(id)object, ... {
   va_list args;
   va_start(args, object);

   NSMutableArray *bindingInfoObjects = [NSMutableArray arrayWithArray:[self SFMappingInfo]];

   if (object) {
      [bindingInfoObjects addObject:object];
   }

   id arg = nil;
   while ((arg = va_arg(args, id))) {
      [bindingInfoObjects addObject:arg];
   }

   va_end(args);

   objc_setAssociatedObject(self, &sfMappingInfoKeyKey, bindingInfoObjects, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}



- (void)applyMappingsFromObject:(id)sourceObject {
   [self applyMappingsFromObject:sourceObject error:nil];
}


- (void)applyMappingsFromObject:(id)sourceObject error:(NSError **)error{
   [SFMappingCore applyMappingsOnObject:self fromObject:sourceObject error:error];
}


@end