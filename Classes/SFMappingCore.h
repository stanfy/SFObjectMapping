//
//  SFMappingCore.h
//  Nemlig-iPad
//
//  Created by Paul Taykalo on 6/7/12.
//  Copyright (c) 2012 JBC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFMappingCore : NSObject


/**
 Perform bindings from specified XML |element| to |objinstance|
 */
+ (BOOL)applyMappingsOnObject:(id)objinstance fromObject:(id)object;
+ (BOOL)applyMappingsOnObject:(id)objinstance fromObject:(id)object error:(NSError **)errors;


/**
 Adds mapper.
 Selector signature is not specified
 
 It can be any selector with 3 parameters
 1-st parameter is |bind| info of SFXMLBind class
 2-nd parameter is |object| on which binding should be parsed
 3-th parameter is XML |nodes| that was resolved by xpath
 
 +(BOOL)applyNSArrayBinding:(SFXMLBind *)bind onObject:(id)object withNodes:(NSArray *)nodes;
 +(BOOL)applyCGSizeBinding:(SFXMLBind *)bind onObject:(id)object withNodes:(NSArray *)nodes;
 etc.
 */
+ (void)registerMapper:(id)mapper forClass:(NSString *)classOrStructname selector:(SEL)selector;


/**
 Creates instance of class |objectClass| from specified object as source
 @return id instance of class |objectClass|
 */
+ (id)instanceOfClass:(Class)objectClass fromObject:(id)object;
+ (id)instanceOfClass:(Class)objectClass fromObject:(id)object error:(NSError **)errors;



@end





