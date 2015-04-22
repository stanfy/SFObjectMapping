//
// Created by Paul Taykalo on 4/22/15.
// Copyright (c) 2015 Stanfy LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFBaseResponse.h"

@class SFUser;

/*
User response
 */
@interface SFUserResponse : SFBaseResponse

@property(nonatomic, strong) SFUser *user;

@end