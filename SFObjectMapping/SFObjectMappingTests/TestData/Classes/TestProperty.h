//
//  TestProperty.h
//  SFMappingUnitTests
//
//  Created by adenisov on 28.11.12.
//  Copyright (c) 2012 stanfy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TestProperty : NSObject

@property(nonatomic, strong) NSString *stringProperty;
@property(nonatomic, assign) NSNumber * numberProperty;
@property(nonatomic, assign) int intProperty;
@property(nonatomic, assign) long longProperty;
@property(nonatomic, assign) float floatProperty;
@property(nonatomic, assign) double doubleProperty;
@property(nonatomic, assign) CGRect rectProperty;
@property(nonatomic, assign) BOOL boolProperty;

@end
