//
// Created by Paul Taykalo on 4/22/15.
// Copyright (c) 2015 Stanfy LLC. All rights reserved.
//

#import "ApplicationCore.h"
#import "SFBaseResponse.h"
#import <SFObjectMapping/NSObject+SFMapping.h>
#import <SFObjectMapping/SFMapping.h>


@implementation ApplicationCore {

}

+ (void)setupMappingsForModelObjects {


    /*
    base response class.
    All responses will have the same structure
     */
    [SFBaseResponse setSFMappingInfo:
        [SFMapping property:@"statusCode"],  // statusCode in JSON
        [SFMapping property:@"message"],  // statusCode in JSON
            nil];
}

@end