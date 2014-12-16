//
//  ZSWTaskStore.m
//  Productiv
//
//  Created by Zachary Shakked on 7/18/14.
//  Copyright (c) 2014 Productiv. All rights reserved.
//

#import "ZSWTaskStore.h"
#import "ZSWTask.h"
#import "NSDate+Escort.h"


@import CoreData;

@interface ZSWTaskStore ()

@property (nonatomic) NSMutableArray *privateTasks;
@property (nonatomic, strong) NSMutableArray *allCategories;

@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSManagedObjectModel *model;

@end

@implementation ZSWTaskStore

#pragma mark - Initialization
+ (instancetype)sharedStore
{
    static ZSWTaskStore *sharedStore = nil;
    
    // Do I need to create a sharedStore?
    if (!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
        
    }
    
    return sharedStore;
}


- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[ZSWTaskStore sharedStore]"
                                 userInfo:nil];
    return nil;
}

// Here is the real (secret) initializer
- (instancetype)initPrivate
{
    self = [super init];
    
    if (self) {
        //Read in Productiv.xcdatamodeld
        _model = [NSManagedObjectModel mergedModelFromBundles:nil];
        
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
        
        //Where does the SQLite file go?
        NSString *path = self.itemArchivePath;
        NSURL *storeURL = [NSURL fileURLWithPath:path];
        
        NSError *error = nil;
        
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType
                               configuration:nil
                                         URL:storeURL
                                     options:nil
                                       error:&error]) {
            @throw [NSException exceptionWithName:@"OpenFailure"
                                           reason:[error localizedDescription]
                                         userInfo:nil];
        }
        
        //Create the managed object context
        _context = [[NSManagedObjectContext alloc] init];
        _context.persistentStoreCoordinator = psc;
        
        [self loadAllItems];

    }
    
    return self;
}

#pragma mark - Tasks
- (ZSWTask *)createTask
{
    double order;
    if ([self.allTasks count] == 0) {
        order = 1.0;
    } else {
        order = [[self.privateTasks lastObject] orderingValue] + 1.0;
    }
    ZSWTask *task = [NSEntityDescription insertNewObjectForEntityForName:@"ZSWTask"
                                                  inManagedObjectContext:self.context];
    task.orderingValue = order;
    [self.privateTasks addObject:task];
    
    return task;
}

- (void)removeTask:(ZSWTask *)task
{
    //Remove from coredata and store
    [self.context deleteObject:task];
    [self.privateTasks removeObject:task];
}

- (NSArray *)allTasks
{
    return self.privateTasks;
}

- (NSArray *)allTasksOrdered
{
    NSMutableArray *allTasks = self.privateTasks;
    NSSortDescriptor* sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    [allTasks sortUsingDescriptors:[NSArray arrayWithObject:sortByDate]];
    
    return allTasks;
}

- (NSArray *)completeTasks
{
    NSArray *tasks = [self allTasks];
    NSMutableArray *completeTasks = [[NSMutableArray alloc] init];
    for (ZSWTask *task in tasks) {
        if (task.status) {
            [completeTasks addObject:task];
        }
    }
    NSSortDescriptor* sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    [completeTasks sortUsingDescriptors:[NSArray arrayWithObject:sortByDate]];
    return completeTasks;
}

- (NSArray *)incompleteTasks
{
    NSArray *tasks = [self allTasks];
    NSMutableArray *incompleteTasks = [[NSMutableArray alloc] init];
    for (ZSWTask *task in tasks) {
        if (!task.status) {
            [incompleteTasks addObject:task];
        }
    }
    NSSortDescriptor* sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    [incompleteTasks sortUsingDescriptors:[NSArray arrayWithObject:sortByDate]];
    return incompleteTasks;
}

- (NSArray *)todayTasks
{
    //repeat tasks
    
    NSMutableArray *todayTasks = [[NSMutableArray alloc] init];
    NSArray *tasks = [self allTasks];
    for (ZSWTask *task in tasks) {
        if ([task.date isToday]) {
            [todayTasks addObject:task];
        }
    }
    
    return todayTasks;
}

