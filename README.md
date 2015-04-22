SFObjectMapping
---------------

[![Build Status](https://travis-ci.org/stanfy/SFObjectMapping.svg?branch=develop)](https://travis-ci.org/stanfy/SFObjectMapping)  [![Coverage Status](https://coveralls.io/repos/stanfy/SFObjectMapping/badge.svg?branch=develop)](https://coveralls.io/r/stanfy/SFObjectMapping?branch=develop)  
Object mapping for parsing dictionaries into object


Install
------

Using CocoaPods

`pod 'SFMapping', :git => 'https://github.com/stanfy/SFObjectMapping.git', :tag => '0.0.3'` 


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
@property (nonatomic, strong) NSMutableArray * immutableArray;
@end
```

Mapping:

```objc
#import "SFMapping.h"
#import "NSObject+SFMapping.h"
+ (void)setupMappingsForModelObjects {
        [SFObjectWithArray setSFMappingInfo:
         [SFMapping collection:@"mutableArray" classString:@"NSMutableArray" 
            itemClass:@"SFArrayItem" toKeyPath:@"someMutableArrayFromDictionary"],         
         [SFMapping collection:@"immutableArray" classString:@"NSArray" 
            itemClass:@"SFArrayItem" toKeyPath:@"someArrayFromDictionary"],
         nil];
 }
```

Enums
-------
There's two suggested variants how you can map properties.  
First one is to register global mapper with fake classname   
Second one is to use custom mapper right in the mapping definition  
```objc
/*
Register global mapper for all types of SFUserGender
 */
NSDictionary *userGenderDictionary =
    @{@"female" : @(SFUserGenderFemale),
        @"male" : @(SFUserGenderMale)
    };

NSDictionary *userTypeDictionary =
    @{@"premium" : @(SFUserTypePremium),
        @"normal" : @(SFUserTypeNormal)
    };
    
// Registering mapper for fake class named SFUserGender
[SFMappingCore registerMapper:
    [SFBlockBasedMapper mapperWithValueTransformBlock:^id(SFMapping *mapping, id value) {
        return value ? userGenderDictionary[value] : nil;
    }] forClass:@"SFUserGender"];


[SFUser setSFMappingInfo:
    // Simple mapping
    [SFMapping property:@"name"],

    // Here we're specifying this property "class", since we registered global mapper for this class previously
    [SFMapping property:@"gender" classString:@"SFUserGender"],       // gender in JSON

    // Here we're specifying custom mapper which is used only for this mapping
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
There are 2 ways for parsing date (usually it's date string from server in any ISO format like `yyyy-MM-dd HH:mm:ss`):
 
1. parse to string, then convert it to date 
2. create custom mapper.


#### Parse NSDate into String, then translate into NSDate


in .h file create date property:

```objc
@property (nonatomic, strong) NSDate * date;
```

in class extension create inner (private) string property:

```objc
@property (nonatomic, strong) NSString * stringDate;
```

mapping string to string:

```objc
[SFMapping property:@"stringDate" toKeyPath:@"dateFromDictionary"]
```

transform string to date:

```
- (NSString *)date {
    if (!_date) {
	    NSDateFormatter *formatter = [NSDateFormatter new];
      	[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    	_date = [formatter dateFromString:_stringDate];
    }
    return _date;
}
```


#### Create custom date mapper and apply it in mapping

in .h file create date property:

```objc
@property (nonatomic, strong) NSDate * date;
```

mapping parse date string from dictionary already into NSDate:

```objc
 [[SFMapping property:@"date" toKeyPath:@"dateFromDictionary"] applyCustomMapper:[SMDateMapper sharedInstance]],
```

custom date mapper (successor of SFDateMapper):

```objc
@interface SMDateMapper : SFDateMapper

/*
Returns fully initialized Date mapper with
yyyy-MM-dd HH:mm:ss Z format
 */
+ (SMDateMapper *)sharedInstance;


@end
```

```objc

@implementation SMDateMapper

+ (SMDateMapper *)sharedInstance {
   static SMDateMapper * _instance = nil;
   static dispatch_once_t onceToken;
   
   dispatch_once(&onceToken, ^{
      NSDateFormatter * dateFormatter = [SFDateFormatterUtils dateFormatterWithFormat:@"yyyy-MM-dd HH:mm:ss" andLocale:@"en_US_POSIX"];
      dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
      _instance = [[self class] instanceWithDateFormatter:dateFormatter];
   });
   
   return _instance;
}

@end
```
