//
//  SFNumberMapperSpec.m
//  SFObjectMapping
//
//  Created by Paul Taykalo on 4/20/15.
//  Copyright 2015 Stanfy LLC. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "SFNSNumberMapper.h"
#import "NSError+SFMapping.h"
#import "SFMapping.h"
#import "TestProperty.h"
#import "SFBOOLMapper.h"


SPEC_BEGIN(SFNumberMapperSpec)

    describe(@"SFNumberMapper", ^{


        __block SFNSNumberMapper *numberMapper;
        __block SFMapping *boolPropertyMapping = [SFMapping property:@"boolProperty" toKeyPath:@"bool"];
        __block TestProperty *sut;

        beforeEach(^{
            numberMapper = [SFNSNumberMapper new];
            sut = [TestProperty new];
        });

        context(@"When nil value passed in", ^{

            it(@"should call KVC with @0 value", ^{
                sut = [KWMock nullMockForClass:TestProperty.class];
                [[sut should] receive:@selector(setValue:forKeyPath:) withArguments:@0, boolPropertyMapping.property, nil];
                [numberMapper applyMapping:boolPropertyMapping onObject:sut withValue:nil error:nil];
            });
        });

        context(@"When [NSNull null] value passed in", ^{

            it(@"should call KVC with @0 value", ^{
                sut = [KWMock nullMockForClass:TestProperty.class];
                [[sut should] receive:@selector(setValue:forKeyPath:) withArguments:@0, boolPropertyMapping.property, nil];
                [numberMapper applyMapping:boolPropertyMapping onObject:sut withValue:nil error:nil];
            });
        });


        context(@"When NSNumber value passed in", ^{

            it(@"should call KVC with this value", ^{
                sut = [KWMock nullMockForClass:TestProperty.class];
                NSNumber *number = @123.0;
                [[sut should] receive:@selector(setValue:forKeyPath:) withArguments:number, boolPropertyMapping.property, nil];
                [numberMapper applyMapping:boolPropertyMapping onObject:sut withValue:number error:nil];
            });

            it(@"should call KVC with this value", ^{
                sut = [KWMock nullMockForClass:TestProperty.class];
                NSNumber *number = @12;
                [[sut should] receive:@selector(setValue:forKeyPath:) withArguments:number, boolPropertyMapping.property, nil];
                [numberMapper applyMapping:boolPropertyMapping onObject:sut withValue:number error:nil];
            });

            it(@"should call KVC with this value", ^{
                sut = [KWMock nullMockForClass:TestProperty.class];
                NSNumber *number = @YES;
                [[sut should] receive:@selector(setValue:forKeyPath:) withArguments:number, boolPropertyMapping.property, nil];
                [numberMapper applyMapping:boolPropertyMapping onObject:sut withValue:number error:nil];
            });
        });


        context(@"When NSString value passed in", ^{

            it(@"should call KVC with this value", ^{
                sut = [KWMock nullMockForClass:TestProperty.class];
                NSString *stringValue = @"123.0";
                [[sut should] receive:@selector(setValue:forKeyPath:) withArguments:@123.0, boolPropertyMapping.property, nil];
                [numberMapper applyMapping:boolPropertyMapping onObject:sut withValue:stringValue error:nil];
            });

            it(@"should call KVC with this value", ^{
                sut = [KWMock nullMockForClass:TestProperty.class];
                NSString *stringValue = @"12";
                [[sut should] receive:@selector(setValue:forKeyPath:) withArguments:@12, boolPropertyMapping.property, nil];
                [numberMapper applyMapping:boolPropertyMapping onObject:sut withValue:stringValue error:nil];
            });

            /** TODO : It's a good question if NSNUMBER formatter should handle this case or not, but I suppose that it shouldn't */
            xit(@"should call KVC with this value", ^{
                sut = [KWMock nullMockForClass:TestProperty.class];
                NSString *stringValue = @"True";
                [[sut should] receive:@selector(setValue:forKeyPath:) withArguments:@YES, boolPropertyMapping.property, nil];
                [numberMapper applyMapping:boolPropertyMapping onObject:sut withValue:stringValue error:nil];
            });
        });

        context(@"When source value is NSObject", ^{
            __block NSObject *objectValue;
            context(@"And has some value", ^{
                beforeEach(^{
                    objectValue = [NSObject new];
                });

                it(@"should fail to apply mapping", ^{
                    [[theValue([numberMapper applyMapping:boolPropertyMapping onObject:sut withValue:objectValue error:nil]) should] beFalse];
                });

                it(@"should return error", ^{
                    NSError * error = nil;
                    [numberMapper applyMapping:boolPropertyMapping onObject:sut withValue:objectValue error:&error];
                    [[error shouldNot] beNil];
                });

                it(@"should return error SFMapping domain with SFMappingErrorCodeCannotPerformMapping code", ^{
                    NSError * error = nil;
                    [numberMapper applyMapping:boolPropertyMapping onObject:sut withValue:objectValue error:&error];
                    [[[error domain] should] equal:kSFMappingErrorDomain];
                    [[theValue([error code]) should] equal:theValue(SFMappingErrorCodeCannotPerformMapping)];
                });

                it(@"should return error with valid description", ^{
                    NSError * error = nil;
                    [numberMapper applyMapping:boolPropertyMapping onObject:sut withValue:objectValue error:&error];
                    [[[error localizedDescription] shouldNot] beNil];
                });


            });
        });


    });

SPEC_END
