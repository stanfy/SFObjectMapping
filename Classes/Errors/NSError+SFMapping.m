//
// Created by Paul Taykalo on 4/20/15.
// Copyright (c) 2015 Stanfy LLC. All rights reserved.
//

#import "NSError+SFMapping.h"
#import "SFMapping.h"

NSString *kSFMappingErrorDomain = @"com.stanfy.sfmapping";


@implementation NSError (SFMapping)


+ (NSError *)sfMappingError {
    return [NSError sfMappingErrorWithError:nil code:SFMappingErrorCodeUnknown message:nil];
}

+ (NSError *)sfMappingErrorWithCode:(NSUInteger)code message:(NSString *)message {
    return [NSError sfMappingErrorWithError:nil code:code message:message];
}


+ (NSError *)sfMappingErrorWithMessage:(NSString *)message {
    return [NSError sfMappingErrorWithError:nil code:SFMappingErrorCodeUnknown message:message];
}

+ (NSError *)sfMappingErrorWithError:(NSError *)error {
    return [NSError sfMappingErrorWithError:error code:SFMappingErrorCodeUnknown message:error.localizedDescription];
}

+ (NSError *)sfMappingErrorWithError:(NSError *)error code:(NSUInteger)code message:(NSString *)message {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    if (error) {
        userInfo[NSUnderlyingErrorKey] = error;
    }

    if (message) {
        userInfo[NSLocalizedDescriptionKey] = message;
    }
    return [NSError errorWithDomain:kSFMappingErrorDomain code:code userInfo:userInfo];
}


+ (NSError *)sfMappingErrorWithMapping:(SFMapping *)mapping object:(NSObject *)object value:(id)value {
    return [self sfMappingErrorWithCode:SFMappingErrorCodeCannotPerformMapping message:[NSString stringWithFormat:@"Cannot apply mapping %@  with value %@ on %@", mapping, value , NSStringFromClass(object.class)]];
}


@end