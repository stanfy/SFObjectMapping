//
// Created by Paul Taykalo on 4/22/15.
// Copyright (c) 2015 Stanfy LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TestProtocol;


@interface TestPropertiesWithProtocols : NSObject

@property(nonatomic, strong) NSDate<TestProtocol> * dateWithProtocolProperty;
@property(nonatomic, strong) NSDate<TestProtocol, NSCoding> * dateWithMultipleProtocolsProperty;

@end