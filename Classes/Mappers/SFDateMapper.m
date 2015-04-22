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
            [object setValue:date forKeyPath:mapping.property];
            return YES;
        }
    }

    if (error) {
        *error = [NSError sfMappingErrorWithMapping:mapping object:object value:value];
    }
    return NO;

}

#pragma mark - Base date mappers

+ (SFDateMapper *)rfc2882DateTimeMapper {
    static dispatch_once_t once;
    static SFDateMapper * mapper;
    dispatch_once(&once, ^{
        NSDateFormatter *formatter = [self _formatterWithDateFormat:@"EEE, dd MMM yyyy HH:mm:ss z"];
        mapper = [SFDateMapper instanceWithDateFormatter:formatter];
    });
    return mapper;
}

+ (SFDateMapper *)rfc3339DateTimeMapper {
    static dispatch_once_t once;
    static SFDateMapper * mapper;
    dispatch_once(&once, ^{
        NSDateFormatter *formatter = [self _formatterWithDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
        mapper = [SFDateMapper instanceWithDateFormatter:formatter];
    });
    return mapper;
}

+ (SFDateMapper *)iso8601DateTimeMapper {
    static dispatch_once_t once;
    static SFDateMapper * mapper;
    dispatch_once(&once, ^{
        NSDateFormatter *formatter = [self _formatterWithDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
        mapper = [SFDateMapper instanceWithDateFormatter:formatter];
    });
    return mapper;
}


+ (NSDateFormatter *)_formatterWithDateFormat:(NSString *)dateFormat {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    [formatter setLocale:enUSPOSIXLocale];
    [formatter setDateFormat:dateFormat];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    return formatter;
}



@end
