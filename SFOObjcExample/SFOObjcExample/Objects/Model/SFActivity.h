//
// Created by Paul Taykalo on 4/22/15.
// Copyright (c) 2015 Stanfy LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SFActivity : NSObject

@property(nonatomic, copy) NSString *name;
@property(nonatomic, strong) NSDate *date;
@property(nonatomic, strong) NSArray *subActivities;

@end