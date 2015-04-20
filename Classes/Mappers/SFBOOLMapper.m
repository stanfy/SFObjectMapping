//
// Created by Paul Taykalo on 4/20/15.
// Copyright (c) 2015 Stanfy LLC. All rights reserved.
//

#import "SFBOOLMapper.h"
#import "SFMapping.h"
#import "NSError+SFMapping.h"


@implementation SFBOOLMapper

static NSNumber * _falseValue;


- (id)init {
    self = [super init];
    if (self) {
        _falseValue = @NO;
    }
    return self;
}


- (BOOL)applyMapping:(SFMapping *)mapping onObject:(id)object withValue:(id)value error:(NSError **)error {
    // TODO: Perform correct bool mapping
    // Nil
    if (!value || [value isKindOfClass:[NSNull class]]) {
        [self setValue:_falseValue forKey:mapping.property onObject:object];

    } else if ([value isKindOfClass:[NSNumber class]]) {
        //Number
        [self setValue:value forKey:mapping.property onObject:object];


    } else if ([value isKindOfClass:[NSString class]]) {
        //String
        [self setValue:@([value boolValue]) forKey:mapping.property onObject:object];

    } else {
        NSLog(@"%@ Couldn't convert value : %@ to BOOL", self, value);
        if (error) {
            *error = [NSError sfMappingErrorWithMapping:mapping object:object value:value];
        }
        return NO;
    }
    return YES;
}
@end