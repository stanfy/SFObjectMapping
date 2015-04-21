//
// Created by Paul Taykalo on 4/21/15.
// Copyright (c) 2015 Stanfy LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TestProperty.h"

@class CustomGrandChildObject;


@interface TestInheritedProperty : TestProperty

@property(nonatomic, strong) CustomGrandChildObject *customObject;

@end