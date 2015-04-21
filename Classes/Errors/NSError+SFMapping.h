//
// Created by Paul Taykalo on 4/20/15.
// Copyright (c) 2015 Stanfy LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SFMapping;

extern NSString * kSFMappingErrorDomain;

typedef NS_ENUM(NSInteger , SFMappingErrorCode) {
    SFMappingErrorCodeUnknown = 0,
    SFMappingErrorCodeCannotPerformMapping = 1,
    SFMappingErrorCodeItemClassDoesNotExists = 2,
};

@interface NSError (SFMapping)

+ (NSError *)sfMappingError;

+ (NSError *)sfMappingErrorWithCode:(SFMappingErrorCode)code message:(NSString *)message;
+ (NSError *)sfMappingErrorWithMessage:(NSString *)message;
+ (NSError *)sfMappingErrorWithError:(NSError *)error;
+ (NSError *)sfMappingErrorWithError:(NSError *)error code:(NSUInteger)code message:(NSString *)message;


+ (NSError *)sfMappingErrorWithMapping:(SFMapping *)mapping object:(NSObject *)object value:(id)value;
+ (NSError *)sfItemClassDoesNotExitsErrorWithMapping:(SFMapping *)mapping object:(NSObject *)object value:(id)value;

@end