//
//  SFMapperSpec.m
//  SFObjectMapping
//
//  Created by Paul Taykalo on 4/20/15.
//  Copyright 2015 Stanfy LLC. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "SFMapper.h"


SPEC_BEGIN(SFMapperSpec)

describe(@"SFMapper", ^{

    context(@"Once created", ^{
        it(@"should not be nil", ^{
            [[@"" should] beNil];
        });
    });

});

SPEC_END
