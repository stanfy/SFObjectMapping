//
//  SFBOOLMapperSpec.m
//  SFObjectMapping
//
//  Created by Paul Taykalo on 4/20/15.
//  Copyright 2015 Stanfy LLC. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "SFMapper.h"
#import "SFBOOLMapper.h"
#import "SFMapping.h"
#import "TestProperty.h"
#import "NSError+SFMapping.h"


SPEC_BEGIN(SFBOOLMapperSpec)

    describe(@"SFBoolMapper", ^{

        __block SFBOOLMapper *boolMapper;
        __block SFMapping *mapping = [SFMapping property:@"boolProperty" toKeyPath:@"bool"];
        __block TestProperty *sut;

        beforeEach(^{
            boolMapper = [SFBOOLMapper new];
            sut = [TestProperty new];
        });

        context(@"When source property is not exists", ^{

            it(@"should set property to NO", ^{
                [boolMapper applyMapping:mapping onObject:sut withValue:nil error:nil];

                [[theValue([sut boolProperty]) should] beFalse];
            });
            it(@"should rewrite property value and set it to NO", ^{
                sut.boolProperty = YES;
                [boolMapper applyMapping:mapping onObject:sut withValue:nil error:nil];

                [[theValue([sut boolProperty]) should] beFalse];
            });
            it(@"should succeed to apply mapping", ^{
                [[theValue([boolMapper applyMapping:mapping onObject:sut withValue:nil error:nil]) should] beTrue];
            });
        });

        context(@"When source value is [NSNull null]", ^{
            it(@"should set property to NO", ^{
                [boolMapper applyMapping:mapping onObject:sut withValue:[NSNull null] error:nil];
                [[theValue([sut boolProperty]) should] beFalse];
            });
            it(@"should rewrite property value and set it to NO", ^{
                sut.boolProperty = YES;
                [boolMapper applyMapping:mapping onObject:sut withValue:[NSNull null] error:nil];

                [[theValue([sut boolProperty]) should] beFalse];
            });
            it(@"should succeed to apply mapping", ^{
                [[theValue([boolMapper applyMapping:mapping onObject:sut withValue:[NSNull null] error:nil]) should] beTrue];
            });

        });

        context(@"When source value is NSString", ^{
            __block NSString *stringValue;
            context(@"And has <true> value", ^{
                beforeEach(^{
                    stringValue = @"true";
                });
                it(@"should set property to YES", ^{
                    [boolMapper applyMapping:mapping onObject:sut withValue:stringValue error:nil];
                    [[theValue([sut boolProperty]) should] beTrue];
                });
                it(@"should rewrite property value and set it to YES", ^{
                    sut.boolProperty = NO;
                    [boolMapper applyMapping:mapping onObject:sut withValue:stringValue error:nil];

                    [[theValue([sut boolProperty]) should] beTrue];
                });
                it(@"should succeed to apply mapping", ^{
                    [[theValue([boolMapper applyMapping:mapping onObject:sut withValue:stringValue error:nil]) should] beTrue];
                });

            });

            context(@"And has <false> value", ^{
                beforeEach(^{
                    stringValue = @"false";
                });
                it(@"should set property to NO", ^{
                    [boolMapper applyMapping:mapping onObject:sut withValue:stringValue error:nil];
                    [[theValue([sut boolProperty]) should] beFalse];
                });
                it(@"should rewrite property value and set it to NO", ^{
                    sut.boolProperty = YES;
                    [boolMapper applyMapping:mapping onObject:sut withValue:stringValue error:nil];
                    [[theValue([sut boolProperty]) should] beFalse];
                });
                it(@"should succeed to apply mapping", ^{
                    [[theValue([boolMapper applyMapping:mapping onObject:sut withValue:stringValue error:nil]) should] beTrue];
                });


            });

            context(@"And has <True> value", ^{
                beforeEach(^{
                    stringValue = @"True";
                });
                it(@"should set property to YES", ^{
                    [boolMapper applyMapping:mapping onObject:sut withValue:stringValue error:nil];
                    [[theValue([sut boolProperty]) should] beTrue];
                });
                it(@"should rewrite property value and set it to YES", ^{
                    sut.boolProperty = NO;
                    [boolMapper applyMapping:mapping onObject:sut withValue:stringValue error:nil];

                    [[theValue([sut boolProperty]) should] beTrue];
                });
                it(@"should succeed to apply mapping", ^{
                    [[theValue([boolMapper applyMapping:mapping onObject:sut withValue:stringValue error:nil]) should] beTrue];
                });

            });

            context(@"And has <False> value", ^{
                beforeEach(^{
                    stringValue = @"False";
                });
                it(@"should set property to NO", ^{
                    [boolMapper applyMapping:mapping onObject:sut withValue:stringValue error:nil];
                    [[theValue([sut boolProperty]) should] beFalse];
                });
                it(@"should rewrite property value and set it to NO", ^{
                    sut.boolProperty = YES;
                    [boolMapper applyMapping:mapping onObject:sut withValue:stringValue error:nil];
                    [[theValue([sut boolProperty]) should] beFalse];
                });
                it(@"should succeed to apply mapping", ^{
                    [[theValue([boolMapper applyMapping:mapping onObject:sut withValue:stringValue error:nil]) should] beTrue];
                });
            });

        });

        context(@"When source value is NSNumber", ^{
            __block NSNumber *numberValue;
            context(@"And has 1 value", ^{
                beforeEach(^{
                    numberValue = @1;
                });
                it(@"should set property to YES", ^{
                    [boolMapper applyMapping:mapping onObject:sut withValue:numberValue error:nil];
                    [[theValue([sut boolProperty]) should] beTrue];
                });
                it(@"should rewrite property value and set it to YES", ^{
                    sut.boolProperty = NO;
                    [boolMapper applyMapping:mapping onObject:sut withValue:numberValue error:nil];

                    [[theValue([sut boolProperty]) should] beTrue];
                });
                it(@"should succeed to apply mapping", ^{
                    [[theValue([boolMapper applyMapping:mapping onObject:sut withValue:numberValue error:nil]) should] beTrue];
                });

            });

            context(@"And has <0> value", ^{
                beforeEach(^{
                    numberValue = @0;
                });
                it(@"should set property to NO", ^{
                    [boolMapper applyMapping:mapping onObject:sut withValue:numberValue error:nil];
                    [[theValue([sut boolProperty]) should] beFalse];
                });
                it(@"should rewrite property value and set it to NO", ^{
                    sut.boolProperty = YES;
                    [boolMapper applyMapping:mapping onObject:sut withValue:numberValue error:nil];
                    [[theValue([sut boolProperty]) should] beFalse];
                });
                it(@"should succeed to apply mapping", ^{
                    [[theValue([boolMapper applyMapping:mapping onObject:sut withValue:numberValue error:nil]) should] beTrue];
                });

            });

        });

        context(@"When source value is NSObject", ^{
            __block NSObject *objectValue;
            context(@"And has some value", ^{
                beforeEach(^{
                    objectValue = [NSObject new];
                });

                it(@"should fail to apply mapping", ^{
                    [[theValue([boolMapper applyMapping:mapping onObject:sut withValue:objectValue error:nil]) should] beFalse];
                });

                it(@"should return error", ^{
                    NSError * error = nil;
                    [boolMapper applyMapping:mapping onObject:sut withValue:objectValue error:&error];
                    [[error shouldNot] beNil];
                });

                it(@"should return error SFMapping domain with SFMappingErrorCodeCannotPerformMapping code", ^{
                    NSError * error = nil;
                    [boolMapper applyMapping:mapping onObject:sut withValue:objectValue error:&error];
                    [[[error domain] should] equal:kSFMappingErrorDomain];
                    [[theValue([error code]) should] equal:theValue(SFMappingErrorCodeCannotPerformMapping)];
                });

                it(@"should return error with valid description", ^{
                    NSError * error = nil;
                    [boolMapper applyMapping:mapping onObject:sut withValue:objectValue error:&error];
                    [[[error localizedDescription] shouldNot] beNil];
                });


            });
        });


    });

SPEC_END
