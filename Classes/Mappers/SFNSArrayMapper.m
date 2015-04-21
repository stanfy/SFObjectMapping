//
// Created by Paul Taykalo on 4/20/15.
// Copyright (c) 2015 Stanfy LLC. All rights reserved.
//

#import "SFNSArrayMapper.h"
#import "SFMapping.h"
#import "SFMappingCore.h"
#import "NSError+SFMapping.h"


@implementation SFNSArrayMapper

- (BOOL)applyMapping:(SFMapping *)mapping onObject:(id)object withValue:(id)value error:(NSError **)error {

    NSMutableArray *result = nil;

    if (mapping.collection) {

        if ([value isKindOfClass:[NSArray class]]) {
            NSString *itemClassString = mapping.itemClass;
            Class clz = NSClassFromString(itemClassString);
            if (clz) {
                result = [NSMutableArray array];
                for (id sourceObject in value) {
                    id item = [SFMappingCore instanceOfClass:clz fromObject:sourceObject];
                    [result addObject:item];
                }
                [self setValue:result forKey:mapping.property onObject:object];
                return YES;
            } else {
                if (error) {
                    *error = [NSError sfItemClassDoesNotExitsErrorWithMapping:mapping object:object value:value];
                }
                return NO;
            }
        }
    }
    if (error) {
        *error = [NSError sfMappingErrorWithMapping:mapping object:object value:value];
    }
    return NO;

}

@end