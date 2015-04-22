//
// Created by Paul Taykalo on 4/22/15.
// Copyright (c) 2015 Stanfy LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
Base response
 */
@interface SFBaseResponse : NSObject

@property(nonatomic, assign) int statusCode;
@property(nonatomic, copy) NSString *message;

@end