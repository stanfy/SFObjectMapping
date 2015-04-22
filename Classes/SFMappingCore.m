//
//  SFMapping.m
//  Nemlig-iPad
//
//  Created by Paul Taykalo on 6/7/12.
//  Copyright (c) 2012 Stanfy LLC. All rights reserved.
//

#import <objc/runtime.h>
#import "SFMappingCore.h"
#import "NSObject+SFMapping.h"
#import "SFMapping.h"
#import "SFMappingRuntime.h"
#import "SFMapper.h"
#import "SFNSNumberMapper.h"
#import "SFNSArrayMapper.h"
#import "SFBOOLMapper.h"
#import "SFNSStringMapper.h"

@implementation SFMappingCore

#pragma mark - Mapping registration


static NSMutableDictionary * _mappers;


+ (void)initialize {
    _mappers = [NSMutableDictionary dictionary];
    
    [self registerMapper:[SFNSNumberMapper new] forClass:@"NSNumber"];
    [self registerMapper:[SFNSArrayMapper new] forClass:@"NSArray"];
    [self registerMapper:[SFNSArrayMapper new] forClass:@"NSMutableArray"];
    [self registerMapper:[SFBOOLMapper new] forClass:@"BOOL"];
    [self registerMapper:[SFNSStringMapper new] forClass:@"NSString"];
}


+ (void)registerMapper:(id<SFMapper>)mapper forClass:(NSString *)classOrStructName selector:(SEL)selector {
    [self registerMapper:mapper forClass:classOrStructName];
}

+ (void)registerMapper:(id<SFMapper>)mapper forClass:(NSString *)classOrStructName {
    _mappers[classOrStructName] = mapper;
}

+ (void)unregister:(id<SFMapper>)mapper forClass:(NSString *)classOrStructName {
    if (_mappers[classOrStructName] == mapper) {
        [_mappers removeObjectForKey:classOrStructName];
    }
}


#pragma mark - Utils

/*
 Returns array fo
 */
+ (NSMutableArray *)filteredMappingsForObject:(id)object {
    NSMutableArray * result = [NSMutableArray array];
    NSMutableSet * set = [[NSMutableSet alloc] init];
    Class currentClass = [object class];
    while (currentClass) {
        NSArray * mappings = [currentClass SFMappingInfo];
        for (SFMapping * mapping in mappings) {
            if (![set containsObject:[mapping property]]) {
                // Setting up correct mapper
                NSString * propertyClassOrStructName = [mapping classString];
                
                // Resolving by property type
                if (!propertyClassOrStructName) {
                    propertyClassOrStructName = [SFMappingRuntime typeForProperty:[mapping property] ofClass:[object class]];
                    
                    // Handling protocols
                    if (propertyClassOrStructName) {
                        NSUInteger openBracketLocation = [propertyClassOrStructName rangeOfString:@"<"].location;
                        if (openBracketLocation != NSNotFound) {
                            propertyClassOrStructName = [propertyClassOrStructName substringToIndex:openBracketLocation];
                        }
                    }
                    mapping.classString = propertyClassOrStructName;
                }
                
                // Most properties will correctly respond on setting NSString
                if (!propertyClassOrStructName) {
                    mapping.classString = @"NSString";
                }
                
                // If we resolved classString or we have customParser, we adding mapping to set
                if (propertyClassOrStructName || [mapping customParser] || mapping.classString) {
                    [set addObject:[mapping property]];
                    [result addObject:mapping];
                }
            }
        }
        currentClass = class_getSuperclass(currentClass);
    }
    
    return result;
}


#pragma mark - Applying Mappings


+ (BOOL)applyMappingsOnObject:(id)objinstance fromObject:(id)object {
    return [self applyMappingsOnObject:objinstance fromObject:object error:nil];
    
}

+ (BOOL)applyMappingsOnObject:(id)destObject fromObject:(id)sourceObject error:(NSError **)error {
    
    if (!sourceObject) {
        return NO;
    }
    // getting mappings
    NSMutableArray * mappings = [self filteredMappingsForObject:destObject];
    
    for (SFMapping * mapping in mappings) {
        
        id value = nil;
        if (mapping.keyPath && [mapping.keyPath length]) {
            value = [sourceObject valueForKeyPath:mapping.keyPath];
        } else {
            value = sourceObject;
        }
        
        // Checking for custom binding custom parsing
        if (mapping.customParser) {
            // TODO : Correct error handling
            [mapping.customParser applyMapping:mapping onObject:destObject withValue:value error:error];
            continue;
        }
        
        // resolving string property class name
        NSString * className = [mapping classString];
        id <SFMapper> mapper = [self mapperForTypeName:className];

        // If we have correct mapper for specified class string
        if (mapper) {
            //TODO : Correct error handling
            [mapper applyMapping:mapping onObject:destObject withValue:value error:error];

        } else {
            if (value && value != [NSNull null]) {
                Class clz = NSClassFromString(className);
                // TODO : Correct instantiation
                id instance = [self instanceOfClass:clz fromObject:value];
                //TODO : Correct error handling
                //  [self applyMappingsOnObject:destObject fromObject:sourceObject error:nil];
                [destObject setValue:instance forKey:[mapping property]];
            }
        }
        
    }
    return YES;
}

#pragma mark - Mapper for class or struct name

+ (id <SFMapper>)mapperForTypeName:(NSString *)classOrStructName {
    id <SFMapper> mapper = _mappers[classOrStructName];
    if (!mapper) {
        // If we have not mapper for this class name
        // We'll search mapper for it's superclass, if any
        Class clz = NSClassFromString(classOrStructName);
        while (!mapper && clz) {
            clz = class_getSuperclass(clz);
            if (clz) {
                mapper = _mappers[NSStringFromClass(clz)];
            }
        }
    }
    return mapper;
}


#pragma mark - Instantiation

+ (id)instanceOfClass:(Class)objectClass fromObject:(id)object {
    return [self instanceOfClass:objectClass fromObject:object error:nil];
    
}


+ (id)instanceOfClass:(Class)objectClass fromObject:(id)sourceObject error:(NSError **)error {
    // TODO : Correct error value
    // Quick instantiation for string sourceObject
    if (objectClass == [NSString class] && sourceObject && [sourceObject isKindOfClass:[NSString class]]) {
        return sourceObject;
    }

    if (objectClass == [NSMutableString class] && sourceObject && [sourceObject isKindOfClass:[NSString class]]) {
        return [(NSString *)sourceObject mutableCopy];
    }

    // Quick instantiation for NSNumber sourceObject
    if (objectClass == [NSNumber class] && sourceObject && [sourceObject isKindOfClass:[NSNumber class]]) {
        return sourceObject;
    }
    
    
    // Create new instance
    id instance = [objectClass new];
    
    // Applying mappings
    [instance applyMappingsFromObject:sourceObject error:error];
    return instance;
}


@end
