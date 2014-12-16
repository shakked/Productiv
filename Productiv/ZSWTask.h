//
//  ZSWTask.h
//  Productiv
//
//  Created by Zachary Shakked on 7/18/14.
//  Copyright (c) 2014 Productiv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ZSWTask : NSManagedObject

@property (nonatomic, retain) NSString *task;
@property (nonatomic, retain) NSString *note;
@property (nonatomic) BOOL status;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic) double orderingValue;
@property (nonatomic, retain) NSManagedObject *category;
@property (nonatomic, retain) NSDictionary *setToRepeatDictionary;
@property (nonatomic) BOOL fromRepeat;

- (ZSWTask *)taskCopy:(ZSWTask *)task;
- (NSString *)repeatString;
@end
