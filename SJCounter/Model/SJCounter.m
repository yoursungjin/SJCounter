//
//  SJCounter.m
//  SJCounter
//
//  Created by SJL on 4/25/16.
//  Copyright © 2016 SJL. All rights reserved.
//

#import "SJCounter.h"

@implementation SJCounter

- (instancetype)init {
    self = [super init];
    if (self) {
        _name = @"New Counter";
        _number = @"0";
    }
    return self;
}


#pragma mark - NSCoding
- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        _name = [coder decodeObjectForKey:@"name"];
        if (_name == nil)
            _name = @"New Counter";
        _number= [coder decodeObjectForKey:@"number"];
        if (_number == nil)
            _number = @"0";
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.number forKey:@"number"];
}

@end
