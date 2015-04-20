//
//  SFDateMapper.h
//
//  Created by Paul Taykalo on 11/22/12.
//  Copyright (c) 2012 Stanfy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFMapper.h"

@interface SFDateMapper : NSObject <SFMapper> {

   NSDateFormatter * _dateFormatter;
}

@property(nonatomic, retain) NSDateFormatter * dateFormatter;

+ (id)instanceWithDateFormatter:(NSDateFormatter *)dateFormatter;

@end
