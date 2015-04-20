//
// Created by Paul Taykalo on 4/20/15.
// Copyright (c) 2015 Stanfy LLC. All rights reserved.
//

#import "SFNSStringMapper.h"
#import "SFMapping.h"
#import "NSError+SFMapping.h"


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
        NSString *stringValue = (NSString *) value;
        [self setValue:[stringValue copy] forKey:mapping.property onObject:object];

    } else {
        // TODO: Correct error handling
        NSLog(@"%@ Couldn't convert value : %@ to NSString", self, value);
        if (error) {
            *error = [NSError sfMappingErrorWithMapping:mapping object:object value:value];
        }
        return NO;
    }
    return YES;
}
@end