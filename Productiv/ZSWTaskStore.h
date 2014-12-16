//
//  ZSWTaskStore.h
//  Productiv
//
//  Created by Zachary Shakked on 7/18/14.
//  Copyright (c) 2014 Productiv. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZSWTask;

@interface ZSWTaskStore : NSObject

// Notice that this is a class method and prefixed with a + instead of a -
+ (instancetype)sharedStore;

//Tasks
- (ZSWTask *)createTask;
- (void)removeTask:(ZSWTask *)task;
- (NSArray *)allTasks;
- (NSArray *)allTasksOrdered;
- (NSArray *)completeTasks;
- (NSArray *)incompleteTasks;
- (NSArray *)todayTasks;
- (NSArray *)tomorrowTasks;
- (NSArray *)yesterdayTasks;
- (NSArray *)taskInXDays:(NSInteger)days;
- (NSArray *)tasksBeforeDate:(NSDate *)date;
- (NSArray *)tasksWithCategory:(NSManagedObject *)category;
- (NSArray *)tasksWithCategory:(NSManagedObject *)category
                      complete:(BOOL)status;
- (NSArray *)futureTasks;


//Categories
- (void)addCategory:(NSString *)category;
- (void)removeCategory:(NSString *)category;
- (NSArray *)allCategories;
- (NSManagedObject *)categoryWithName:(NSString *)name;

//Core Data and Maintenence
- (BOOL)saveChanges;
- (void)cleanTasksThatAreEmpty;
- (void)updateWithRepeats;

//Repeat Functions
- (NSArray *)repeatTasks;
- (ZSWTask *)findRepeatParentTaskWithTask:(ZSWTask *)givenTask;
- (NSString *)findTypeOfRepeatForTask:(ZSWTask *)givenTask;
- (void)removeRepeatForTask:(ZSWTask *)givenTask;
- (void)syncRepeatsWithTask:(ZSWTask *)givenTask;

//Stats and Info
- (NSDictionary *)stats;
- (NSDictionary *)colors;
//Other
- (void)moveItemAtIndex:(NSInteger)fromIndex
                toIndex:(NSInteger)toIndex;
@end