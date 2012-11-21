//
//  SFMapper.m
//  Nemlig-iPad
//
//  Created by Paul Taykalo on 6/7/12.
//  Copyright (c) 2012 Stanfy LLC. All rights reserved.
//

#import "SFMapper.h"
#import "SFMappingCore.h"
#import "SFMapping.h"

@implementation SFMapper


- (void)applyMapping:(SFMapping *)mapping onObject:(id)object withValue:(id)value error:(NSError **)error {
   [self setValue:value forKey:mapping.property onObject:object];
   // TODO: Add eerrors handling
}


- (void)setValue:(id)value forKey:(NSString *)key onObject:(id)destObject {
   if (value && destObject) {
      if ([destObject isKindOfClass:[NSDictionary class]]) {
         [destObject setObject:value forKey:key];
      } else {
         [destObject setValue:value forKey:key];
      }
   }
}


@end


#pragma mark - Default mappers

@interface SFBOOLMapper : SFMapper

@end


@implementation SFBOOLMapper

static NSNumber * _falseValue;


- (id)init {
   self = [super init];
   if (self) {
      _falseValue = [NSNumber numberWithBool:NO];
   }
   return self;
}


- (void)applyMapping:(SFMapping *)mapping onObject:(id)object withValue:(id)value error:(NSError **)error {
   // TODO: Perform correct bool mapping
   // Nil
   if (!value || [value isKindOfClass:[NSNull class]]) {
      [self setValue:_falseValue forKey:mapping.property onObject:object];

   } else if ([value isKindOfClass:[NSNumber class]]) {
      //Number
      [self setValue:value forKey:mapping.property onObject:object];


   } else if ([value isKindOfClass:[NSString class]]) {
      //String
      [self setValue:[NSNumber numberWithBool:[value boolValue]] forKey:mapping.property onObject:object];

   } else {
      // TODO: Correct error handling
      NSLog(@"%@ Couldn't convert value : %@ to BOOL", self, value);
      if (error) {
         *error = [NSError errorWithDomain:@"Not implemented mapping" code:-1 userInfo:nil];
      }
   }
}

@end


#pragma mark - Number

@interface SFNSNumberMapper : SFMapper

@end


@implementation SFNSNumberMapper

static NSNumber * _zeroValue;


- (id)init {
   self = [super init];
   if (self) {
      _zeroValue = [NSNumber numberWithBool:NO];
   }
   return self;
}


- (void)applyMapping:(SFMapping *)mapping onObject:(id)object withValue:(id)value error:(NSError **)error {
   if (!value || [value isKindOfClass:[NSNull class]]) {
      // Null
      [self setValue:_zeroValue forKey:mapping.property onObject:object];

   } else if ([value isKindOfClass:[NSNumber class]]) {
      //Number
      [self setValue:value forKey:mapping.property onObject:object];


   } else if ([value isKindOfClass:[NSString class]]) {
      //String
      [self setValue:[NSNumber numberWithDouble:[value doubleValue]] forKey:mapping.property onObject:object];

   } else {
      // TODO: Correct error handling
      NSLog(@"%@ Couldn't convert value : %@ to Number", self, value);
      if (error) {
         *error = [NSError errorWithDomain:@"Not implemented mapping" code:-1 userInfo:nil];
      }
   }
}

@end

#pragma mark - Number

@interface SFNSStringMapper : SFMapper

@end


@implementation SFNSStringMapper

- (void)applyMapping:(SFMapping *)mapping onObject:(id)object withValue:(id)value error:(NSError **)error {
   if (!value || [value isKindOfClass:[NSNull class]]) {
      // Null
      [self setValue:nil forKey:mapping.property onObject:object];

   } else if ([value isKindOfClass:[NSNumber class]]) {
      //Number
      [self setValue:[value stringValue] forKey:mapping.property onObject:object];


   } else if ([value isKindOfClass:[NSString class]]) {
      //String
      [self setValue:value forKey:mapping.property onObject:object];

   } else {
      // TODO: Correct error handling
      NSLog(@"%@ Couldn't convert value : %@ to NSString", self, value);
      if (error) {
         *error = [NSError errorWithDomain:@"Not implemented mapping" code:-1 userInfo:nil];
      }
   }
}

@end


@interface SFNSArrayMapper : SFMapper

@end


@implementation SFNSArrayMapper

- (void)applyMapping:(SFMapping *)mapping onObject:(id)object withValue:(id)value error:(NSError **)error {

   NSMutableArray * result = nil;

   if (mapping.collection) {

      if ([value isKindOfClass:[NSArray class]]) {
         NSString * itemClassString = mapping.itemClass;
         Class clz = NSClassFromString(itemClassString);
         if (clz) {
            result = [NSMutableArray array];
            for (id sourceObject in value) {
               id item = [SFMappingCore instanceOfClass:clz fromObject:sourceObject];
               [result addObject:item];
            }
            [self setValue:result forKey:mapping.property onObject:object];
         }
      } else {

      }
   } else {

      // TODO : Correct handling NSArray as not collection
      // What should we do here instantiate array with what ?

      NSLog(@"%@ Couldn't convert value : %@ to NSArray", self, value);
      if (error) {
         *error = [NSError errorWithDomain:@"Not implemented mapping" code:-1 userInfo:nil];
      }

   }
}

@end


