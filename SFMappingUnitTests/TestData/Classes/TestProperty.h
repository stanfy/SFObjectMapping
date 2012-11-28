//
//  TestProperty.h
//  SFMappingUnitTests
//
//  Created by adenisov on 28.11.12.
//  Copyright (c) 2012 stanfy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestProperty : NSObject

@property (nonatomic, strong) NSString *stringProperty;
@property (nonatomic, readwrite) int intProperty;
@property (nonatomic, readwrite) float floatProperty;
@property (nonatomic, readwrite) CGRect rectProperty;
@property (nonatomic, readwrite) BOOL boolProperty;

@end
