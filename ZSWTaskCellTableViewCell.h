//
//  ZSWTaskCellTableViewCell.h
//  Productiv
//
//  Created by Zachary Shakked on 7/19/14.
//  Copyright (c) 2014 Productiv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZSWTaskCellTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *checkmark;
@property (nonatomic, weak) IBOutlet UILabel *taskLabel;
@property (nonatomic, weak) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UIButton *taskSwitchButton;
@property (weak, nonatomic) IBOutlet UIImageView *repeatIcon;
@property (weak, nonatomic) IBOutlet UIImageView *noteIcon;
@property (weak, nonatomic) IBOutlet UIImageView *reminderIcon;



@property (nonatomic, copy) void (^actionBlock)(void);


@end