- (NSArray *)tomorrowTasks
{
    NSMutableArray *tomorrowTasks = [[NSMutableArray alloc] init];
    NSArray *tasks = [self allTasks];
    for (ZSWTask *task in tasks) {
        if ([task.date isTomorrow]) {
            [tomorrowTasks addObject:task];
        }
    }
    return tomorrowTasks;
}

- (NSArray *)yesterdayTasks
{
    NSMutableArray *yesterdayTasks = [[NSMutableArray alloc] init];
    NSArray *tasks = [self allTasks];
    for (ZSWTask *task in tasks) {
        if ([task.date isYesterday]) {
            [yesterdayTasks addObject:task];
        }
    }
    return yesterdayTasks;
}

- (NSArray *)taskInXDays:(NSInteger)days
{

    NSDate *date = [NSDate dateWithDaysFromNow:days];
    NSMutableArray *tasksInXDays = [[NSMutableArray alloc] init];
    NSArray *tasks = [self allTasks];
    
    for (ZSWTask *task in tasks) {
        if ([task.date isEqualToDateIgnoringTime:date]) {
            [tasksInXDays addObject:task];
        }
    }
    return tasksInXDays;
}

- (NSArray *)tasksBeforeDate:(NSDate *)date
{

    NSArray *tasks = [self allTasks];
    NSMutableArray *tasksBeforeDate = [[NSMutableArray alloc] init];
    for (ZSWTask *task in tasks) {
        if ([task.date isEarlierThanDate:date]) {
            [tasksBeforeDate addObject:task];
        }
    }
    NSSortDescriptor* sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    [tasksBeforeDate sortUsingDescriptors:[NSArray arrayWithObject:sortByDate]];
    return tasksBeforeDate;
}

- (NSArray *)tasksWithCategory:(NSManagedObject *)category
{
    NSArray *tasks = [self allTasks];
    NSMutableArray *categoryTasks = [[NSMutableArray alloc] init];
    for (ZSWTask *task in tasks) {
        if (task.category == category) {
            [categoryTasks addObject:task];
        }
    }
    NSSortDescriptor* sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    [categoryTasks sortUsingDescriptors:[NSArray arrayWithObject:sortByDate]];
    return categoryTasks;
}

- (NSArray *)tasksWithCategory:(NSManagedObject *)category complete:(BOOL)status
{
    NSArray *tasks = [self allTasks];
    NSMutableArray *categoryTasks = [[NSMutableArray alloc] init];
    for (ZSWTask *task in tasks) {
        if (task.category == category && task.status == status) {
            [categoryTasks addObject:task];
        }
    }
    NSSortDescriptor* sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    [categoryTasks sortUsingDescriptors:[NSArray arrayWithObject:sortByDate]];
    return categoryTasks;
}

- (NSArray *)futureTasks
{
    NSArray *tasks = [self allTasks];
    NSMutableArray *futureTasks = [[NSMutableArray alloc] init];
    for (ZSWTask *task in tasks) {
        if (![task.date isInPast]) {
            if (![task.date isToday]) {
                if (![task.date isTomorrow]) {
                    [futureTasks addObject:task];
                }
            }
        }
    }
    NSSortDescriptor* sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    [futureTasks sortUsingDescriptors:[NSArray arrayWithObject:sortByDate]];
    return futureTasks;
}
#pragma mark - Categories
- (void)addCategory:(NSString *)category
{
    NSManagedObject *type;
    type = [NSEntityDescription insertNewObjectForEntityForName:@"ZSWCategory"
                                         inManagedObjectContext:self.context];
    [type setValue:category forKey:@"name"];
    [_allCategories addObject:type];
    
}

- (void)removeCategory:(NSManagedObject *)category
{
    [self.context deleteObject:category];
    [_allCategories removeObject:category];
}

