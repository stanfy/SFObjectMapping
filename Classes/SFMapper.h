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
 Can be used for adding specifical simple types binding.
 
 I.e.
 
 + (BOOL)applyMapping:(SFMapping *)mapping onObject:(id)object fromObject:(id)sourceObject error:(NSError **)error;
 
 [SFMappingCore addXMLBindingParser:self for:@"NSArray" selector:@selector(applyNSArrayBinding:onObject:withNodes:)];
 
 */
@protocol SFMapper<NSObject>


/**
 Applies mapping logic for specified object
 Value was already resolved from source object
 */
- (void)applyMapping:(SFMapping *)mapping onObject:(id)object withValue:(id)value error:(NSError **)error;


/**
 TODO:
 */
- (void)setValue:(id)value forKey:(NSString *)key onObject:(id)object;


@end



/**
 Base Mapper
 */
@interface SFMapper : NSObject<SFMapper>

@end