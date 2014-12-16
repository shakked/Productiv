//
//  ZSWTask.m
//  Productiv
//
//  Created by Zachary Shakked on 7/18/14.
//  Copyright (c) 2014 Productiv. All rights reserved.
//

#import "ZSWTask.h"
#import "ZSWTaskStore.h"


@implementation ZSWTask

@dynamic task;
@dynamic note;
@dynamic status;
@dynamic date;
@dynamic orderingValue;
@dynamic category;
@dynamic setToRepeatDictionary;
@dynamic fromRepeat;


- (ZSWTask *)taskCopy:(ZSWTask *)task
{
    ZSWTask *copyTask = [[ZSWTaskStore sharedStore] createTask];
    copyTask.task = task.task;
    copyTask.category = task.category;
    copyTask.status = NO;
    copyTask.orderingValue = task.orderingValue;
    copyTask.fromRepeat = YES;

    
    return copyTask;
}

- (NSString *)repeatString
{
    //returns a string that represents when the functions repeats
    NSDictionary *setToRepeatDictionary = self.setToRepeatDictionary;
    BOOL repeatDaily = [[setToRepeatDictionary valueForKey:@"repeatDaily"] boolValue];
    BOOL repeatWeekly = [[setToRepeatDictionary valueForKey:@"repeatWeekly"] boolValue];
    BOOL repeatMonthly = [[setToRepeatDictionary valueForKey:@"repeatMonthly"] boolValue];
    NSArray *weekDaysToRepeat = [setToRepeatDictionary valueForKey:@"weekDaysToRepeat"];
    NSArray *monthDaysToRepeat = [setToRepeatDictionary valueForKey:@"monthDaysToRepeat"];
    
    
    if (repeatDaily) {
        NSString *string = @"Task repeats every day.";
        return string;
    }else if (repeatWeekly) {
        NSString *string = @"Task repeats weekly on ";
        NSArray *daysOfTheWeek = @[@"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday"];
        for (NSNumber *number in weekDaysToRepeat) {
            
            NSString *day = daysOfTheWeek[number.intValue];
            if (number != [weekDaysToRepeat lastObject]){
                string = [string stringByAppendingString:day];
                if ([weekDaysToRepeat count] > 2){
                    string = [string stringByAppendingString:@","];
                }
                string = [string stringByAppendingString:@" "];
            }else{
                if ([weekDaysToRepeat count] == 1) {
                    string = [string stringByAppendingString:day];
                }else {
                    string = [string stringByAppendingFormat:@"and %@.", day];

                }
            }
        }
        return string;
        
    }else if (repeatMonthly) {
        NSString *string = @"Task repeats monthly on these days: ";
        for (NSNumber *number in monthDaysToRepeat) {
            NSNumber *day = [NSNumber numberWithInt:[number intValue] + 1];
            if (number != [monthDaysToRepeat lastObject]){
                string = [string stringByAppendingString:day.stringValue];
                if ([monthDaysToRepeat count] > 2){
                    string = [string stringByAppendingString:@","];
                }
                string = [string stringByAppendingString:@" "];
            }else{
                if ([monthDaysToRepeat count] == 1) {
                    string = [string stringByAppendingString:day.stringValue];
                }else {
                    string = [string stringByAppendingFormat:@"and %@.", day.stringValue];
                    
                }
            }
        }
        return string;

    }
    return nil;
    
    
    
}

@end
