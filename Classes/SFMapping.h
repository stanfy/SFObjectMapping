//
//  SFMapping.h
//  SFObjectMapping
//
//  Created by Paul Taykalo on 6/7/12.
//  Copyright (c) 2012 Stanfy LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFMapper.h"

@interface SFMapping : NSObject

@property (nonatomic, copy) NSString * property;
@property (nonatomic, copy) NSString * classString;
@property (nonatomic, copy) NSString * keyPath;
@property (nonatomic, copy) NSString * itemClass;
@property (nonatomic, assign) BOOL collection;
@property (nonatomic, strong) id userInfo;
@property (nonatomic, strong) id<SFMapper> customParser;


/**
Creates binding information for |property| name to |property| keypath
Property class is determined at runtime
@return SFMapping
*/
+ (id)property:(NSString *)property;

/**
 Creates binding information for |property| name to |keyPath|
 Property class is determined at runtime
 @return SFMapping
 */
+ (id)property:(NSString *)property toKeyPath:(NSString *)keyPath;


/**
 Creates binding information for |property| name of class |classString| to |keyPath|
 Since property class is specified, works a little bit faster than previous function
 @return SFMapping
 */
+ (id)property:(NSString *)property classString:(NSString *)classString toKeyPath:(NSString *)keyPath;


/**
 Binds collection |property|(NSArray, NSSet) with items of |itemClass| to |keyPath|
 Collection property class is determined at runtime
 @return SFMapping
 */
+ (id)collection:(NSString *)property itemClass:(NSString *)itemClass toKeyPath:(NSString *)keyPath;


/**
 Binds collection |property|(NSArray, NSSet) with items of |itemClass| to |keyPath|
 Since collection property class is specified, works a little bit faster than previous function
 @return SFMapping
 */
+ (id)collection:(NSString *)property classString:(NSString *)classString itemClass:(NSString *)itemClass toKeyPath:(NSString *)keyPath;


/**
 Sets any user info for mapping.
 @return SFMapping
 */
- (id)applyUserInfo:(id)userInfo;


/**
 Applies custom parser to current mapping
 @return self
 */
- (id)applyCustomMapper:(id<SFMapper>)customMapper;

@end