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

    afterEach(^{
        [TestProperty setSFMappingInfo:nil];
    });

});

SPEC_END
