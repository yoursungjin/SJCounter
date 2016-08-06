//
//  SJCounterTableViewCell.m
//  SJCounter
//
//  Created by SJL on 4/25/16.
//  Copyright © 2016 SJL. All rights reserved.
//

#import "SJCounterTableViewCell.h"

@implementation SJCounterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self setNeedsDisplay];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    self.stepper.alpha = (self.editing) ? 0.0 : 1.0;
    CGRect bounds = self.bounds;
    bounds.origin.x += (self.editing) ? 38 : 0;
    [self.contentView setFrame:bounds];
}

@end
