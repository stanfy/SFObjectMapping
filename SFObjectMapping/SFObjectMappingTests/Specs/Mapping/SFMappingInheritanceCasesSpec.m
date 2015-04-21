//
//  SFMappingInheritanceCasesSpec.m
//  SFObjectMapping
//
//  Created by Paul Taykalo on 4/21/15.
//  Copyright 2015 Stanfy LLC. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "SFMappingCore.h"
#import "TestProperty.h"
#import "SFMapping.h"
#import "NSObject+SFMapping.h"
#import "TestInheritedProperty.h"
#import "CustomGrandChildObject.h"


SPEC_BEGIN(SFMappingInheritanceCasesSpec)

    describe(@"SFMappingCore", ^{

        context(@"When child instance is created", ^{
            __block TestProperty *object;
            context(@"And mapping is found on parent class", ^{
                beforeEach(^{
                    [TestProperty setSFMappingInfo:
                        [SFMapping property:@"numberProperty" toKeyPath:@"value"],
                        [SFMapping property:@"intProperty" toKeyPath:@"value"],
                        [SFMapping property:@"longProperty" toKeyPath:@"value"],
                        [SFMapping property:@"floatProperty" toKeyPath:@"value"],
                        [SFMapping property:@"doubleProperty" toKeyPath:@"value"],
                            nil];
                });
                it(@"should be mapped from dictionary ", ^{
                    object = [SFMappingCore instanceOfClass:[TestInheritedProperty class] fromObject:@{@"value" : @15.5}];
                    [[object should] beKindOfClass:[TestInheritedProperty class]];
                    [[object.numberProperty should] equal:@15.5];
                    [[theValue(object.intProperty) should] equal:theValue(15)];
                    [[theValue(object.longProperty) should] equal:theValue(15)];
                    [[theValue(object.floatProperty) should] equal:theValue(15.5)];
                    [[theValue(object.doubleProperty) should] equal:theValue(15.5)];
                });

                context(@"but overriden in child class", ^{
                    beforeEach(^{
                        [TestInheritedProperty setSFMappingInfo:
                            [SFMapping property:@"numberProperty" toKeyPath:@"childValue"],
                                nil];
                    });

                    it(@"should respect mappings from child class", ^{
                        object = [SFMappingCore instanceOfClass:[TestInheritedProperty class] fromObject:@{@"value" : @15.5, @"childValue" : @30}];
                        [[object should] beKindOfClass:[TestInheritedProperty class]];
                        [[object.numberProperty should] equal:@30];

                        [[theValue(object.intProperty) should] equal:theValue(15)];
                        [[theValue(object.longProperty) should] equal:theValue(15)];
                        [[theValue(object.floatProperty) should] equal:theValue(15.5)];
                        [[theValue(object.doubleProperty) should] equal:theValue(15.5)];
                    });
                });
            });
        });

        context(@"If for CustomObject", ^{
            __block TestInheritedProperty *object;

            beforeEach(^{
                [TestInheritedProperty setSFMappingInfo:[SFMapping property:@"customObject" toKeyPath:@"value"], nil];
            });

            context(@"No mappers were registered", ^{
                beforeEach(^{
                    object = [SFMappingCore instanceOfClass:[TestInheritedProperty class] fromObject:@{@"value" : @15.5}];
                });

                it(@"should create empty object", ^{
                    [[object.customObject shouldNot] beNil];
                    [[object.customObject.name should] beNil];
                });
            });

            context(@"Mapper on the root class is registered", ^{
                __block id <SFMapper> rootMapper;

                beforeEach(^{
                    rootMapper = [KWMock nullMockForProtocol:@protocol(SFMapper)];
                    [(KWMock *) rootMapper stub:@selector(applyMapping:onObject:withValue:error:) withBlock:^id(NSArray *params) {
                        TestInheritedProperty *prop = params[1];
                        id value = params[2];
                        prop.customObject = [[CustomGrandChildObject alloc] init];
                        prop.customObject.name = [NSString stringWithFormat:@"%@", value];
                        return @(NO);
                    }];
                    [SFMappingCore registerMapper:rootMapper forClass:@"CustomRootObject"];
                });

                afterEach(^{
                    [SFMappingCore unregister:rootMapper forClass:@"CustomRootObject"];
                });

                it(@"should use custom mapper for root object", ^{
                    [[(KWMock *) rootMapper should] receive:@selector(applyMapping:onObject:withValue:error:)];
                    object = [SFMappingCore instanceOfClass:[TestInheritedProperty class] fromObject:@{@"value" : @"COOL"}];
                });

                it(@"should use custom mapper and perform mapping", ^{
                    [[(KWMock *) rootMapper should] receive:@selector(applyMapping:onObject:withValue:error:)];
                    object = [SFMappingCore instanceOfClass:[TestInheritedProperty class] fromObject:@{@"value" : @"COOL"}];
                    [[object.customObject shouldNot] beNil];
                    [[object.customObject.name should] equal:@"COOL"];
                });


                context(@"And mapper on child class is registered", ^{
                    __block id <SFMapper> childMapper;

                    beforeEach(^{
                        childMapper = [KWMock nullMockForProtocol:@protocol(SFMapper)];
                        [(KWMock *) childMapper stub:@selector(applyMapping:onObject:withValue:error:) withBlock:^id(NSArray *params) {
                            TestInheritedProperty *prop = params[1];
                            id value = params[2];
                            prop.customObject = [[CustomGrandChildObject alloc] init];
                            prop.customObject.name = [NSString stringWithFormat:@"%@-%@", value,value];
                            return @(NO);
                        }];
                        [SFMappingCore registerMapper:childMapper forClass:@"CustomChildObject"];
                    });

                    afterEach(^{
                        [SFMappingCore unregister:childMapper forClass:@"CustomChildObject"];
                    });

                    it(@"should not use root mapper", ^{
                        [[(KWMock *) rootMapper shouldNot] receive:@selector(applyMapping:onObject:withValue:error:)];
                        object = [SFMappingCore instanceOfClass:[TestInheritedProperty class] fromObject:@{@"value" : @"COOL"}];
                    });


                    it(@"should use child mapper", ^{
                        [[(KWMock *) childMapper should] receive:@selector(applyMapping:onObject:withValue:error:)];
                        object = [SFMappingCore instanceOfClass:[TestInheritedProperty class] fromObject:@{@"value" : @"COOL"}];
                    });

                    it(@"should use child mapper and perform mapping", ^{
                        [[(KWMock *) childMapper should] receive:@selector(applyMapping:onObject:withValue:error:)];
                        object = [SFMappingCore instanceOfClass:[TestInheritedProperty class] fromObject:@{@"value" : @"COOL"}];
                        [[object.customObject shouldNot] beNil];
                        [[object.customObject.name should] equal:@"COOL-COOL"];
                    });

                });

            });

        });

        afterEach(^{
            [TestProperty setSFMappingInfo:nil];
            [TestInheritedProperty setSFMappingInfo:nil];
        });

    });

SPEC_END
