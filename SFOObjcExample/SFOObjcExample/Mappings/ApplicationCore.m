//
// Created by Paul Taykalo on 4/22/15.
// Copyright (c) 2015 Stanfy LLC. All rights reserved.
//

#import "ApplicationCore.h"
#import "SFBaseResponse.h"
#import "SFUserResponse.h"
#import "SFUser.h"
#import <SFObjectMapping/NSObject+SFMapping.h>
#import <SFObjectMapping/SFMapping.h>
#import <SFObjectMapping/SFMappingCore.h>
#import <SFObjectMapping/SFBlockBasedMapper.h>


@implementation ApplicationCore {

}

+ (void)setupMappingsForModelObjects {


    /*
    base response class.
    All responses will have the same structure
     */
    [SFBaseResponse setSFMappingInfo:
        [SFMapping property:@"statusCode"],  // statusCode in JSON
        [SFMapping property:@"message"],     // message in JSON
            nil];

    /*
    User response.
    All properties such as status code and message
    would be used from parent class.
     */
    [SFUserResponse setSFMappingInfo:
        [SFMapping property:@"user" toKeyPath:@"User"],       // User in JSON
            nil
    ];

    /*
    Register global mapper for all types of SFUserGender
     */
    NSDictionary *userGenderDictionary =
        @{@"female" : @(SFUserGenderFemale),
            @"male" : @(SFUserGenderMale)
        };

    NSDictionary *userTypeDictionary =
        @{@"premium" : @(SFUserTypePremium),
            @"normal" : @(SFUserTypeNormal)
        };

    [SFMappingCore registerMapper:
        [SFBlockBasedMapper mapperWithValueTransformBlock:^id(SFMapping *mapping, id value) {
            return value ? userGenderDictionary[value] : nil;
        }] forClass:@"SFUserGender"];


    [SFUser setSFMappingInfo:
        // Simple mapping
        [SFMapping property:@"name"],

        // Here we're specifying this property "class", since we registered global mapper for this class previously
        [SFMapping property:@"gender" classString:@"SFUserGender"],       // gender in JSON

        // Here we're specifying local mapper which is used only for this mapping
        [SFMapping property:@"userType" keyPath:@"type" valueBlock:^id(SFMapping *mapping, id value) {
           return value ? userTypeDictionary[value] : nil;;
        }],
        nil
    ];
}

@end