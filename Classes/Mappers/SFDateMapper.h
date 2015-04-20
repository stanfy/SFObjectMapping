//
//  SFDateMapper.h
//
//  Created by Paul Taykalo on 11/22/12.
//  Copyright (c) 2012 Stanfy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFMapper.h"

@interface SFDateMapper : NSObject <SFMapper>

@property(nonatomic, readonly) NSDateFormatter * dateFormatter;

- (instancetype)initWithDateFormatter:(NSDateFormatter *)dateFormatter NS_DESIGNATED_INITIALIZER;

+ (id)instanceWithDateFormatter:(NSDateFormatter *)dateFormatter;

@end
