//
//  SFNSStringMapperSpec.m
//  SFObjectMapping
//
//  Created by Paul Taykalo on 4/20/15.
//  Copyright 2015 Stanfy LLC. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "SFNSStringMapper.h"
#import "SFMapping.h"
#import "TestProperty.h"
#import "NSError+SFMapping.h"


SPEC_BEGIN(SFNSStringMapperSpec)

describe(@"SFNSStringMapper", ^{

    __block SFNSStringMapper *stringMapper;
    __block SFMapping *stringPropMapping = [SFMapping property:@"stringProperty" toKeyPath:@"bool"];
    __block TestProperty *sut;

    beforeEach(^{
        stringMapper = [SFNSStringMapper new];
        sut = [TestProperty new];
    });

    context(@"When NSNumber value passed in", ^{

        it(@"should call KVC with this string value", ^{
            sut = [KWMock nullMockForClass:TestProperty.class];
            NSNumber *number = @123.0;
            [[sut should] receive:@selector(setValue:forKeyPath:) withArguments:number.stringValue, stringPropMapping.property, nil];
            [stringMapper applyMapping:stringPropMapping onObject:sut withValue:number error:nil];
        });
    });

    context(@"When NSString value passed in", ^{

        it(@"should call KVC with this value, equal to this string", ^{
            sut = [KWMock nullMockForClass:TestProperty.class];
            NSString *string = @"123";
            [[sut should] receive:@selector(setValue:forKeyPath:) withArguments:string, stringPropMapping.property, nil];
            [stringMapper applyMapping:stringPropMapping onObject:sut withValue:string error:nil];
        });

        it(@"should call KVC with this copy of this value", ^{
            sut = [TestProperty new];
            NSMutableString *string = [NSMutableString stringWithString:@"123"];
            [stringMapper applyMapping:stringPropMapping onObject:sut withValue:string error:nil];
            [[[sut stringProperty] should] equal:string];

            [string appendString:@"4"];
            [[[sut stringProperty] shouldNot] equal:string];

        });

    });

    context(@"When source value is NSObject", ^{
        __block NSObject *objectValue;
        context(@"And has some value", ^{
            beforeEach(^{
                objectValue = [NSObject new];
            });

            it(@"should fail to apply mapping", ^{
                [[theValue([stringMapper applyMapping:stringPropMapping onObject:sut withValue:objectValue error:nil]) should] beFalse];
            });

            it(@"should return error", ^{
                NSError *error = nil;
                [stringMapper applyMapping:stringPropMapping onObject:sut withValue:objectValue error:&error];
                [[error shouldNot] beNil];
            });

            it(@"should return error SFMapping domain with SFMappingErrorCodeCannotPerformMapping code", ^{
                NSError *error = nil;
                [stringMapper applyMapping:stringPropMapping onObject:sut withValue:objectValue error:&error];
                [[[error domain] should] equal:kSFMappingErrorDomain];
                [[theValue([error code]) should] equal:theValue(SFMappingErrorCodeCannotPerformMapping)];
            });

            it(@"should return error with valid description", ^{
                NSError *error = nil;
                [stringMapper applyMapping:stringPropMapping onObject:sut withValue:objectValue error:&error];
                [[[error localizedDescription] shouldNot] beNil];
            });


        });
    });
});

SPEC_END
