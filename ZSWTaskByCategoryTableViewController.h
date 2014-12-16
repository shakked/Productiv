//
//  ZSWTaskByCategoryTableViewController.h
//  Productiv
//
//  Created by Zachary Shakked on 8/10/14.
//  Copyright (c) 2014 Productiv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZSWTaskByCategoryTableViewController : UITableViewController

@property (nonatomic, strong) NSManagedObject *category;
@property (nonatomic) NSInteger segIndex;

@end