- (NSArray *)allCategories
{
    if (!_allCategories) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *e = [NSEntityDescription entityForName:@"ZSWCategory"
                                             inManagedObjectContext:self.context];
        
        request.entity = e;
        
        NSError *error = nil;
        NSArray *result = [self.context executeFetchRequest:request error:&error];
        if (!result){
            [NSException raise:@"Fetch failed"
                        format:@"Reason: %@", [error localizedDescription]];
        }
        _allCategories = [result mutableCopy];
    }
    
    //Is this the first time the program is being run?
    if ([_allCategories count] == 0) {
        NSManagedObject *type;
        
        //Add default categories
        type = [NSEntityDescription insertNewObjectForEntityForName:@"ZSWCategory"
                                             inManagedObjectContext:self.context];
        [type setValue:@"School" forKey:@"name"];
        [_allCategories addObject:type];
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"ZSWCategory"
                                             inManagedObjectContext:self.context];
        [type setValue:@"Work" forKey:@"name"];
        [_allCategories addObject:type];
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"ZSWCategory"
                                             inManagedObjectContext:self.context];
        [type setValue:@"Fitness" forKey:@"name"];
        [_allCategories addObject:type];
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"ZSWCategory"
                                             inManagedObjectContext:self.context];
        [type setValue:@"Creative" forKey:@"name"];
        [_allCategories addObject:type];
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"ZSWCategory"
                                             inManagedObjectContext:self.context];
        [type setValue:@"Fun" forKey:@"name"];
        [_allCategories addObject:type];
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"ZSWCategory"
                                             inManagedObjectContext:self.context];
        [type setValue:@"Boredom" forKey:@"name"];
        [_allCategories addObject:type];
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"ZSWCategory"
                                             inManagedObjectContext:self.context];
        [type setValue:@"Programming" forKey:@"name"];
        [_allCategories addObject:type];
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"ZSWCategory"
                                             inManagedObjectContext:self.context];
        [type setValue:@"Hobby" forKey:@"name"];
        [_allCategories addObject:type];
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"ZSWCategory"
                                             inManagedObjectContext:self.context];
        [type setValue:@"Food" forKey:@"name"];
        [_allCategories addObject:type];
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"ZSWCategory"
                                             inManagedObjectContext:self.context];
        [type setValue:@"Cleaning" forKey:@"name"];
        [_allCategories addObject:type];
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"ZSWCategory"
                                             inManagedObjectContext:self.context];
        [type setValue:@"Books" forKey:@"name"];
        [_allCategories addObject:type];
    }
    
    //Make alphabetical
    NSSortDescriptor *labelDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)];
    NSArray *sorted = [_allCategories sortedArrayUsingDescriptors:[NSArray arrayWithObject:labelDescriptor]];
    
    return sorted;
    
}

#pragma mark - Core Data and Maintenance
- (BOOL)saveChanges
{
    NSError *error;
    
    BOOL successful = [self.context save:&error];
    if (!successful) {
        NSLog(@"Error saving: %@", [error localizedDescription]);
    }
    return successful;
}

- (void)cleanTasksThatAreEmpty
{
    NSMutableArray *tasksToBeErased = [[NSMutableArray alloc] init];
    for (ZSWTask *task in self.privateTasks) {
        if (!task.task) {
            if (!task.date) {
                [tasksToBeErased addObject:task];
            }
        }
    }
    
    for (ZSWTask *task in tasksToBeErased) {
        [self removeTask:task];
    }
    
}

