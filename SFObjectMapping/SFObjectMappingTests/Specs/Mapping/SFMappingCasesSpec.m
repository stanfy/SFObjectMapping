//
//  SFMappingCasesSpec.m
//  SFObjectMapping
//
//  Created by Paul Taykalo on 4/21/15.
//  Copyright 2015 Stanfy LLC. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "SFMappingCore.h"
#import "TestProperty.h"
#import "NSObject+SFMapping.h"
#import "SFMapping.h"
#import "SFDateMapper.h"
#import "TestPropertiesWithProtocols.h"


SPEC_BEGIN(SFMappingCasesSpec)

describe(@"SFMappingCore", ^{
    it(@"should be able to get intance of specified class", ^{
        [SFMappingCore instanceOfClass:TestProperty.class fromObject:nil];
    });
    it(@"should return instance of class was specified", ^{
        id o = [SFMappingCore instanceOfClass:TestProperty.class fromObject:nil];
        [[o shouldNot] beNil];
        [[o should] beKindOfClass:TestProperty.class];
    });

    context(@"When mapping BOOL property", ^{
        __block TestProperty * object;
        context(@"And mapping is found", ^{
            beforeEach(^{
                [TestProperty setSFMappingInfo:[SFMapping property:@"boolProperty" toKeyPath:@"value"], nil];
            });
            it(@"should be mapped from dictionary @YES", ^{
                object = [SFMappingCore instanceOfClass:[TestProperty class] fromObject:@{@"value" : @YES}];
                [[theValue(object.boolProperty) should] beTrue];
            });
            it(@"should be mapped from dictionary @NO", ^{
                object = [SFMappingCore instanceOfClass:[TestProperty class] fromObject:@{@"value" : @NO}];
                [[theValue(object.boolProperty) should] beFalse];
            });
            it(@"should be mapped from dictionary (True)", ^{
                object = [SFMappingCore instanceOfClass:[TestProperty class] fromObject:@{@"value" : @"True"}];
                [[theValue(object.boolProperty) should] beTrue];
            });
            it(@"should be mapped from dictionary (False)", ^{
                object = [SFMappingCore instanceOfClass:[TestProperty class] fromObject:@{@"value" : @"False"}];
                [[theValue(object.boolProperty) should] beFalse];
            });
            it(@"should be mapped from dictionary (YES)", ^{
                object = [SFMappingCore instanceOfClass:[TestProperty class] fromObject:@{@"value" : @"y"}];
                [[theValue(object.boolProperty) should] beTrue];
            });
            it(@"should be mapped from dictionary (NO)", ^{
                object = [SFMappingCore instanceOfClass:[TestProperty class] fromObject:@{@"value" : @"n"}];
                [[theValue(object.boolProperty) should] beFalse];
            });
            it(@"should be mapped from dictionary '1'", ^{
                object = [SFMappingCore instanceOfClass:[TestProperty class] fromObject:@{@"value" : @"2"}];
                [[theValue(object.boolProperty) should] beTrue];
            });
            it(@"should be mapped from dictionary '0'", ^{
                object = [SFMappingCore instanceOfClass:[TestProperty class] fromObject:@{@"value" : @"0"}];
                [[theValue(object.boolProperty) should] beFalse];
            });
        });
    });

    context(@"When mapping collection property", ^{
        __block TestProperty * object;
        context(@"NSArray", ^{
            beforeEach(^{
                [TestProperty setSFMappingInfo:[SFMapping collection:@"arrayProperty" itemClass:@"NSString" toKeyPath:@"value"], nil];
            });
            it(@"should be mapped correctly", ^{
                object = [SFMappingCore instanceOfClass:[TestProperty class] fromObject:@{@"value" : @[ @"1", @"2"]}];
                [[object.arrayProperty shouldNot] beNil];
                [[object.arrayProperty should] equal:@[ @"1", @"2"]];
            });
        });

        context(@"NSMutableArray", ^{
            beforeEach(^{
                [TestProperty setSFMappingInfo:[SFMapping collection:@"mutableArrayProperty" itemClass:@"NSString" toKeyPath:@"value"], nil];
            });
            it(@"should be mapped correctly", ^{
                object = [SFMappingCore instanceOfClass:[TestProperty class] fromObject:@{@"value" : @[ @"1", @"2"]}];
                [[object.mutableArrayProperty shouldNot] beNil];
                [[object.mutableArrayProperty should] equal:@[ @"1", @"2"]];
            });
        });

    });



    context(@"When mapping Numbers property", ^{
        __block TestProperty * object;
        context(@"And mapping is found", ^{
            beforeEach(^{
                [TestProperty setSFMappingInfo:
                    [SFMapping property:@"numberProperty" toKeyPath:@"value"],
                    [SFMapping property:@"intProperty" toKeyPath:@"value"],
                    [SFMapping property:@"longProperty" toKeyPath:@"value"],
                    [SFMapping property:@"floatProperty" toKeyPath:@"value"],
                    [SFMapping property:@"doubleProperty" toKeyPath:@"value"],
                        nil];
            });
            it(@"should be mapped from dictionary [NSNull null]", ^{
                object = [SFMappingCore instanceOfClass:[TestProperty class] fromObject:@{@"value" : [NSNull null]}];
                [[object.numberProperty should] equal:@0];
                [[theValue(object.intProperty) should] equal:theValue(0)];
                [[theValue(object.longProperty) should] equal:theValue(0)];
                [[theValue(object.floatProperty) should] equal:theValue(0)];
                [[theValue(object.doubleProperty) should] equal:theValue(0)];
            });


            it(@"should be mapped from dictionary when value is float (15.5)", ^{
                object = [SFMappingCore instanceOfClass:[TestProperty class] fromObject:@{@"value" : @15.5}];
                [[object.numberProperty should] equal:@15.5];
                [[theValue(object.intProperty) should] equal:theValue(15)];
                [[theValue(object.longProperty) should] equal:theValue(15)];
                [[theValue(object.floatProperty) should] equal:theValue(15.5)];
                [[theValue(object.doubleProperty) should] equal:theValue(15.5)];
            });

            it(@"should be mapped from dictionary when value is float (-20)", ^{
                object = [SFMappingCore instanceOfClass:[TestProperty class] fromObject:@{@"value" : @(-20)}];
                [[object.numberProperty should] equal:@-20];
                [[theValue(object.intProperty) should] equal:theValue(-20)];
                [[theValue(object.longProperty) should] equal:theValue(-20)];
                [[theValue(object.floatProperty) should] equal:theValue(-20)];
                [[theValue(object.doubleProperty) should] equal:theValue(-20)];
            });

            it(@"should be mapped from dictionary when value is string '15.5'", ^{
                object = [SFMappingCore instanceOfClass:[TestProperty class] fromObject:@{@"value" : @"15.5"}];
                [[object.numberProperty should] equal:@15.5];
                [[theValue(object.intProperty) should] equal:theValue(15)];
                [[theValue(object.longProperty) should] equal:theValue(15)];
                [[theValue(object.floatProperty) should] equal:theValue(15.5)];
                [[theValue(object.doubleProperty) should] equal:theValue(15.5)];
            });

        });
    });


    context(@"When mapping with custom mapper", ^{
        __block TestProperty * object;
        __block id<SFMapper> customMapper;
        __block id mapping;

        context(@"And mapping is found", ^{
            beforeEach(^{
                customMapper = [KWMock nullMockForProtocol:@protocol(SFMapper)];
                mapping = [[SFMapping property:@"dateProperty" toKeyPath:@"value"] applyCustomMapper:customMapper];
                [TestProperty setSFMappingInfo:mapping, nil];
            });
            it(@"should call custom mapper with mapping and value", ^{
                NSNull *value = [NSNull null];
                [[(KWMock *)customMapper should] receive:@selector(applyMapping:onObject:withValue:error:) withArguments:mapping, [KWAny any], value, nil];
                object = [SFMappingCore instanceOfClass:[TestProperty class] fromObject:@{@"value" : value}];
            });
        });
    });

    context(@"When global mapper registered", ^{
        __block TestProperty * object;
        __block id<SFMapper> globalMapper;
        __block id<SFMapper> customMapper;
        __block id mapping;
        beforeEach(^{
            globalMapper = [KWMock nullMockForProtocol:@protocol(SFMapper)];
            [SFMappingCore registerMapper:globalMapper forClass:@"CGRect"];
        });

        afterEach(^{
            [SFMappingCore unregister:globalMapper forClass:@"CGRect"];
        });

        context(@"And mapping is found", ^{
            beforeEach(^{
                mapping = [SFMapping property:@"rectProperty" toKeyPath:@"value"];
                [TestProperty setSFMappingInfo:mapping, nil];
            });
            it(@"should call global mapper with mapping and value", ^{
                NSNull *value = [NSNull null];
                [[(KWMock *) globalMapper should] receive:@selector(applyMapping:onObject:withValue:error:) withArguments:mapping, [KWAny any], value, nil];
                object = [SFMappingCore instanceOfClass:[TestProperty class] fromObject:@{@"value" : value}];
            });
        });

        context(@"And custom mapper is set on mapping", ^{
            beforeEach(^{
                customMapper = [KWMock nullMockForProtocol:@protocol(SFMapper)];
                mapping = [[SFMapping property:@"rectProperty" toKeyPath:@"value"] applyCustomMapper:customMapper];
                [TestProperty setSFMappingInfo:mapping, nil];
            });
            it(@"should not call global mapper with mapping and value", ^{
                NSNull *value = [NSNull null];
                [[(KWMock *) globalMapper shouldNot] receive:@selector(applyMapping:onObject:withValue:error:) withArguments:mapping, [KWAny any], value, nil];
                object = [SFMappingCore instanceOfClass:[TestProperty class] fromObject:@{@"value" : value}];
            });
            it(@"should call custom mapper with mapping and value", ^{
                NSNull *value = [NSNull null];
                [[(KWMock *)customMapper should] receive:@selector(applyMapping:onObject:withValue:error:) withArguments:mapping, [KWAny any], value, nil];
                object = [SFMappingCore instanceOfClass:[TestProperty class] fromObject:@{@"value" : value}];
            });
        });
    });

    context(@"When userInfo is set on SFMapping", ^{
        __block SFMapping * mapping;
        __block NSObject * userInfo;

        beforeEach(^{
            userInfo = [NSObject new];
            mapping = [[SFMapping property:@"dateProperty" toKeyPath:@"value"] applyUserInfo:userInfo];
        });

        it(@"should be accessible via userInfo property", ^{
            [[[mapping userInfo] shouldNot] beNil];
            [[[mapping userInfo] should] equal:userInfo];
        });
    });

    context(@"When only property is specified on SFMapping", ^{
        __block TestProperty * object;
        __block id mapping;

        it(@"should correctly get value from the same keypath as property", ^{
            mapping = [SFMapping property:@"numberProperty"];
            [TestProperty setSFMappingInfo:mapping, nil];
            NSNumber *value = @12;
            object = [SFMappingCore instanceOfClass:[TestProperty class] fromObject:@{@"numberProperty" : value}];
            [[[object numberProperty] should] equal:value];
        });
    });


    context(@"When keypath is empty in mapping", ^{
        __block TestProperty * object;
        __block id mapping;

        it(@"should use source object itself as value", ^{
            mapping = [SFMapping property:@"numberProperty" toKeyPath:@""];
            [TestProperty setSFMappingInfo:mapping, nil];
            NSNumber *value = @12;
            object = [SFMappingCore instanceOfClass:[TestProperty class] fromObject:value];
            [[[object numberProperty] should] equal:value];
        });
    });


    context(@"When using instanceOfClass", ^{
        __block Class cls;
        __block id object;
        context(@"with NSString", ^{
            beforeEach(^{
                cls = [NSString class];
            });

            it(@"should ceate NSString object with the same value", ^{
                NSString *value = @"COOL";
                object = [SFMappingCore instanceOfClass:cls fromObject:value];
                [[object should] equal:value];
            });
        });

        context(@"with NSMutabnleString", ^{
            beforeEach(^{
                cls = [NSMutableString class];
            });

            it(@"should ceate NSString object with the same value", ^{
                NSString *value = @"COOL";
                object = [SFMappingCore instanceOfClass:cls fromObject:value];
                [[object should] equal:value];
            });
        });

        context(@"with NSNumber", ^{
            beforeEach(^{
                cls = [NSNumber class];
            });

            it(@"should ceate NSNumber object with the same value", ^{
                NSNumber *value = @123.0;
                object = [SFMappingCore instanceOfClass:cls fromObject:value];
                [[object should] equal:value];
            });
        });

    });


    context(@"when value transformer created", ^{
        __block SFMapping * mapping;
        __block SFMapping * mapping2;

        __block id (^stringTransformerBlock)(SFMapping *, id);
        __block id (^arrayTransformerBlock)(SFMapping *, id);
        beforeEach(^{

            mapping = [SFMapping property:@"" valueBlock:nil];
            mapping2 = [SFMapping property:@"" keyPath:@"" valueBlock:nil];
        });
        it(@"should create valid mapping", ^{
            [[mapping shouldNot] beNil];
            [[mapping2 shouldNot] beNil];
        });


        context(@"And mapping performed", ^{
            __block BOOL stringTransformerBlockCalled = NO;
            __block BOOL arrayTransformerBlockCalled = NO;


            __block id stringPropertySourceValue = nil;
            __block id arrayPropertySourceValue = nil;

            beforeEach(^{
                stringTransformerBlock = ^id(SFMapping * map, id value) {
                    stringTransformerBlockCalled = YES;
                    stringPropertySourceValue = value;
                    return @"1";
                };

                arrayTransformerBlock = ^id(SFMapping * map, id value) {
                    arrayTransformerBlockCalled = YES;
                    arrayPropertySourceValue = value;
                    return @[@1,@2,@3];
                };

                [TestProperty setSFMappingInfo:
                    [SFMapping property:@"stringProperty" valueBlock:stringTransformerBlock],
                    [SFMapping property:@"arrayProperty" keyPath:@"keyPath" valueBlock:arrayTransformerBlock],
                        nil];
            });

            it(@"should call transformer blocks", ^{
                TestProperty * result = [SFMappingCore instanceOfClass:TestProperty.class fromObject:@{}];
                [[theValue(stringTransformerBlockCalled) should] beTrue];
                [[theValue(arrayTransformerBlockCalled) should] beTrue];
            });

            it(@"should call transformer blocks with values from source object prop values", ^{
                TestProperty * result = [SFMappingCore instanceOfClass:TestProperty.class fromObject:@{@"stringProperty" : @"sting", @"keyPath": @"another"}];
                [[stringPropertySourceValue should] equal:@"sting"];
                [[arrayPropertySourceValue should] equal:@"another"];
            });

            it(@"should set values, returned by transformer blocks on destination class", ^{
                TestProperty * result = [SFMappingCore instanceOfClass:TestProperty.class fromObject:@{@"stringProperty" : @"sting", @"keyPath": @"another"}];
                [[result.stringProperty should] equal:@"1"];
                [[result.arrayProperty should] equal:@[@1,@2,@3]];
            });


        });
    });


    context(@"When property of type with protocol", ^{
        context(@"non-collection type", ^{
            SFDateMapper *dateMapper = [SFDateMapper rfc2882DateTimeMapper];
            beforeEach(^{
                [SFMappingCore registerMapper:dateMapper forClass:@"NSDate"];
                [TestPropertiesWithProtocols setSFMappingInfo:
                    [SFMapping property:@"dateWithProtocolProperty"],
                    [SFMapping property:@"dateWithMultipleProtocolsProperty"],
                        nil];
            });
            it(@"should be correctly mapped", ^{
                TestPropertiesWithProtocols * result = [SFMappingCore instanceOfClass:TestPropertiesWithProtocols.class fromObject:@{@"dateWithProtocolProperty" : @"Wed, 22 Apr 2015 15:20:11 GMT"}];
                [[[result dateWithProtocolProperty] shouldNot] beNil];
                [[[result dateWithProtocolProperty] should] beKindOfClass:[NSDate class]];
            });

            it(@"should be correctly mapped", ^{
                TestPropertiesWithProtocols * result = [SFMappingCore instanceOfClass:TestPropertiesWithProtocols.class fromObject:@{@"dateWithMultipleProtocolsProperty" : @"Wed, 22 Apr 2015 15:20:11 GMT"}];
                [[[result dateWithMultipleProtocolsProperty] shouldNot] beNil];
                [[[result dateWithMultipleProtocolsProperty] should] beKindOfClass:[NSDate class]];
            });

            afterEach(^{
                [SFMappingCore unregister:dateMapper forClass:@"NSDate"];
            });
        });

    });

    afterEach(^{
        [TestProperty setSFMappingInfo:nil];
    });

});

SPEC_END
