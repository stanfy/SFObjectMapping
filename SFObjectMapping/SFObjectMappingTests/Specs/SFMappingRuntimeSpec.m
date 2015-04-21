//
//  SFMappingRuntimeSpec.m
//  SFObjectMapping
//
//  Created by Paul Taykalo on 4/20/15.
//  Copyright 2015 Stanfy LLC. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "SFMappingRuntime.h"
#import "TestProperty.h"


SPEC_BEGIN(SFMappingRuntimeSpec)

    describe(@"SFMappingRuntime", ^{

        describe(@"should parse property correct", ^{

            it(@"for Class", ^{
                NSString *propertyType = [SFMappingRuntime typeForProperty:@"stringProperty" ofClass:[TestProperty class]];
                [[propertyType should] equal:@"NSString"];
            });

            context(@"for simple type", ^{

                it(@"integer", ^{
                    NSString *propertyType = [SFMappingRuntime typeForProperty:@"intProperty" ofClass:[TestProperty class]];
                    [[propertyType should] equal:@"NSNumber"];
                });

                it(@"real", ^{
                    NSString *propertyType = [SFMappingRuntime typeForProperty:@"floatProperty" ofClass:[TestProperty class]];
                    [[propertyType should] equal:@"NSNumber"];
                });

                it(@"boolean", ^{
                    NSString *propertyType = [SFMappingRuntime typeForProperty:@"boolProperty" ofClass:[TestProperty class]];
                    [[propertyType should] equal:@"BOOL"];
                });

                it(@"struct", ^{
                    NSString *propertyType = [SFMappingRuntime typeForProperty:@"rectProperty" ofClass:[TestProperty class]];
                    [[propertyType should] equal:@"CGRect"];
                });

            });

        });

        describe(@"should not parse property", ^{

            it(@"for nonexistent class", ^{
                NSString *propertyType = [SFMappingRuntime typeForProperty:@"rectProperty" ofClass:NSClassFromString(@"DefunctKlass")];
                [[propertyType should] beNil];
            });

            it(@"for nonexistent property", ^{
                NSString *propertyType = [SFMappingRuntime typeForProperty:@"unavailable property" ofClass:[TestProperty class]];
                [[propertyType should] beNil];
            });

        });


    });

SPEC_END
