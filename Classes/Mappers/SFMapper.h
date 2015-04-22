//
//  SFMapper.h
//  Nemlig-iPad
//
//  Created by Paul Taykalo on 6/7/12.
//  Copyright (c) 2012 Stanfy LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SFMapping;

/**
 Virtual protocol for SFMapper
 
 Exists just for parameters order specification for mappers.
 Can be used for adding specific simple types binding.
 
 I.e.
 
 [SFMappingCore registerMapper:[SFMapper new] forClass:@"NSArray"];
 
 */
@protocol SFMapper<NSObject>


/**
 Applies mapping logic for specified object
 Value was already resolved from source object
 */
- (BOOL)applyMapping:(SFMapping *)mapping onObject:(id)object withValue:(id)value error:(NSError **)error;


@end


/**
 Base Mapper with default applyMapping:onObject:withValue:error:
 and setValue:forKey:onObject: implementations
 */
@interface SFMapper : NSObject<SFMapper>

/**
Sets specified value for specified key on specified object
In general it should do
object[key] = value
*/
- (BOOL)setValue:(id)value forKey:(NSString *)key onObject:(id)object;

@end