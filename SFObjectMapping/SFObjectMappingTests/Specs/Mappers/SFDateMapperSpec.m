//
//  SFDateMapperSpec.m
//  SFObjectMapping
//
//  Created by Paul Taykalo on 4/20/15.
//  Copyright 2015 Stanfy LLC. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "SFDateMapper.h"
#import "SFMapping.h"
#import "TestProperty.h"
#import "SFNSNumberMapper.h"
#import "NSError+SFMapping.h"


SPEC_BEGIN(SFDateMapperSpec)

describe(@"SFDateMapper", ^{

    __block SFDateMapper *dateMapper;
    __block SFMapping *datePropertyMapping = [SFMapping property:@"boolProperty" toKeyPath:@"bool"];
    __block TestProperty *sut;
    __block NSDateFormatter * dateFormatter;

    beforeEach(^{
        dateFormatter = [KWMock nullMockForClass:[NSDateFormatter class]];
        dateMapper = [[SFDateMapper alloc] initWithDateFormatter:dateFormatter];
        sut = [TestProperty new];
    });

    context(@"When nil value passed in", ^{

        it(@"should not call any KVC setters", ^{
            sut = [KWMock nullMockForClass:TestProperty.class];
            [[sut shouldNot] receive:@selector(setValue:forKeyPath:) withArguments:[KWAny any], datePropertyMapping.property, nil];
            [dateMapper applyMapping:datePropertyMapping onObject:sut withValue:nil error:nil];
        });

    });

    context(@"When String value passed in", ^{

        it(@"should call underlying dateFormatter with passed in string", ^{
            sut = [KWMock nullMockForClass:TestProperty.class];
            NSString * dateString = @"1994.23.023";
            [[dateFormatter should] receive:@selector(dateFromString:) withArguments:dateString, nil];
            [dateMapper applyMapping:datePropertyMapping onObject:sut withValue:dateString error:nil];
        });

        context(@"And dateformatter doesn't return valid date", ^{

            __block NSString * dateString = @"1994.23.023";

            beforeEach(^{
                [dateFormatter stub:@selector(dateFromString:) andReturn:nil];
            });

            it(@"should not call any KVC setters", ^{
                sut = [KWMock nullMockForClass:TestProperty.class];
                [[sut shouldNot] receive:@selector(setValue:forKeyPath:) withArguments:[KWAny any], datePropertyMapping.property, nil];
                [dateMapper applyMapping:datePropertyMapping onObject:sut withValue:dateString error:nil];
            });

            it(@"should fail to apply mapping", ^{
                [[theValue([dateMapper applyMapping:datePropertyMapping onObject:sut withValue:dateString error:nil]) should] beFalse];
            });


            it(@"should return error", ^{
                NSError *error = nil;
                [dateMapper applyMapping:datePropertyMapping onObject:sut withValue:dateString error:&error];
                [[error shouldNot] beNil];
            });

            it(@"should return error SFMapping domain with SFMappingErrorCodeCannotPerformMapping code", ^{
                NSError *error = nil;
                [dateMapper applyMapping:datePropertyMapping onObject:sut withValue:dateString error:&error];
                [[[error domain] should] equal:kSFMappingErrorDomain];
                [[theValue([error code]) should] equal:theValue(SFMappingErrorCodeCannotPerformMapping)];
            });

            it(@"should return error with valid description", ^{
                NSError *error = nil;
                [dateMapper applyMapping:datePropertyMapping onObject:sut withValue:dateString error:&error];
                [[[error localizedDescription] shouldNot] beNil];
            });

        });

    });

    context(@"When source value is not a string", ^{
        __block NSObject *objectValue;
        context(@"And has some value", ^{
            beforeEach(^{
                objectValue = [NSObject new];
            });

            it(@"should fail to apply mapping", ^{
                [[theValue([dateMapper applyMapping:datePropertyMapping onObject:sut withValue:objectValue error:nil]) should] beFalse];
            });

            it(@"should return error", ^{
                NSError *error = nil;
                [dateMapper applyMapping:datePropertyMapping onObject:sut withValue:objectValue error:&error];
                [[error shouldNot] beNil];
            });

            it(@"should return error SFMapping domain with SFMappingErrorCodeCannotPerformMapping code", ^{
                NSError *error = nil;
                [dateMapper applyMapping:datePropertyMapping onObject:sut withValue:objectValue error:&error];
                [[[error domain] should] equal:kSFMappingErrorDomain];
                [[theValue([error code]) should] equal:theValue(SFMappingErrorCodeCannotPerformMapping)];
            });

            it(@"should return error with valid description", ^{
                NSError *error = nil;
                [dateMapper applyMapping:datePropertyMapping onObject:sut withValue:objectValue error:&error];
                [[[error localizedDescription] shouldNot] beNil];
            });


        });
    });


});

SPEC_END
