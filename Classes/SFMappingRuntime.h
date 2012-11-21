//
//  SFMappingRuntime
//  Pods
//
//  Created by Paul Taykalo on 11/21/12.
//  Copyright (c) 2012 Stanfy LLC. All rights reserved.
//
#import <Foundation/Foundation.h>


@interface SFMappingRuntime : NSObject

/**
 Identifies type of the |propertyName| in |objectClass|
 @return NSString string name of the property type
 */
+ (NSString *)typeForProperty:(NSString *)propertyName ofClass:(Class)objectClass;


@end