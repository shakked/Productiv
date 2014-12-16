//
//  ZSWCategoryViewController.h
//  Productiv
//
//  Created by Zachary Shakked on 7/18/14.
//  Copyright (c) 2014 Productiv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZSWTask.h"

@interface ZSWCategoryViewController : UITableViewController

@property (nonatomic, weak) ZSWTask *task;
@property (nonatomic) BOOL fromNewTask;

@end
