//
// Created by Paul Taykalo on 4/22/15.
// Copyright (c) 2015 Stanfy LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger , SFUserGender) {
    SFUserGenderFemale = 0,
    SFUserGenderMale = 1
};

typedef NS_ENUM(NSInteger , SFUserType) {
    SFUserTypeNormal= 0,
    SFUserTypePremium = 1
};

@interface SFUser : NSObject

@property(nonatomic, assign) SFUserGender gender;
@property(nonatomic, assign) SFUserType userType;
@property(nonatomic, copy) NSString * name;

@end