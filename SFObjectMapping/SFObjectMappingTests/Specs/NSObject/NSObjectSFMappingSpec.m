//
//  NSObjectSFMappingSpec.m
//  SFObjectMapping
//
//  Created by Paul Taykalo on 4/21/15.
//  Copyright 2015 Stanfy LLC. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "NSObject+SFMapping.h"
#import "SFMapping.h"


SPEC_BEGIN(NSObjectSFMappingSpec)

describe(@"NSObject", ^{

    context(@"Class", ^{
        it(@"should be able to set mappings", ^{
            [NSObject setSFMappingInfo:[SFMapping property:@"id" toKeyPath:@"id"], nil];
        });

        it(@"should be able to get mappings after they were set", ^{
            SFMapping * mapping1 = [SFMapping property:@"id" toKeyPath:@"id"];
            SFMapping * mapping2 = [SFMapping property:@"id1" toKeyPath:@"id2"];
            [NSObject setSFMappingInfo:mapping1,mapping2, nil];

            [[[NSObject SFMappingInfo] shouldNot] beNil];

            NSArray *mappingInfo = [NSObject SFMappingInfo];
            [[mappingInfo should] haveCountOf:2];
            [[mappingInfo should] containObjects:mapping1, mapping2, nil];
        });

        it(@"should be able to set nil mappings", ^{
            [NSObject setSFMappingInfo:nil];
        });
    });

    context(@"Instances", ^{
        __block NSObject *obj;
        beforeEach(^{
            obj = [NSObject new];
        });

        it(@"should be able to apply mappings from othe objects", ^{
            [obj applyMappingsFromObject:self];
            [obj applyMappingsFromObject:self error:nil];
        });
    });


    // Staying clear
    afterEach(^{
        [NSObject setSFMappingInfo:nil];
    });


    afterAll(^{
        [NSObject setSFMappingInfo:nil];
    });
});

SPEC_END
