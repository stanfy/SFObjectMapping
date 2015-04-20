//
// Created by Paul Taykalo on 4/20/15.
// Copyright (c) 2015 Stanfy LLC. All rights reserved.
//

#import "SFNSArrayMapper.h"
#import "SFMapping.h"
#import "SFMappingCore.h"


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
            }
        } else {

        }
    } else {

        // TODO : Correct handling NSArray as not collection
        // What should we do here instantiate array with what ?

        NSLog(@"%@ Couldn't convert value : %@ to NSArray", self, value);
        if (error) {
            *error = [NSError errorWithDomain:@"Not implemented mapping" code:-1 userInfo:nil];
        }

    }
    return YES;
}
@end