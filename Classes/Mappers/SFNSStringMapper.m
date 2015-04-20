//
// Created by Paul Taykalo on 4/20/15.
// Copyright (c) 2015 Stanfy LLC. All rights reserved.
//

#import "SFNSStringMapper.h"
#import "SFMapping.h"


@implementation SFNSStringMapper

- (BOOL)applyMapping:(SFMapping *)mapping onObject:(id)object withValue:(id)value error:(NSError **)error {
    if (!value || [value isKindOfClass:[NSNull class]]) {
        // Null
        [self setValue:nil forKey:mapping.property onObject:object];

    } else if ([value isKindOfClass:[NSNumber class]]) {
        //Number
        [self setValue:[value stringValue] forKey:mapping.property onObject:object];


    } else if ([value isKindOfClass:[NSString class]]) {
        //String
        [self setValue:value forKey:mapping.property onObject:object];

    } else {
        // TODO: Correct error handling
        NSLog(@"%@ Couldn't convert value : %@ to NSString", self, value);
        if (error) {
            *error = [NSError errorWithDomain:@"Not implemented mapping" code:-1 userInfo:nil];
        }
    }
    return YES;
}
@end