//
// Created by Paul Taykalo on 4/22/15.
// Copyright (c) 2015 Stanfy LLC. All rights reserved.
//

#import "SFActivity.h"


@implementation SFActivity {

}

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@" [%@]", self.name];
    [description appendFormat:@", @%@", self.date];
    [description appendFormat:@", children{%@}", self.subActivities];
    [description appendString:@">"];
    return description;
}

@end