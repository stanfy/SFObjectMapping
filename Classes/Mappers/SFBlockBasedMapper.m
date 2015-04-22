//
// Created by Paul Taykalo on 4/22/15.
// Copyright (c) 2015 Stanfy LLC. All rights reserved.
//

#import "SFBlockBasedMapper.h"
#import "SFMapping.h"


@interface SFBlockBasedMapper ()
@end

@implementation SFBlockBasedMapper {

}
- (instancetype)initWithValueTransformBlock:(id (^)(SFMapping *mapping, id value))valueTransformBlock {
    self = [super init];
    if (self) {
        _valueTransformBlock = [valueTransformBlock copy];
    }

    return self;
}

+ (instancetype)mapperWithValueTransformBlock:(id (^)(SFMapping *maping, id value))valueTransformBlock {
    return [[self alloc] initWithValueTransformBlock:valueTransformBlock];
}


#pragma mark - Mapping

- (BOOL)applyMapping:(SFMapping *)mapping onObject:(id)object withValue:(id)value error:(NSError **)error {
    if (self.valueTransformBlock) {
        id transformedValue = self.valueTransformBlock(mapping, value);
        [self setValue:transformedValue forKey:mapping.property onObject:object];
        return YES;
    }

    return NO;
}

@end