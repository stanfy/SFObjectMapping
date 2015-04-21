//
//  SFMapper.m
//  Nemlig-iPad
//
//  Created by Paul Taykalo on 6/7/12.
//  Copyright (c) 2012 Stanfy LLC. All rights reserved.
//

#import "SFMapper.h"
#import "SFMappingCore.h"
#import "SFMapping.h"

@implementation SFMapper


- (BOOL)applyMapping:(SFMapping *)mapping onObject:(id)object withValue:(id)value error:(NSError **)error {
    [self setValue:value forKey:mapping.property onObject:object];
    return YES;
}


- (BOOL)setValue:(id)value forKey:(NSString *)key onObject:(id)destObject {
    if (value && destObject) {
        if ([destObject isKindOfClass:[NSDictionary class]]) {
            [destObject setObject:value forKey:key];
        } else {
            [destObject setValue:value forKeyPath:key];
        }
    }
    return YES;
}


@end



