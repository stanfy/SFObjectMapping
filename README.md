SFObjectMapping
---------------

[![Build Status](https://travis-ci.org/stanfy/SFObjectMapping.svg?branch=develop)](https://travis-ci.org/stanfy/SFObjectMapping)  [![Coverage Status](https://coveralls.io/repos/stanfy/SFObjectMapping/badge.svg?branch=develop)](https://coveralls.io/r/stanfy/SFObjectMapping?branch=develop)  
Object mapping for parsing dictionaries into object


Install
------

Using CocoaPods

```
pod 'SFMapping', '~> 0.0.4'
```


Using
-----

It's easy to parse JSON into dictionary using JSONKit, but how to parse dictionary into model?

Easy! Like this:

`SMBaseObject * parsedObject = [SFMappingCore instanceOfClass:[SMBaseObject class] fromObject:dictionary];`

All you need to do is to create SMBaseObject and write mapping from dictionary key path to property name.



Implementing
------------


in `SFBaseObject.h`:


```objc
@interface SFBaseObject : NSObject
@property (nonatomic, strong) NSString * ID;
@end
```

somewhere in your code where it's more appropriate for you setup mapping for `SFBaseObject` in format `property name` - `key path`:

```objc
#import "SFMapping.h"
#import "NSObject+SFMapping.h"
+ (void)setupMappingsForModelObjects {
    [SFBaseObject setSFMappingInfo:
      [SFMapping property:@"ID" toKeyPath:@"id"],
    nil];
}
```

Simple properties
----------
Lets look on mapping for different simple properties:


```objc
@property (nonatomic, strong) NSString * pString;
@property (nonatomic, strong) NSNumber * pNumber;
@property (nonatomic, assign) BOOL pBoolean;
```

Mapping:

```objc
#import "SFMapping.h"
#import "NSObject+SFMapping.h"
+ (void)setupMappingsForModelObjects {
    [SFBaseObject setSFMappingInfo:
	[SFMapping property:@"pString" toKeyPath:@"someStringFromDictionary"],
        [SFMapping property:@"pNumber" toKeyPath:@"someNumberFromDictionary"],
        [SFMapping property:@"pBoolean" toKeyPath:@"someBooleanFromDictionary"],  
    nil];
}
```

Arrays
------

If `SFObjectWithArray` has array of `SFArrayItem` objects:

```objc
@interface SFObjectWithArray : NSObject
@property (nonatomic, strong) NSMutableArray * mutableArray;
@property (nonatomic, strong) NSArray * immutableArray;
@end
```

Mapping:

```objc
#import "SFMapping.h"
#import "NSObject+SFMapping.h"
+ (void)setupMappingsForModelObjects {
        [SFObjectWithArray setSFMappingInfo:
         [SFMapping collection:@"mutableArray" itemClass:@"SFArrayItem" toKeyPath:@"someMutableArrayFromDictionary"],   
         [SFMapping collection:@"immutableArray" itemClass:@"SFArrayItem" toKeyPath:@"someArrayFromDictionary"],
         nil];
 }
```

Enums
-------
```objc
typedef NS_ENUM(NSInteger , SFUserGender) {
    SFUserGenderFemale = 0,
    SFUserGenderMale = 1
};

typedef NS_ENUM(NSInteger , SFUserType) {
    SFUserTypeNormal= 0,
    SFUserTypePremium = 1
};

@interface SFUser : NSObject
@property(nonatomic, assign) SFUserGender gender;
@property(nonatomic, assign) SFUserType userType;
@property(nonatomic, copy) NSString * name;
@end
```  

There's two suggested variants how you can map properties.  
First one is to register global mapper with fake classname   
Second one is to use custom mapper right in the mapping definition  

Mapping #1. Using global mapper:  

```objc
/*
Register global mapper for all types of SFUserGender
 */
NSDictionary *userGenderDictionary =
    @{@"female" : @(SFUserGenderFemale),
        @"male" : @(SFUserGenderMale)
    };

// Registering mapper for fake class named SFUserGender
[SFMappingCore registerMapper:
    [SFBlockBasedMapper mapperWithValueTransformBlock:^id(SFMapping *mapping, id value) {
        return value ? userGenderDictionary[value] : nil;
    }] forClass:@"SFUserGender"];

[SFUser setSFMappingInfo:
    // Here we're specifying this property "class", since we registered global mapper for this class previously
    [SFMapping property:@"gender" classString:@"SFUserGender"],       // gender in JSON
    // ....
    nil
];
```
Mapping #2. Using cutom mapper:  

```objc
NSDictionary *userTypeDictionary =
    @{@"premium" : @(SFUserTypePremium),
        @"normal" : @(SFUserTypeNormal)
    };

[SFUser setSFMappingInfo:
    // ,,, 
    // Here we're specifying local mapper which is used only for this mapping
    [SFMapping property:@"userType" keyPath:@"type" valueBlock:^id(SFMapping *mapping, id value) {
       return value ? userTypeDictionary[value] : nil;;
    }],
    nil
];
```

Objects
-------

If object has reference to `SFAnotherObject`:

```objc
@property (nonatomic, strong) SFAnotherObject * anotherObject;
```

Mapping:

```objc
+ (void)setupMappingsForModelObjects {
    [SFBaseObject setSFMappingInfo:
         [SFMapping property:@"anotherObject" toKeyPath:@"someObjectKeyPath"],
    nil];
}
```
In this case, mapper will try to created `SFAnotherObject` and apply mappings to it, by provided rules.  
If there's no mappings found for `SFAnotherObject` then, empty object will be created `[SFAnotherObject new]`  
In case, if mapping found, then those will be applied correctly  

Dates
-----
For parsing dates we're suggesting to use `SFDateMapper` class  
You can use from predefined mappers with some general date formats:  
```objc
/*
 Format  : EEE, dd MMM yyyy HH:mm:ss z
 locale  : en_US_POSIX
 Timezone: UTC
 */
+ (SFDateMapper *)rfc2882DateTimeMapper;

/*
 Format : yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'
 locale : en_US_POSIX
 Timezone: UTC
 */
+ (SFDateMapper *)rfc3339DateTimeMapper;

/*
 Format : yyyy-MM-dd'T'HH:mm:ssZZZZZ
 locale : en_US_POSIX
 Timezone: Defined by format
 */
+ (SFDateMapper *)iso8601DateTimeMapper;
```
or, if you want to create your own, you can create your own mapper for your own, proprietary date format.  
```objc
// Mapper for dates in timestamp(seconds since 1970) format
+ (id<SFMapper>)timestampMapper {
    static dispatch_once_t once;
    static id<SFMapper> mapper;
    dispatch_once(&once, ^{
        mapper = [SFBlockBasedMapper mapperWithValueTransformBlock:^id(SFMapping *mapping, id value) {
            return [NSDate dateWithTimeIntervalSince1970:[value doubleValue]];
        }];
    });
    return mapper;
}

// Mapper for dates in timestamp("/Date(1302055696487)/") format
+ (id<SFMapper>)dotNetTimestampMapper {
    static dispatch_once_t once;
    static id<SFMapper> mapper;
    dispatch_once(&once, ^{
        static NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"/Date()/"];
        mapper = [SFBlockBasedMapper mapperWithValueTransformBlock:^id(SFMapping *mapping, id value) {
            NSString *stringWithTimeStamp = [value stringByTrimmingCharactersInSet:characterSet];
            return [NSDate dateWithTimeIntervalSince1970:[stringWithTimeStamp doubleValue]];
        }];
    });
    return mapper;
}
```
#### When date mapper is chosen  
Once you have date mapper, whether it's `SFDateMapper` subclass, or some custom implementation, you, generally have two ways of using it - registering it's as global mapper for `NSDate` class, or setting it as custom mapper to mappings you want:  
```objc
// Since we know that all dates will be in rfc2882 format,
// We just set global mapper on NSDate class
[SFMappingCore registerMapper:[SFDateMapper rfc2882DateTimeMapper] forClass:@"NSDate"];

[SFActivity setSFMappingInfo:
    // Mapping date by using global date mapper
    [SFMapping property:@"date"],

    // Just in case if we need to map this property differently, we can use custom mapper
    //[[SFMapping property:@"date"] applyCustomMapper:[SFDateMapper rfc3339DateTimeMapper]],
    nil
];
}
```
