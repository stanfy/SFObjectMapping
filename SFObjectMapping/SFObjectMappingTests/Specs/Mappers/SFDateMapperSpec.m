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
    __block SFMapping *datePropertyMapping = [SFMapping property:@"dateProperty" toKeyPath:@"date"];
    __block TestProperty *sut;
    __block NSDateFormatter * dateFormatter;

    beforeEach(^{
        dateFormatter = [KWMock nullMockForClass:[NSDateFormatter class]];
        dateMapper = [[SFDateMapper alloc] initWithDateFormatter:dateFormatter];
        sut = [TestProperty new];
    });

    context(@"By default", ^{
        it(@"should be able to create with ISO8601 Date format", ^{
            SFDateMapper * mapper = [SFDateMapper iso8601DateTimeMapper];
            [[mapper shouldNot] beNil];
        });

        it(@"should be able to create with RFC2882 Date format", ^{
            SFDateMapper * mapper = [SFDateMapper rfc2882DateTimeMapper];
            [[mapper shouldNot] beNil];
        });

        it(@"should be able to create with RFC3339 Date format", ^{
            SFDateMapper * mapper = [SFDateMapper rfc3339DateTimeMapper];
            [[mapper shouldNot] beNil];
        });

    });

    context(@"When created with factory method", ^{
        beforeEach(^{
            dateMapper = [SFDateMapper instanceWithDateFormatter:dateFormatter];
        });
        it(@"should be initialized with passed dateFormatter", ^{
            [[dateMapper.dateFormatter should] equal:dateFormatter];
        });
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

        context(@"And dateformatter return valid date", ^{

            __block NSString * dateString = @"1994.23.023";
            __block NSDate *date = nil;

            beforeEach(^{
                date = [NSDate date];
                [dateFormatter stub:@selector(dateFromString:) andReturn:date];
            });

            it(@"should call any KVC setters with this date", ^{
                sut = [KWMock nullMockForClass:TestProperty.class];
                [[sut should] receive:@selector(setValue:forKeyPath:) withArguments:date, datePropertyMapping.property, nil];
                [dateMapper applyMapping:datePropertyMapping onObject:sut withValue:dateString error:nil];
            });

            it(@"should success to apply mapping", ^{
                BOOL mappingValue = [dateMapper applyMapping:datePropertyMapping onObject:sut withValue:dateString error:nil];
                [[theValue(mappingValue) should] beTrue];
            });


            it(@"should not return error", ^{
                NSError *error = nil;
                [dateMapper applyMapping:datePropertyMapping onObject:sut withValue:dateString error:&error];
                [[error should] beNil];
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


    context(@"When using", ^{
        __block SFDateMapper * mapper = nil;

        context(@"iso8601DateTimeMapper", ^{
            beforeEach(^{
                mapper = [SFDateMapper iso8601DateTimeMapper];
            });
            it(@"should parse string to dates passed in correct format", ^{
                sut = [KWMock nullMockForClass:TestProperty.class];
                __block id date = nil;
                [sut stub:@selector(setValue:forKeyPath:) withBlock:^id(NSArray *params) {
                    date = params[0];
                    return nil;
                }];
                [mapper applyMapping:datePropertyMapping onObject:sut withValue:@"2015-04-22T15:20:11Z" error:nil];
                [[date shouldNot] beNil];
            });
        });

        context(@"rfc2882DateTimeMapper", ^{
            beforeEach(^{
                mapper = [SFDateMapper rfc2882DateTimeMapper];
            });
            it(@"should parse string to dates passed in correct format", ^{
                sut = [KWMock nullMockForClass:TestProperty.class];
                __block id date = nil;
                [sut stub:@selector(setValue:forKeyPath:) withBlock:^id(NSArray *params) {
                    date = params[0];
                    return nil;
                }];
                [mapper applyMapping:datePropertyMapping onObject:sut withValue:@"Wed, 22 Apr 2015 15:20:11 GMT" error:nil];
                [[date shouldNot] beNil];
            });
        });

        context(@"rfc3339DateTimeMapper", ^{
            beforeEach(^{
                mapper = [SFDateMapper rfc3339DateTimeMapper];
            });
            it(@"should parse string to dates passed in correct format", ^{
                sut = [KWMock nullMockForClass:TestProperty.class];
                __block id date = nil;
                [sut stub:@selector(setValue:forKeyPath:) withBlock:^id(NSArray *params) {
                    date = params[0];
                    return nil;
                }];
                [mapper applyMapping:datePropertyMapping onObject:sut withValue:@"2015-04-22T15:20:11Z" error:nil];
                [[date shouldNot] beNil];
            });
        });
    });


});

SPEC_END
