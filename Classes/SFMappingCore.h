//
//  SFMappingCore.h
//  Nemlig-iPad
//
//  Created by Paul Taykalo on 6/7/12.
//  Copyright (c) 2012 JBC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SFMapper;

@interface SFMappingCore : NSObject


/**
 Perform bindings from specified source object |object| to |objinstance|
 */
+ (BOOL)applyMappingsOnObject:(id)objinstance fromObject:(id)object;
+ (BOOL)applyMappingsOnObject:(id)objinstance fromObject:(id)object error:(NSError **)errors;


/**
 Adds default system mapper for specified classOrStructName

 The idea is next:
 When we're creating object, and object property has X or Struct type,then
this mapper will be used

 etc.
 */
+ (void)registerMapper:(id<SFMapper>)mapper forClass:(NSString *)classOrStructName selector:(SEL)selector DEPRECATED_MSG_ATTRIBUTE("Use registerMapper:forClass: instead");
+ (void)registerMapper:(id<SFMapper>)mapper forClass:(NSString *)classOrStructName;
+ (void)unregister:(id<SFMapper>)mapper forClass:(NSString *)classOrStructName;


/**
 Creates instance of class |objectClass| from specified object as source
 @return id instance of class |objectClass|
 */
+ (id)instanceOfClass:(Class)objectClass fromObject:(id)object;
+ (id)instanceOfClass:(Class)objectClass fromObject:(id)object error:(NSError **)errors;



@end





