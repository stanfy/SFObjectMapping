//
// Created by Paul Taykalo on 4/22/15.
// Copyright (c) 2015 Stanfy LLC. All rights reserved.
//

#import "SFBaseResponse.h"


@implementation SFBaseResponse

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@" statusCode=%i", self.statusCode];
    [description appendFormat:@", message=%@", self.message];
    [description appendString:@">"];
    return description;
}

@end