- (void)updateWithRepeats
{
    NSArray *repeatTasks = [self repeatTasks];
    for (ZSWTask *task in repeatTasks) {
    }
    
    
    for (ZSWTask *task in repeatTasks) {
        //gather repeat info
        NSDictionary *setToRepeatDictionary = task.setToRepeatDictionary;
        BOOL repeatDaily = [[setToRepeatDictionary valueForKey:@"repeatDaily"] boolValue];
        BOOL repeatWeekly = [[setToRepeatDictionary valueForKey:@"repeatWeekly"] boolValue];
        BOOL repeatMonthly = [[setToRepeatDictionary valueForKey:@"repeatMonthly"] boolValue];
        NSArray *weekDaysToRepeat = [setToRepeatDictionary valueForKey:@"weekDaysToRepeat"];
        NSArray *monthDaysToRepeat = [setToRepeatDictionary valueForKey:@"monthDaysToRepeat"];
        
        
        //if its repeat daily, create a new task that is the same
        if (repeatDaily){
            
            //compare the repeat tasks with the today tasks... if the repeat task is already in the today tasks alreadyThere will be YES
            NSArray *todayTasks = [self todayTasks];
            BOOL alreadyThere = NO;
            
            if([todayTasks count] > 0) {
                for (ZSWTask *todayTask in todayTasks) {
                    if ([task.task isEqual:todayTask.task]) {
                        alreadyThere = YES;
                    }
                }
                
                if(!alreadyThere) {
                    ZSWTask *repeatTask = [task taskCopy:task];
                    repeatTask.date = [NSDate date];
                    repeatTask.setToRepeatDictionary = setToRepeatDictionary;
                }
            }else {
                ZSWTask *repeatTask = [task taskCopy:task];
                repeatTask.date = [NSDate date];
                repeatTask.setToRepeatDictionary = setToRepeatDictionary;
                
            }
            
        }
        
        //if it repeats weekly, see if today is one of the days
        if (repeatWeekly) {
            
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
            int weekday = (int)[comps weekday];
            
            for (NSNumber *number in weekDaysToRepeat) {
                if (number.intValue == weekday) {
                    //make sure its not already there
                    NSArray *todayTasks = [self todayTasks];
                    BOOL alreadyThere = NO;
                    
                    if([todayTasks count] > 0) {
                        for (ZSWTask *todayTask in todayTasks) {
                            if ([task.task isEqual:todayTask.task]) {
                                alreadyThere = YES;
                            }
                        }
                        
                        if(!alreadyThere) {
                            ZSWTask *repeatTask = [task taskCopy:task];
                            repeatTask.date = [NSDate date];
                            repeatTask.setToRepeatDictionary = setToRepeatDictionary;
                            
                        }
                    }else {
                        ZSWTask *repeatTask = [task taskCopy:task];
                        repeatTask.date = [NSDate date];
                        repeatTask.setToRepeatDictionary = setToRepeatDictionary;
                        
                    }
                }
            }
        }
        
        //if it repeats monthly, see if today is one of the days
        if (repeatMonthly) {
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSDateComponents *comps = [gregorian components:NSDayCalendarUnit fromDate:[NSDate date]];
            int monthDay = (int)[comps day];
            
            for (NSNumber *number in monthDaysToRepeat) {
                if (number.intValue == monthDay) {
                    //make sure its not already there
                    NSArray *todayTasks = [self todayTasks];
                    BOOL alreadyThere = NO;
                    
                    if([todayTasks count] > 0) {
                        for (ZSWTask *todayTask in todayTasks) {
                            if ([task.task isEqual:todayTask.task]) {
                                alreadyThere = YES;
                            }
                        }
                        
                        if(!alreadyThere) {
                            ZSWTask *repeatTask = [task taskCopy:task];
                            repeatTask.date = [NSDate date];
                            repeatTask.setToRepeatDictionary = setToRepeatDictionary;
                            
                        }
                    }else {
                        ZSWTask *repeatTask = [task taskCopy:task];
                        repeatTask.date = [NSDate date];
                        repeatTask.setToRepeatDictionary = setToRepeatDictionary;
                        
                    }
                }
            }
        }
    }
}


#pragma mark - Repeat Tasks
- (NSArray *)repeatTasks
{
    NSMutableArray *repeatTasks = [[NSMutableArray alloc] init];
    NSArray *tasks = [self allTasks];
    
    for (ZSWTask *task in tasks) {
        BOOL alreadyThere = NO;
        if (task.setToRepeatDictionary) {
            //ensure its not already there
            for (ZSWTask *repeatTask in repeatTasks) {
                if ([repeatTask.task isEqual:task.task]) {
                    alreadyThere = YES;
                    
                }
            }
            if (!alreadyThere) {
                [repeatTasks addObject:task];
                

            }
        }
    }
    return repeatTasks;
}

- (ZSWTask *)findRepeatParentTaskWithTask:(ZSWTask *)givenTask
{

    for (ZSWTask *task in self.privateTasks) {
        if ([task.task isEqual:givenTask.task]) {
            if (task.setToRepeatDictionary) {
                
                return task;
            }
        }
    }
    return nil;
}

