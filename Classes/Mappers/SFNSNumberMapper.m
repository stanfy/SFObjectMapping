//
// Created by Paul Taykalo on 4/20/15.
// Copyright (c) 2015 Stanfy LLC. All rights reserved.
//

#import "SFNSNumberMapper.h"
#import "SFMapping.h"
#import "NSError+SFMapping.h"


@implementation SFNSNumberMapper


static NSNumber * _zeroValue;


- (id)init {
    self = [super init];
    if (self) {
        _zeroValue = @NO;
    }
    return self;
}


- (BOOL)applyMapping:(SFMapping *)mapping onObject:(id)object withValue:(id)value error:(NSError **)error {
    if (!value || [value isKindOfClass:[NSNull class]]) {
        // Null
        [self setValue:_zeroValue forKey:mapping.property onObject:object];

    } else if ([value isKindOfClass:[NSNumber class]]) {
        //Number
        [self setValue:value forKey:mapping.property onObject:object];


    } else if ([value isKindOfClass:[NSString class]]) {
        //String
        [self setValue:@([value doubleValue]) forKey:mapping.property onObject:object];

    } else {
        if (error) {
            *error = [NSError sfMappingErrorWithMapping:mapping object:object value:value];
        }
        return NO;
    }
    return YES;
}
@end