//
//  SFDateMapper.m
//
//  Created by Paul Taykalo on 5/16/12.
//  Copyright (c) 2012 Stanfy. All rights reserved.
//

#import "SFDateMapper.h"
#import "SFMapping.h"
#import "NSError+SFMapping.h"

@implementation SFDateMapper

@synthesize dateFormatter = _dateFormatter;

- (instancetype)initWithDateFormatter:(NSDateFormatter *)dateFormatter {
    self = [super init];
    if (self) {
        _dateFormatter = dateFormatter;
    }

    return self;
}

+ (id)instanceWithDateFormatter:(NSDateFormatter *)dateFormatter {
    SFDateMapper *result = [[SFDateMapper alloc] initWithDateFormatter:dateFormatter];
    return result;
}


- (BOOL)applyMapping:(SFMapping *)mapping onObject:(id)object withValue:(id)value error:(NSError **)error {
    if (!object || !value) {
        return NO;
    }

    if ([value isKindOfClass:[NSString class]]) {
        NSDate *date = [self.dateFormatter dateFromString:value];
        if (date) {
            [object setValue:date forKey:mapping.property];
            return YES;
        }
    }

    if (error) {
        *error = [NSError sfMappingErrorWithMapping:mapping object:object value:value];
    }
    return NO;

}


@end
