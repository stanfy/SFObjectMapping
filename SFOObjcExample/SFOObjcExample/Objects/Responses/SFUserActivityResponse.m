//
// Created by Paul Taykalo on 4/22/15.
// Copyright (c) 2015 Stanfy LLC. All rights reserved.
//

#import "SFUserActivityResponse.h"


@implementation SFUserActivityResponse {

}
- (NSString *)description {
    NSMutableString *description = [NSMutableString string];
    [description appendFormat:@"activities=%@", self.activities];

    NSMutableString *superDescription = [[super description] mutableCopy];
    NSUInteger length = [superDescription length];

    if (length > 0 && [superDescription characterAtIndex:length - 1] == '>') {
        [superDescription insertString:@", " atIndex:length - 1];
        [superDescription insertString:description atIndex:length + 1];
        return superDescription;
    }
    else {
        return [NSString stringWithFormat:@"<%@: %@>", NSStringFromClass([self class]), description];
    }
}

@end