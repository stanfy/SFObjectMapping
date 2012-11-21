//
//  SFMapping.m
//  Nemlig-iPad
//
//  Created by Paul Taykalo on 6/7/12.
//  Copyright (c) 2012 JBC. All rights reserved.
//

#import <objc/runtime.h>
#import "SFMappingCore.h"
#import <StanfyCore/SFRuntime.h>
#import "NSObject+SFMapping.h"
#import "SFMapping.h"

@implementation SFMappingCore

#pragma mark - Mapping registration


static NSMutableDictionary * _mappers;


+ (void)initialize {
   _mappers = [NSMutableDictionary dictionary];

   // We have alot of parsers
   // So we adding parser instance for each parse type
   // Parser class format is SFXMLBinding<_type_>Parser
   // SFXMLBindingNSNumberParser
   // SFXMLBindingNSStringParser
   // etc
   NSArray * parseTypes =
    [NSArray arrayWithObjects:
     @"NSNumber",
     @"NSString",
     @"NSArray",
     @"BOOL",
     nil];

   // Adding mapper for each map name
   for (NSString * parseType in parseTypes) {
      Class mapperClass = NSClassFromString([NSString stringWithFormat:@"SF%@Mapper", parseType]);
      id mapperInstance = [mapperClass new];
      SEL parserSelector = @selector(applyMapping:onObject:withValue:error:);
      if (mapperInstance) {
         [self registerMapper:mapperInstance forClass:parseType selector:parserSelector];
      }
   }
}


+ (void)registerMapper:(id)mapper forClass:(NSString *)classOrStructname selector:(SEL)selector {
   [_mappers setObject:mapper forKey:classOrStructname];
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
               propertyClassOrStructName = [SFRuntime typeForProperty:[mapping property] ofClass:[object class]];
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


/*
  Mapper info is array with two items:
  [0] Mapper
  [1] selector in always applyMapping:onObject:fromObject:error:
 */
+ (void)performMappingWithMapperInfo:(id<SFMapper>)mapper mapping:(SFMapping *)mapping objInstance:(id)objinstance value:(id)value error:(NSError **)error {
   SEL mapperSelector = @selector(applyMapping:onObject:withValue:error:);
   if (mapperSelector && [mapper respondsToSelector:mapperSelector]) {
      [mapper applyMapping:mapping onObject:objinstance withValue:value error:error];
   } else {
      // TODO : Do correct error handling
      //SFCLog(@"parser", @"Couldnt find method signature for selector : %@ of %@", NSStringFromSelector(mapperSelector), mapper);
   }
}


#pragma mark - Applying Mappings


+ (id)applyMappingsOnObject:(id)objinstance fromObject:(id)object {
   return [self applyMappingsOnObject:objinstance fromObject:object error:nil];

}


+ (id)applyMappingsOnObject:(id)destObject fromObject:(id)sourceObject error:(NSError **)error {

   if (!sourceObject) {
      return destObject;
   }
   // getting mappings
   NSMutableArray * mappings = [self filteredMappingsForObject:destObject];

   for (SFMapping * mapping in mappings) {


      id value = [sourceObject valueForKeyPath:mapping.keyPath];

      // Checking for custom binding custom parsing
      if (mapping.customParser) {
         // TODO : Correct error handling
         [mapping.customParser applyMapping:mapping onObject:destObject withValue:value error:nil];
         continue;
      }

      // resolving string property class name
      NSString * className = [mapping classString];
      id<SFMapper> mapper = [_mappers objectForKey:className];

      if (!mapper) {

         // If we have not mapper for this class name
         // We'll search mapper for it's superclass, if any
         Class clz = NSClassFromString(className);
         while (!mapper && clz) {
            clz = class_getSuperclass(clz);
            if (clz) {
               mapper = [_mappers objectForKey:NSStringFromClass(clz)];
            }
         }
      }

      SEL mapperSelector = @selector(applyMapping:onObject:withValue:error:);

      // If we have correct mapper for specified class string
      if (mapperSelector && [mapper respondsToSelector:mapperSelector]) {
         //TODO : Correct error handling
         [self performMappingWithMapperInfo:mapper mapping:mapping objInstance:destObject value:value error:nil];
      } else {
         if (sourceObject) {
            Class clz = NSClassFromString(className);
            id instance = [self instanceOfClass:clz fromObject:value];
            //TODO : Correct error handling
          //  [self applyMappingsOnObject:destObject fromObject:sourceObject error:nil];
            [destObject setValue:instance forKey:[mapping property]];
         }
      }

   }
   return destObject;

}


+ (id)instanceOfClass:(Class)objectClass fromObject:(id)object {
   return [self instanceOfClass:objectClass fromObject:object error:nil];

}


+ (id)instanceOfClass:(Class)objectClass fromObject:(id)sourceObject error:(NSError **)error {
   // TODO : Correct error value
   // Quick instantiation for string sourceObject
   if (objectClass == [NSString class] && sourceObject && [sourceObject isKindOfClass:[NSString class]]) {
      return sourceObject;
   }

   // Create new instance
   id instance = [objectClass new];

   // Applying mappings
   [instance applyMappingsFromObject:sourceObject];
   return instance;
}


@end
