//
// Created by Paul Taykalo on 4/22/15.
// Copyright (c) 2015 Stanfy LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFMapper.h"

@class SFMapping;


/*
Block based mapper is a mapper that use valueTransformBlock in order to
transform input value to some in-app object representation
 */
@interface SFBlockBasedMapper : SFMapper

/*
Block that is responsible for transforming specified |value| to some transformed value
 */
@property(nonatomic, copy) id (^valueTransformBlock)(SFMapping *mapping, id value);

/*
 Creates block based mapper with specified transform block
 */
- (instancetype)initWithValueTransformBlock:(id (^)(SFMapping *mapping, id value))valueTransformBlock;

/*
 Creates block based mapper with specified transform block
 */
+ (instancetype)mapperWithValueTransformBlock:(id (^)(SFMapping *maping, id value))valueTransformBlock;


@end