- (NSString *)findTypeOfRepeatForTask:(ZSWTask *)givenTask
{

    
    NSDictionary *setToRepeatDictionary = givenTask.setToRepeatDictionary;
    BOOL repeatDaily = [[setToRepeatDictionary valueForKey:@"repeatDaily"] boolValue];
    BOOL repeatWeekly = [[setToRepeatDictionary valueForKey:@"repeatWeekly"] boolValue];
    BOOL repeatMonthly = [[setToRepeatDictionary valueForKey:@"repeatMonthly"] boolValue];
    
    if (repeatDaily) {
        return @"repeatDaily";
    } else if (repeatWeekly) {
        return @"repeatWeekly";
    } else if (repeatMonthly) {
        return @"repeatMonthly";
    }
    return nil;
}


- (void)removeRepeatForTask:(ZSWTask *)givenTask
{
    for (ZSWTask *task in self.privateTasks) {
        if ([task.task isEqual:givenTask.task]) {
            if (task.setToRepeatDictionary) {
                task.setToRepeatDictionary = nil;
            }
        }
    }
}

- (void)syncRepeatsWithTask:(ZSWTask *)givenTask
{
    NSString *taskString = givenTask.task;
    NSDictionary *setToRepeatDictionary = givenTask.setToRepeatDictionary;
    for (ZSWTask *task in self.privateTasks) {
        if ([task.task isEqualToString:taskString]) {
            task.setToRepeatDictionary = setToRepeatDictionary;
        }
    }
}

//Move items
- (void)moveItemAtIndex:(NSInteger)fromIndex
                toIndex:(NSInteger)toIndex
{
    if (fromIndex == toIndex) {
        return;
    }
    // Get pointer to object being moved so you can re-insert it
    ZSWTask *task = self.privateTasks[fromIndex];
    
    // Remove item from array
    [self.privateTasks removeObjectAtIndex:fromIndex];
    
    // Insert item in array at new location
    [self.privateTasks insertObject:task atIndex:toIndex];
    
    //Computiung a new orderValue for the object that was moved
    
}

#pragma mark - Stats and Info
- (NSDictionary *)colors
{
    NSDictionary *colors = @{@"productiveGreen" : [UIColor colorWithRed:(float)45/255
                                                                  green:(float)185/255
                                                                   blue:(float)119/255
                                                                  alpha:1.0],
                             
                             @"productiveYellow" : [UIColor colorWithRed:(float)249/255
                                                                   green:(float)255/255
                                                                    blue:(float)167/255
                                                                   alpha:1.0],
                             @"buttonYellow"  : [UIColor colorWithRed:(float)255/255
                                                                green:(float)243/255
                                                                 blue:(float)145/255
                                                                alpha:1.0],
                             @"darkGreen" : [UIColor  colorWithRed:(float)52/255
                                                             green:(float)179/255
                                                              blue:(float)71/255
                                                             alpha:1.0],
                             @"almostWhiteYellow" : [UIColor colorWithRed:(float)255/255
                                                                    green:(float)254/255
                                                                     blue:(float)237/255
                                                                    alpha:1.0],
                             @"turquoise" :[UIColor colorWithRed:(float)52/255
                                                           green:(float)224/255
                                                            blue:(float)194/255
                                                           alpha:1.0],
                             @"almostWhiteGreen" : [UIColor colorWithRed:(float)235/255
                                                                   green:(float)255/255
                                                                    blue:(float)244/255
                                                                   alpha:1.0],
                             @"turquoiseLight" :[UIColor colorWithRed:(float)52/255
                                                                green:(float)224/255
                                                                 blue:(float)194/255
                                                                alpha:.55],
                             @"veryDarkGreen" : [UIColor colorWithRed:(float)36/255
                                                                green:(float)155/255
                                                                 blue:(float)99/255
                                                                alpha:1.0],
                             @"lightGray" : [UIColor colorWithRed:(float)212/255
                                                            green:(float)212/255
                                                             blue:(float)212/255
                                                            alpha:1.0],
                             @"textGray" : [UIColor colorWithRed:(float)155/255
                                                       green:(float)155/255
                                                        blue:(float)155/255
                                                       alpha:1.0]
                             };
    return colors;
}

