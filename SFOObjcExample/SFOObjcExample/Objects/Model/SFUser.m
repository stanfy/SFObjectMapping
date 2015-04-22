//
// Created by Paul Taykalo on 4/22/15.
// Copyright (c) 2015 Stanfy LLC. All rights reserved.
//

#import "SFUser.h"


@implementation SFUser {

}

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"  gender=%d", self.gender];
    [description appendFormat:@", userType=%d", self.userType];
    [description appendFormat:@", name=%@", self.name];
    [description appendString:@">"];
    return description;
}

@end