//
//  NSObject(SFObjectMapping)
//  SFObjectMapping
//
//  Created by Paul Taykalo on 6/7/12.
//  Copyright (c) 2012 Stanfy LLC. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface NSObject (SFMapping)

/**
 Returns mappings info, which is simple NSArray with items of class SFMapping
 @return NSArray
 */
+ (NSArray *)SFMappingInfo;


/**
 Sets XML binding info for specified class.
 Can be setted in any time, but it is desirable that it should be in +initialize method
 */
+ (void)setSFMappingInfo:(id)object, ... NS_REQUIRES_NIL_TERMINATION;


/**
 Applies mappings from specified object to self.
 */
- (BOOL)applyMappingsFromObject:(id)sourceObject;
- (BOOL)applyMappingsFromObject:(id)sourceObject error:(NSError **)error;


@end