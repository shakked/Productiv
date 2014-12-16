//
//  ZSWTaskCellTableViewCell.m
//  Productiv
//
//  Created by Zachary Shakked on 7/19/14.
//  Copyright (c) 2014 Productiv. All rights reserved.
//

#import "ZSWTaskCellTableViewCell.h"

@implementation ZSWTaskCellTableViewCell

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)switchTask:(id)sender
{
    self.actionBlock();
    
}

@end
