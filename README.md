SFObjectMapping
---------------

[![Build Status](https://travis-ci.org/stanfy/SFObjectMapping.svg?branch=develop)](https://travis-ci.org/stanfy/SFObjectMapping)  
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
#import "NSObject+SFMapping.h"

@interface SFBaseObject : NSObject

@property (nonatomic, strong) NSString * ID;

@end
```

in `SFBaseObject.m` add initialize method with mapping in format `property name` - `key path`:

```objc
+ (void)initialize {
    if (self == [SFBaseObject class]) {
        [self setSFMappingInfo:
         [SFMapping property:@"ID" toKeyPath:@"id"],
         nil];
    }
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
+ (void)initialize {
    if (self == [SFBaseObject class]) {
        [self setSFMappingInfo:
            [SFMapping property:@"pString" toKeyPath:@"someStringFromDictionary"],
            [SFMapping property:@"pNumber" toKeyPath:@"someNumberFromDictionary"],
            [SFMapping property:@"pBoolean" toKeyPath:@"someBooleanFromDictionary"],
        nil];
    }
}
```

Arrays
------

If object has array of `SFArrayItem` objects:

```objc
@property (nonatomic, strong) NSMutableArray * mutableArray;
@property (nonatomic, strong) NSMutableArray * immutableArray;

```

Mapping:

```objc
+ (void)initialize {
    if (self == [SFObjectWithArray class]) {
        [self setSFMappingInfo:
         [SFMapping collection:@"mutableArray" classString:@"NSMutableArray" 
            itemClass:@"SFArrayItem" toKeyPath:@"someMutableArrayFromDictionary"],         
         [SFMapping collection:@"immutableArray" classString:@"NSArray" 
            itemClass:@"SFArrayItem" toKeyPath:@"someArrayFromDictionary"],
         nil];
    }
}
```

Objects
-------

If object has reference to `SFAnotherObject`:

```objc
@property (nonatomic, strong) SFAnotherObject * anotherObject;
```

Mapping:

```objc
+ (void)initialize {
    if (self == [SFBaseObject class]) {
        [self setSFMappingInfo:
         [SFMapping property:@"anotherObject" toKeyPath:@"someObjectKeyPath"],
         nil];
    }
}
```

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
