//
//  SJCounterTableViewCell.h
//  SJCounter
//
//  Created by SJL on 4/25/16.
//  Copyright © 2016 SJL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SJCounterTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *numberLabel;
@property (nonatomic, weak) IBOutlet UIStepper *stepper;
@end
