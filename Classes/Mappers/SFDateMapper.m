//
//  SFDateMapper.m
//
//  Created by Paul Taykalo on 5/16/12.
//  Copyright (c) 2012 Stanfy. All rights reserved.
//

#import "SFDateMapper.h"
#import "SFMapping.h"

@implementation SFDateMapper

@synthesize dateFormatter = _dateFormatter;


+ (id)instanceWithDateFormatter:(NSDateFormatter *)dateFormatter {
    SFDateMapper *result = [[SFDateMapper alloc] init];
    result.dateFormatter = dateFormatter;
    return result;

}


- (BOOL)applyMapping:(SFMapping *)mapping onObject:(id)object withValue:(id)value error:(NSError **)error {
    if (!object || !value) {
        return NO;
    }

    if (value) {
        [self setValue:value forKey:mapping.property onObject:object];
    }
    return YES;

}


- (BOOL)setValue:(id)value forKey:(NSString *)key onObject:(id)destObject {
    if ([value isKindOfClass:[NSString class]]) {
        NSDate *date = [self.dateFormatter dateFromString:value];
        if (date) {
            [destObject setValue:date forKey:key];
        }
//      } else {
//         [destObject setNilValueForKey:key];
//      }
    }
    return YES;
}

@end
