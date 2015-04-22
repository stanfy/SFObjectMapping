//
//  SFBlockBasedMapperSpec.m
//  SFObjectMapping
//
//  Created by Paul Taykalo on 4/22/15.
//  Copyright 2015 Stanfy LLC. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "SFBlockBasedMapper.h"
#import "SFMapping.h"


SPEC_BEGIN(SFBlockBasedMapperSpec)

describe(@"SFBlockBasedMapper", ^{
    __block SFBlockBasedMapper * _mapper;
    __block NSObject * tranformedValue;
    __block KWMock * sut;

    beforeEach(^{
        tranformedValue = [NSObject new];
        sut = [KWMock nullMock];
    });

    context(@"when mapping is called", ^{
        it(@"should call mapping block", ^{
            __block BOOL called = NO;
            _mapper = [[SFBlockBasedMapper alloc] initWithValueTransformBlock:^id(SFMapping *mapping, id value) {
                called = YES;
                return tranformedValue;
            }];

            [_mapper applyMapping:[SFMapping property:@"id"] onObject:sut withValue:@"someValue" error:nil];
            [[theValue(called) should] beTrue];
        });

        it(@"should set transformed value on mapping property", ^{
            _mapper = [[SFBlockBasedMapper alloc] initWithValueTransformBlock:^id(SFMapping *mapping, id value) {
                return tranformedValue;
            }];

            [[sut should] receive:@selector(setValue:forKeyPath:) withArguments:tranformedValue, @"id", nil];
            [_mapper applyMapping:[SFMapping property:@"id"] onObject:sut withValue:@"someValue" error:nil];
        });
    });
});

SPEC_END
