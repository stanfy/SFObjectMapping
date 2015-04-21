//
//  SFNSArrayMapperSpec.m
//  SFObjectMapping
//
//  Created by Paul Taykalo on 4/21/15.
//  Copyright 2015 Stanfy LLC. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "SFNSArrayMapper.h"
#import "NSError+SFMapping.h"
#import "TestProperty.h"
#import "SFMapping.h"
#import "SFNSStringMapper.h"


SPEC_BEGIN(SFNSArrayMapperSpec)

    __block SFNSArrayMapper *arrayMapper;
    __block SFMapping *mapping;
    __block TestProperty *sut;

    beforeEach(^{
        arrayMapper = [SFNSArrayMapper new];
        sut = [TestProperty new];
    });

    describe(@"SFNSArrayMapper", ^{
        context(@"when mapping with collection mapping", ^{
            beforeEach(^{
                mapping = [SFMapping collection:@"arrayProperty" itemClass:@"TestProperty" toKeyPath:@"values"];
            });

            context(@"and item class is not available", ^{
                beforeEach(^{
                    mapping = [SFMapping collection:@"arrayProperty" itemClass:@"SomeClassThatIsNotAvailable" toKeyPath:@"values"];
                });
                context(@"And source value is NSArray", ^{
                    __block NSObject *objectValue;
                    context(@"And has some value", ^{
                        beforeEach(^{
                            objectValue = @[ @"1", @"2", @"3"];
                        });

                        it(@"should fail to apply mapping", ^{
                            [[theValue([arrayMapper applyMapping:mapping onObject:sut withValue:objectValue error:nil]) should] beFalse];
                        });

                        it(@"should return error", ^{
                            NSError *error = nil;
                            [arrayMapper applyMapping:mapping onObject:sut withValue:objectValue error:&error];
                            [[error shouldNot] beNil];
                        });

                        it(@"should return error SFMapping domain with SFMappingErrorCodeCannotPerformCollectionMapping code", ^{
                            NSError *error = nil;
                            [arrayMapper applyMapping:mapping onObject:sut withValue:objectValue error:&error];
                            [[[error domain] should] equal:kSFMappingErrorDomain];
                            [[theValue([error code]) should] equal:theValue(SFMappingErrorCodeItemClassDoesNotExists)];
                        });

                        it(@"should return error with valid description", ^{
                            NSError *error = nil;
                            [arrayMapper applyMapping:mapping onObject:sut withValue:objectValue error:&error];
                            [[[error localizedDescription] shouldNot] beNil];
                        });


                    });
                });
            });

            context(@"and item class is valid", ^{
                beforeEach(^{
                    mapping = [SFMapping collection:@"arrayProperty" itemClass:@"TestProperty" toKeyPath:@"values"];
                });
                context(@"And source value is NSArray", ^{
                    __block NSObject *objectValue;
                    context(@"And has some value", ^{
                        beforeEach(^{
                            objectValue = @[ @"1", @"2", @"3"];
                        });

                        it(@"should succeed to apply mapping", ^{
                            [[theValue([arrayMapper applyMapping:mapping onObject:sut withValue:objectValue error:nil]) should] beTrue];
                        });

                        it(@"should not return error", ^{
                            NSError *error = nil;
                            [arrayMapper applyMapping:mapping onObject:sut withValue:objectValue error:&error];
                            [[error should] beNil];
                        });

                        it(@"should call KVC with this array on this object", ^{
                            sut = [KWMock nullMockForClass:TestProperty.class];
                            [[sut should] receive:@selector(setValue:forKeyPath:) withArguments:[KWAny any], mapping.property, nil];
                            [arrayMapper applyMapping:mapping onObject:sut withValue:objectValue error:nil];
                        });

                        it(@"should create exactly the same amount of items as it was in original array", ^{
                            [arrayMapper applyMapping:mapping onObject:sut withValue:objectValue error:nil];
                            [[theValue([sut.arrayProperty count]) should] equal:theValue([(NSArray *)objectValue count])];
                        });

                        it(@"should create classes, those were passed in collection", ^{
                            [arrayMapper applyMapping:mapping onObject:sut withValue:objectValue error:nil];
                            for (id item in sut.arrayProperty) {
                                [[item should] beKindOfClass:NSClassFromString(mapping.itemClass)];
                            }
                        });

                    });
                });
            });

            context(@"And source value is NSObject", ^{
                __block NSObject *objectValue;
                context(@"And has some value", ^{
                    beforeEach(^{
                        objectValue = [NSObject new];
                    });

                    it(@"should fail to apply mapping", ^{
                        [[theValue([arrayMapper applyMapping:mapping onObject:sut withValue:objectValue error:nil]) should] beFalse];
                    });

                    it(@"should return error", ^{
                        NSError *error = nil;
                        [arrayMapper applyMapping:mapping onObject:sut withValue:objectValue error:&error];
                        [[error shouldNot] beNil];
                    });

                    it(@"should return error SFMapping domain with SFMappingErrorCodeCannotPerformMapping code", ^{
                        NSError *error = nil;
                        [arrayMapper applyMapping:mapping onObject:sut withValue:objectValue error:&error];
                        [[[error domain] should] equal:kSFMappingErrorDomain];
                        [[theValue([error code]) should] equal:theValue(SFMappingErrorCodeCannotPerformMapping)];
                    });

                    it(@"should return error with valid description", ^{
                        NSError *error = nil;
                        [arrayMapper applyMapping:mapping onObject:sut withValue:objectValue error:&error];
                        [[[error localizedDescription] shouldNot] beNil];
                    });


                });
            });
        });

        context(@"when mapping with non-collection mapping", ^{
            beforeEach(^{
                mapping = [SFMapping property:@"arrayProperty" toKeyPath:@"values"];
            });

            context(@"And source value is NSArray", ^{
                __block NSObject *objectValue;
                context(@"And has some value", ^{
                    beforeEach(^{
                        objectValue = [NSArray array];
                    });

                    it(@"should fail to apply mapping", ^{
                        [[theValue([arrayMapper applyMapping:mapping onObject:sut withValue:objectValue error:nil]) should] beFalse];
                    });

                    it(@"should return error", ^{
                        NSError *error = nil;
                        [arrayMapper applyMapping:mapping onObject:sut withValue:objectValue error:&error];
                        [[error shouldNot] beNil];
                    });

                    it(@"should return error SFMapping domain with SFMappingErrorCodeCannotPerformMapping code", ^{
                        NSError *error = nil;
                        [arrayMapper applyMapping:mapping onObject:sut withValue:objectValue error:&error];
                        [[[error domain] should] equal:kSFMappingErrorDomain];
                        [[theValue([error code]) should] equal:theValue(SFMappingErrorCodeCannotPerformMapping)];
                    });

                    it(@"should return error with valid description", ^{
                        NSError *error = nil;
                        [arrayMapper applyMapping:mapping onObject:sut withValue:objectValue error:&error];
                        [[[error localizedDescription] shouldNot] beNil];
                    });


                });
            });


            context(@"And source value is NSObject", ^{
                __block NSObject *objectValue;
                context(@"And has some value", ^{
                    beforeEach(^{
                        objectValue = [NSObject new];
                    });

                    it(@"should fail to apply mapping", ^{
                        [[theValue([arrayMapper applyMapping:mapping onObject:sut withValue:objectValue error:nil]) should] beFalse];
                    });

                    it(@"should return error", ^{
                        NSError *error = nil;
                        [arrayMapper applyMapping:mapping onObject:sut withValue:objectValue error:&error];
                        [[error shouldNot] beNil];
                    });

                    it(@"should return error SFMapping domain with SFMappingErrorCodeCannotPerformMapping code", ^{
                        NSError *error = nil;
                        [arrayMapper applyMapping:mapping onObject:sut withValue:objectValue error:&error];
                        [[[error domain] should] equal:kSFMappingErrorDomain];
                        [[theValue([error code]) should] equal:theValue(SFMappingErrorCodeCannotPerformMapping)];
                    });

                    it(@"should return error with valid description", ^{
                        NSError *error = nil;
                        [arrayMapper applyMapping:mapping onObject:sut withValue:objectValue error:&error];
                        [[[error localizedDescription] shouldNot] beNil];
                    });


                });
            });
        });
    });

SPEC_END