- (NSDictionary *)stats
{
    NSMutableDictionary *stats = [[NSMutableDictionary alloc] init];
    
    //total number of tasks;
    NSArray *tasks = [self allTasks];
    NSInteger totalNumberOfTasksInt = [tasks count];
    
    NSNumber *totalNumberOfTasks = [[NSNumber alloc] initWithInteger:totalNumberOfTasksInt];
    [stats setValue:totalNumberOfTasks forKey:@"totalNumberOfTasks"];
    
    //total number of complete tasks and incomplete tasks
    NSMutableArray *completeTasks = [[NSMutableArray alloc] init];
    NSMutableArray *incompleteTasks = [[NSMutableArray alloc] init];
    for (ZSWTask *task in  tasks) {
        if (task.status) {
            [completeTasks addObject:task];
        } else {
            [incompleteTasks addObject:task];
        }
    }
    
    NSInteger totalNumberOfCompleteTasksInt = [completeTasks count];
    NSNumber *totalNumberOfCompleteTasks = [[NSNumber alloc] initWithInteger:totalNumberOfCompleteTasksInt];
    [stats setValue:totalNumberOfCompleteTasks forKey:@"totalNumberOfCompleteTasks"];
    
    NSInteger totalNumberOfIncompleteTasksInt = [incompleteTasks count];
    NSNumber *totalNumberOfIncompleteTasks = [[NSNumber alloc] initWithInteger:totalNumberOfIncompleteTasksInt];
    [stats setValue:totalNumberOfIncompleteTasks forKey:@"totalNumberOfIncompleteTasks"];
    
    //days since earliest task
    NSInteger daysSinceFirstTask = 0;
    for (ZSWTask *task in tasks) {
        if ([task.date distanceInDaysToDate:[NSDate date]] > daysSinceFirstTask){
            daysSinceFirstTask = [task.date distanceInDaysToDate:[NSDate date]];
        }
    }
    
    //avg tasks per day
    float averageTasksPerDayFloat = totalNumberOfTasks.floatValue / (float)daysSinceFirstTask;
    NSNumber *averageTasksPerDay = [[NSNumber alloc] initWithFloat:averageTasksPerDayFloat];
    [stats setValue:averageTasksPerDay forKey:@"averageNumberOfTasksPerDay"];
    
    //avg tasks per week
    NSMutableArray *allTasksThisWeek = [[NSMutableArray alloc] init];
    for (ZSWTask *task in tasks) {
        if ([task.date isThisWeek]) {
            [allTasksThisWeek addObject:task];
        }
    }
    NSInteger totalNumberOfTasksThisWeek = [allTasksThisWeek count];
    //day of the week
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
    NSInteger weekday = [comps weekday];
    float averageTasksPerDayThisWeekFloat = totalNumberOfTasksThisWeek / weekday;
    NSNumber *averageTasksPerDayThisWeek = [[NSNumber alloc] initWithFloat:averageTasksPerDayThisWeekFloat];
    [stats setValue:averageTasksPerDayThisWeek forKey:@"averageTasksPerDayThisWeek"];
    
    //overarching dictionary that contains individual dictionaries for each category that has tasks
    NSMutableDictionary *categoryStats = [[NSMutableDictionary alloc] init];
    //create a dictionary of stats for each category
    
    //sort tasks by category
    NSArray *categories = [self allCategories];
    NSMutableArray *tasksByCategoryArrays = [[NSMutableArray alloc] init];
    for (NSManagedObject *category in categories) {
        //for each category loop through tasks and sort them into category arrays
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (ZSWTask *task in tasks) {
            if (task.category == category) {
                //found a task in this category;
                [array addObject:task];
            }
        }
        [tasksByCategoryArrays addObject:[array mutableCopy]];
        array = nil;
    }
    
    //favorite category
    NSInteger taskCountForCategory = 0;
    NSMutableArray *mostPopularCategory = [[NSMutableArray alloc] init];
    for (NSMutableArray *array in tasksByCategoryArrays) {
        if ([array count] > taskCountForCategory) {
            mostPopularCategory = array;
            taskCountForCategory = [array count];
        }
    }
    NSManagedObject *favoriteCategory = [(ZSWTask *)[mostPopularCategory firstObject] category];
    [stats setValue:favoriteCategory forKey:@"favoriteCategory"];
    
    //categories that have tasks
    NSMutableArray *categoriesWithTasks = [[NSMutableArray alloc] init];
    for (NSMutableArray *array in tasksByCategoryArrays) {
        if ([array count] > 0) {
            ZSWTask *task = [array firstObject];
            NSManagedObject *category = task.category;
            NSString *categoryName = [category valueForKey:@"name"];
            [categoriesWithTasks addObject:categoryName];
        }
    }
    [stats setValue:categoriesWithTasks forKey:@"categoriesWithTasks"];
    
    for (NSMutableArray *array in tasksByCategoryArrays) {
        if ([array count] != 0){
            NSMutableDictionary *categoryDictionary = [[NSMutableDictionary alloc] init];
            
            //number of tasks in the category
            NSInteger taskCountInArray = [array count];
            NSNumber *numberOfTasks = [[NSNumber alloc] initWithInteger:taskCountInArray];
            [categoryDictionary setValue:numberOfTasks forKey:@"numberOfTasks"];
            
            //number of complete tasks
            NSMutableArray *completeTasks = [[NSMutableArray alloc] init];
            NSMutableArray *incompleteTasks = [[NSMutableArray alloc] init];
            for (ZSWTask *task in  array) {
                if (task.status) {
                    [completeTasks addObject:task];
                } else {
                    [incompleteTasks addObject:task];
                }
            }
            NSInteger totalNumberOfCompleteTasksInt = [completeTasks count];
            NSNumber *totalNumberOfCompleteTasks = [[NSNumber alloc] initWithInteger:totalNumberOfCompleteTasksInt];
            [categoryDictionary setValue:totalNumberOfCompleteTasks forKey:@"totalNumberOfCompleteTasks"];
            
            NSInteger totalNumberOfIncompleteTasksInt = [incompleteTasks count];
            NSNumber *totalNumberOfIncompleteTasks = [[NSNumber alloc] initWithInteger:totalNumberOfIncompleteTasksInt];
            [categoryDictionary setValue:totalNumberOfIncompleteTasks forKey:@"totalNumberOfIncompleteTasks"];
            
            //percentage of total tasks that are in this category
            float percentageOfTasksInThisCategoryFloat = taskCountInArray/totalNumberOfTasks.floatValue;
            NSNumber *percentageOfTasksInThisCategory = [[NSNumber alloc] initWithFloat:percentageOfTasksInThisCategoryFloat];
            [categoryDictionary setValue:percentageOfTasksInThisCategory forKey:@"percentageOfTasksInThisCategory"];
            
            
            ZSWTask *task = array[0];
            NSManagedObject *category = task.category;
            NSString *categoryName = [category valueForKey:@"name"];
            [categoryStats setValue:[categoryDictionary copy] forKey:categoryName];
            categoryDictionary = nil;
        }
    }
    [stats setValue:categoryStats forKey:@"categoryStats"];
    
    //favorite category
    

    return stats;
    
}

#pragma mark - Core Data Specifics

//item archive paths
- (NSString *)itemArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    //Get one and only document directory from that list
    NSString *documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:@"store.data"];
}

- (void)loadAllItems
{
    if (!self.privateTasks) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *e = [NSEntityDescription entityForName:@"ZSWTask"
                                             inManagedObjectContext:self.context];
        
        request.entity = e;
        
        NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"orderingValue"
                                                             ascending:YES];
        
        request.sortDescriptors = @[sd];
        
        NSError *error;
        NSArray *result = [self.context executeFetchRequest:request error:&error];
        if (!result) {
            [NSException raise:@"Fetch failed"
                        format:@"Reason: %@", [error localizedDescription]];
        }
        self.privateTasks = [[NSMutableArray alloc] initWithArray:result];
    }
}

- (NSManagedObject *)categoryWithName:(NSString *)name
{
    for (NSManagedObject *object in self.allCategories) {
        if ([[object valueForKey:@"name"] isEqualToString:name]) {
            return object;
        }
    }
    return nil;
}

@end
