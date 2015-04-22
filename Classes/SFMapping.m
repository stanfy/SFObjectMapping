//
//  SFMapping.m
//  SFObjectMapping
//
//  Created by Paul Taykalo on 6/7/12.
//  Copyright (c) 2012 Stanfy LLC. All rights reserved.
//

#import "SFMapping.h"
#import "SFBlockBasedMapper.h"

@implementation SFMapping

- (NSString *)description {
    NSMutableString *str = [NSMutableString string];
    [str appendFormat:@"<%@ : ", [self class]];
    if (_classString) {
        [str appendFormat:@"%@", _classString];
    } else {
        [str appendFormat:@"autodetect"];
    }
    if (_collection) {
        [str appendFormat:@"[%@]", _itemClass];
    }
    [str appendFormat:@" %@ ", _property];
    [str appendFormat:@"<- '%@', ", _keyPath];
    if (_userInfo) {
        [str appendFormat:@"(userInfo:%@), ", _userInfo];
    }
    if (_customParser) {
        [str appendFormat:@", mapped by:%@, ", NSStringFromClass(_customParser.class)];
    }
    [str appendString:@">"];
    return str;
}


#pragma mark - Private initializer -

+ (instancetype)withProperty:(NSString *)property
       classString:(NSString *)classString
        andKeyPath:(NSString *)keyPath
      isCollection:(BOOL)collection
         itemClass:(NSString *)itemClass {
    SFMapping *result = [self new];
    result.property = property;
    result.keyPath = keyPath;
    result.collection = collection;
    result.itemClass = itemClass;
    result.classString = classString;
    return result;
}


#pragma mark - Public initializers -

+ (instancetype)property:(NSString *)property {
    return [self withProperty:property classString:nil andKeyPath:property isCollection:NO itemClass:nil];
}

+ (instancetype)property:(NSString *)property toKeyPath:(NSString *)keyPath {
    return [self withProperty:property classString:nil andKeyPath:keyPath isCollection:NO itemClass:nil];
}


+ (instancetype)property:(NSString *)property classString:(NSString *)classString toKeyPath:(NSString *)keyPath {
    return [self withProperty:property classString:classString andKeyPath:keyPath isCollection:NO itemClass:nil];
}


+ (instancetype)collection:(NSString *)property itemClass:(NSString *)itemClass toKeyPath:(NSString *)keyPath {
    return [self withProperty:property classString:nil andKeyPath:keyPath isCollection:YES itemClass:itemClass];
}


+ (instancetype)collection:(NSString *)property classString:(NSString *)classString itemClass:(NSString *)itemClass toKeyPath:(NSString *)keyPath {
    return [self withProperty:property classString:classString andKeyPath:keyPath isCollection:YES itemClass:itemClass];
}


#pragma mark -

- (id)applyUserInfo:(id)userInfo {
    self.userInfo = userInfo;
    return self;
}


- (id)applyCustomMapper:(id <SFMapper>)customMapper {
    self.customParser = customMapper;
    return self;
}

+ (instancetype)property:(NSString *)property valueBlock:(id (^)(SFMapping *, id))valueTransformer {
    return [[self withProperty:property classString:nil andKeyPath:property isCollection:NO itemClass:nil] applyCustomMapper:[SFBlockBasedMapper mapperWithValueTransformBlock:valueTransformer]];
}

+ (instancetype)property:(NSString *)property keyPath:(NSString *)keypath valueBlock:(id (^)(SFMapping *, id))valueTransformer {
    return [[self withProperty:property classString:nil andKeyPath:keypath isCollection:NO itemClass:nil] applyCustomMapper:[SFBlockBasedMapper mapperWithValueTransformBlock:valueTransformer]];
}


@end
