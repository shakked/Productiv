//
//  ZSWTaskTableViewController.m
//  
//
//  Created by Zachary Shakked on 7/19/14.
//
//

#import "ZSWTaskTableViewController.h"
#import "ZSWTaskCellTableViewCell.h"
#import "SVPullToRefresh.h"
#import "ZSWTaskStore.h"
#import "ZSWTask.h"
#import "ZSWNewTaskViewController.h"
#import "ZSWDetailViewController.h"
#import "NSDate+Escort.h"

@interface ZSWTaskTableViewController () <UIGestureRecognizerDelegate>

@end


@implementation ZSWTaskTableViewController

#pragma mark - Initialization
- (id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}
- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.tableView.separatorInset = UIEdgeInsetsZero;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *bbiAdd = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                            target:self
                                                                            action:@selector(addTask)];
    UINavigationItem *navItem = self.navigationItem;
    self.navigationItem.title = @"Productiv";
    navItem.rightBarButtonItem = bbiAdd;
    

    
    //Load the NIB file for the customized cell view
    UINib *nib = [UINib nibWithNibName:@"ZSWTaskCellTableViewCell" bundle:nil];
    
    //Register this Nib, which contains the cell
    [self.tableView registerNib:nib forCellReuseIdentifier:@"ZSWTaskCellTableViewCell"];
    
    __weak ZSWTaskTableViewController *weakSelf = self;
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        int64_t delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [weakSelf.tableView beginUpdates];
            
            [weakSelf.tableView reloadData];
            
            [weakSelf.tableView endUpdates];
            
            [weakSelf.tableView.pullToRefreshView stopAnimating];
        });
    }];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    [[ZSWTaskStore sharedStore] updateWithRepeats];
    //Make sure its not editing
    [self.tableView setEditing:NO animated:NO];
    
    BOOL success = [[ZSWTaskStore sharedStore] saveChanges];
    if(success) {
        NSLog(@"Successfully saved.");
    }
    //clean the tasks
    [[ZSWTaskStore sharedStore] cleanTasksThatAreEmpty];
    [self.tableView reloadData];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self cancelEdit];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//section quantity
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

//rows per section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *futureTasks = [[ZSWTaskStore sharedStore] futureTasks];
    NSArray *tomorrowTasks = [[ZSWTaskStore sharedStore] tomorrowTasks];
    NSArray *todayTasks = [[ZSWTaskStore sharedStore] todayTasks];
    NSArray *yesterdayTasks = [[ZSWTaskStore sharedStore] yesterdayTasks];
    NSArray *daysBeforeYesterdayTasks= [[ZSWTaskStore sharedStore] tasksBeforeDate:[NSDate dateWithDaysBeforeNow:2]];
    if (section == 0) {
        return [futureTasks count];
    }else if (section == 1){
        return [tomorrowTasks count];
    } else if (section == 2) {
        return [todayTasks count];
    } else if (section == 3) {
        return [yesterdayTasks count];
    } else if (section == 4) {
        return [daysBeforeYesterdayTasks count];
    }
    return 0;
}
//cells
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    //Make a cell
    ZSWTaskCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZSWTaskCellTableViewCell" forIndexPath:indexPath];
    
    
    
    
    cell.taskLabel.font = [UIFont fontWithName:@"Avenir" size:18];
    cell.categoryLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:14];
    cell.categoryLabel.textColor = [UIColor grayColor];
    cell.dateLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:14];
    cell.dateLabel.textColor = [UIColor grayColor];
    cell.dateLabel.text = @"";
    cell.repeatIcon.image = nil;
    cell.noteIcon.image = nil;
    cell.reminderIcon.image = nil;
    //Add a long press recognizer to cell
    //initiates edit mode
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(editMode)];
    longPress.delegate = self;
    
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(editMode)];
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    rightSwipe.delegate = self;

    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(cancelEdit)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    leftSwipe.delegate = self;
    
    [cell addGestureRecognizer:longPress];
    [cell addGestureRecognizer:rightSwipe];
    [cell addGestureRecognizer:leftSwipe];
    if (indexPath.section == 0) {
        //Get Yesterday complishs and assign complish
        NSArray *tasks = [[ZSWTaskStore sharedStore] futureTasks];
        ZSWTask *task = tasks[indexPath.row];
        
        if (task.status) {
            cell.checkmark.image = [UIImage imageNamed:@"checkmarkFilled.png"];
        }else {
            cell.checkmark.image = [UIImage imageNamed:@"checkmarkEmpty.png"];
        }
        
        //repeatIcon
        if (task.setToRepeatDictionary) {
            NSDictionary *setToRepeatDictionary = task.setToRepeatDictionary;
            BOOL repeatDaily = [[setToRepeatDictionary valueForKey:@"repeatDaily"] boolValue];
            BOOL repeatWeekly = [[setToRepeatDictionary valueForKey:@"repeatWeekly"] boolValue];
            BOOL repeatMonthly = [[setToRepeatDictionary valueForKey:@"repeatMonthly"] boolValue];
            if (repeatDaily) {
                cell.repeatIcon.image = [UIImage imageNamed:@"repeatDaily.png"];
            } else if (repeatWeekly) {
                cell.repeatIcon.image = [UIImage imageNamed:@"repeatWeekly.png"];
            } else if (repeatMonthly) {
                cell.repeatIcon.image = [UIImage imageNamed:@"repeatMonthly.png"];
            } else {
                cell.repeatIcon.image = nil;
            }
        } else {
            cell.repeatIcon.image = nil;
        }
        
        //NoteIcon
        if (task.note) {
            if (!cell.repeatIcon.image){
                cell.repeatIcon.image = [UIImage imageNamed:@"noteIcon.png"];
            } else {
                cell.noteIcon.image = [UIImage imageNamed:@"noteIcon.png"];
            }
        } else {
            cell.noteIcon.image = nil;
        }
        
        //reminder
        NSArray *localNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
        for (UILocalNotification *note in localNotifications) {
            if (note.alertBody == task.task) {
                cell.reminderIcon.image = [UIImage imageNamed:@"reminderClock.png"];
            }
        }
        
        
        //Set the complish information
        cell.taskLabel.text = task.task;
        cell.categoryLabel.text = [task.category valueForKey:@"name"];
        
        //date
        NSInteger daysUntil = [task.date daysAfterDate:[NSDate date]];
        cell.dateLabel.text = [NSString stringWithFormat:@"In %ld days", (long)daysUntil];
        
        //making sure there isn't a strong reference cycle
        __weak ZSWTaskCellTableViewCell *weakCell = cell;
        
        //setting the action block to be able to check-off items
        cell.actionBlock = ^{
            ZSWTaskCellTableViewCell *strongCell = weakCell;
            if (task.status) {
                //change background color to yellow and checkmark image to empty
                strongCell.checkmark.image = [UIImage imageNamed:@"checkmarkEmpty.png"];
                task.status = NO;
            } else {
                //change background color to green and checkmark image to filled
                strongCell.checkmark.image = [UIImage imageNamed:@"checkmarkFilled.png"];
                task.status = YES;
            }
        };
    } else if (indexPath.section == 1) {
        //Get complishs for section and make the complish
        NSArray *tasks = [[ZSWTaskStore sharedStore] tomorrowTasks];
        ZSWTask *task = tasks[indexPath.row];
        //Format cell based on status
        if (task.status) {
            cell.checkmark.image = [UIImage imageNamed:@"checkmarkFilled.png"];
        }else {
            cell.checkmark.image = [UIImage imageNamed:@"checkmarkEmpty.png"];
        }
        
        
        //repeatIcon
        if (task.setToRepeatDictionary) {
            NSDictionary *setToRepeatDictionary = task.setToRepeatDictionary;
            BOOL repeatDaily = [[setToRepeatDictionary valueForKey:@"repeatDaily"] boolValue];
            BOOL repeatWeekly = [[setToRepeatDictionary valueForKey:@"repeatWeekly"] boolValue];
            BOOL repeatMonthly = [[setToRepeatDictionary valueForKey:@"repeatMonthly"] boolValue];
            
            if (repeatDaily) {
                cell.repeatIcon.image = [UIImage imageNamed:@"repeatDaily.png"];
            } else if (repeatWeekly) {
                cell.repeatIcon.image = [UIImage imageNamed:@"repeatWeekly.png"];
            } else if (repeatMonthly) {
                cell.repeatIcon.image = [UIImage imageNamed:@"repeatMonthly.png"];
            } else {
                cell.repeatIcon.image = nil;
            }
        } else {
            cell.repeatIcon.image = nil;
        }
        
        //NoteIcon
        if (task.note) {
            if (!cell.repeatIcon.image){
                cell.repeatIcon.image = [UIImage imageNamed:@"noteIcon.png"];
            } else {
                cell.noteIcon.image = [UIImage imageNamed:@"noteIcon.png"];
            }
        } else {
            cell.noteIcon.image = nil;
        }
        
        //reminder
        NSArray *localNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
        for (UILocalNotification *note in localNotifications) {
            if (note.alertBody == task.task) {
                cell.reminderIcon.image = [UIImage imageNamed:@"reminderClock.png"];
            }
        }
        //Put the info in the cell
        cell.taskLabel.text = task.task;
        cell.categoryLabel.text = [task.category valueForKey:@"name"];
        
        //making sure there isn't a strong reference cycle
        __weak ZSWTaskCellTableViewCell *weakCell = cell;
        
        //setting the action block to be able to check-off items
        cell.actionBlock = ^{
            ZSWTaskCellTableViewCell *strongCell = weakCell;
            
            if (task.status) {
                //change background color to yellow and checkmark image to empty
                strongCell.checkmark.image = [UIImage imageNamed:@"checkmarkEmpty.png"];
                task.status = NO;
            } else {
                //change background color to green and checkmark image to filled
                strongCell.checkmark.image = [UIImage imageNamed:@"checkmarkFilled.png"];
                task.status = YES;
            }
        };
        
    }
    else if (indexPath.section == 2) {
        //Get Tomorrow complishs and assign complish
        NSArray *tasks = [[ZSWTaskStore sharedStore] todayTasks];
        
        ZSWTask *task = tasks[indexPath.row];
        
        if (task.status) {
            cell.checkmark.image = [UIImage imageNamed:@"checkmarkFilled.png"];
        }else {
            cell.checkmark.image = [UIImage imageNamed:@"checkmarkEmpty.png"];
        }
        
        //repeatIcon
        if (task.setToRepeatDictionary) {
            NSDictionary *setToRepeatDictionary = task.setToRepeatDictionary;
            BOOL repeatDaily = [[setToRepeatDictionary valueForKey:@"repeatDaily"] boolValue];
            BOOL repeatWeekly = [[setToRepeatDictionary valueForKey:@"repeatWeekly"] boolValue];
            BOOL repeatMonthly = [[setToRepeatDictionary valueForKey:@"repeatMonthly"] boolValue];
            if (repeatDaily) {
                cell.repeatIcon.image = [UIImage imageNamed:@"repeatDaily.png"];
            } else if (repeatWeekly) {
                cell.repeatIcon.image = [UIImage imageNamed:@"repeatWeekly.png"];
            } else if (repeatMonthly) {
                cell.repeatIcon.image = [UIImage imageNamed:@"repeatMonthly.png"];
            } else {
                cell.repeatIcon.image = nil;
            }
        } else {
            cell.repeatIcon.image = nil;
        }
        
        //NoteIcon
        if (task.note) {
            if (!cell.repeatIcon.image){
                cell.repeatIcon.image = [UIImage imageNamed:@"noteIcon.png"];
            } else {
                cell.noteIcon.image = [UIImage imageNamed:@"noteIcon.png"];
            }
        } else {
            cell.noteIcon.image = nil;
        }
        
        //reminder
        NSArray *localNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
        for (UILocalNotification *note in localNotifications) {
            if (note.alertBody == task.task) {
                cell.reminderIcon.image = [UIImage imageNamed:@"reminderClock.png"];
            }
        }
        
        //Set the complish information
        cell.taskLabel.text = task.task;
        cell.categoryLabel.text = [task.category valueForKey:@"name"];
        
        //making sure there isn't a strong reference cycle
        __weak ZSWTaskCellTableViewCell *weakCell = cell;
        
        //setting the action block to be able to check-off items
        cell.actionBlock = ^{
            ZSWTaskCellTableViewCell *strongCell = weakCell;
            if (task.status) {
                //change background color to yellow and checkmark image to empty
                strongCell.checkmark.image = [UIImage imageNamed:@"checkmarkEmpty.png"];
                task.status = NO;
            } else {
                //change background color to green and checkmark image to filled
                strongCell.checkmark.image = [UIImage imageNamed:@"checkmarkFilled.png"];
                task.status = YES;
            }
        };
    }
    else if (indexPath.section == 3) {
        //Get Yesterday complishs and assign complish
        NSArray *tasks = [[ZSWTaskStore sharedStore] yesterdayTasks];
        ZSWTask *task = tasks[indexPath.row];
        
        if (task.status) {
            cell.checkmark.image = [UIImage imageNamed:@"checkmarkFilled.png"];
        }else {
            cell.checkmark.image = [UIImage imageNamed:@"checkmarkEmpty.png"];
        }
        
        //repeatIcon
        if (task.setToRepeatDictionary) {
            NSDictionary *setToRepeatDictionary = task.setToRepeatDictionary;
            BOOL repeatDaily = [[setToRepeatDictionary valueForKey:@"repeatDaily"] boolValue];
            BOOL repeatWeekly = [[setToRepeatDictionary valueForKey:@"repeatWeekly"] boolValue];
            BOOL repeatMonthly = [[setToRepeatDictionary valueForKey:@"repeatMonthly"] boolValue];
            if (repeatDaily) {
                cell.repeatIcon.image = [UIImage imageNamed:@"repeatDaily.png"];
            } else if (repeatWeekly) {
                cell.repeatIcon.image = [UIImage imageNamed:@"repeatWeekly.png"];
            } else if (repeatMonthly) {
                cell.repeatIcon.image = [UIImage imageNamed:@"repeatMonthly.png"];
            } else {
                cell.repeatIcon.image = nil;
            }
        } else {
            cell.repeatIcon.image = nil;
        }

        //NoteIcon
        if (task.note) {
            if (!cell.repeatIcon.image){
                cell.repeatIcon.image = [UIImage imageNamed:@"noteIcon.png"];
            } else {
                cell.noteIcon.image = [UIImage imageNamed:@"noteIcon.png"];
            }
        } else {
            cell.noteIcon.image = nil;
        }
        
        
        //Set the complish information
        cell.taskLabel.text = task.task;
        cell.categoryLabel.text = [task.category valueForKey:@"name"];
        
        //making sure there isn't a strong reference cycle
        __weak ZSWTaskCellTableViewCell *weakCell = cell;
        
        //setting the action block to be able to check-off items
        cell.actionBlock = ^{
            ZSWTaskCellTableViewCell *strongCell = weakCell;
            if (task.status) {
                //change background color to yellow and checkmark image to empty
                strongCell.checkmark.image = [UIImage imageNamed:@"checkmarkEmpty.png"];
                task.status = NO;
            } else {
                //change background color to green and checkmark image to filled
                strongCell.checkmark.image = [UIImage imageNamed:@"checkmarkFilled.png"];
                task.status = YES;
            }
        };
    }
    else if (indexPath.section == 4) {
        //Get Tomorrow complishs and assign complish
        NSArray *tasks = [[ZSWTaskStore sharedStore] tasksBeforeDate:[NSDate dateWithDaysBeforeNow:2]];
        
        ZSWTask *task = tasks[indexPath.row];
        
        if (task.status) {
            cell.checkmark.image = [UIImage imageNamed:@"checkmarkFilled.png"];
        }else {
            cell.checkmark.image = [UIImage imageNamed:@"checkmarkEmpty.png"];
        }
        
        
        //repeatIcon
        
        if (task.setToRepeatDictionary) {
            NSDictionary *setToRepeatDictionary = task.setToRepeatDictionary;
            BOOL repeatDaily = [[setToRepeatDictionary valueForKey:@"repeatDaily"] boolValue];
            BOOL repeatWeekly = [[setToRepeatDictionary valueForKey:@"repeatWeekly"] boolValue];
            BOOL repeatMonthly = [[setToRepeatDictionary valueForKey:@"repeatMonthly"] boolValue];
            if (repeatDaily) {
                cell.repeatIcon.image = [UIImage imageNamed:@"repeatDaily.png"];
            } else if (repeatWeekly) {
                cell.repeatIcon.image = [UIImage imageNamed:@"repeatWeekly.png"];
            } else if (repeatMonthly) {
                cell.repeatIcon.image = [UIImage imageNamed:@"repeatMonthly.png"];
            } else {
                cell.repeatIcon.image = nil;
            }
        } else {
            cell.repeatIcon.image = nil;
        }
        
        //NoteIcon
        if (task.note) {
            if (!cell.repeatIcon.image){
                cell.repeatIcon.image = [UIImage imageNamed:@"noteIcon.png"];
            } else {
                cell.noteIcon.image = [UIImage imageNamed:@"noteIcon.png"];
            }
        } else {
            cell.noteIcon.image = nil;
        }
        //reminder
        NSArray *localNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
        for (UILocalNotification *note in localNotifications) {
            if (note.alertBody == task.task) {
                cell.reminderIcon.image = [UIImage imageNamed:@"reminderClock.png"];
            }
        }
        
        //task and category
        cell.taskLabel.text = task.task;
        cell.categoryLabel.text = [task.category valueForKey:@"name"];
        //date
        NSInteger daysAgo = [task.date daysBeforeDate:[NSDate date]];
        cell.dateLabel.text = [NSString stringWithFormat:@"%d days ago", daysAgo];
        
        //making sure there isn't a strong reference cycle
        __weak ZSWTaskCellTableViewCell *weakCell = cell;
        
        //setting the action block to be able to check-off items
        cell.actionBlock = ^{
            ZSWTaskCellTableViewCell *strongCell = weakCell;
            if (task.status) {
                //change background color to yellow and checkmark image to empty
                strongCell.checkmark.image = [UIImage imageNamed:@"checkmarkEmpty.png"];
                task.status = NO;
            } else {
                //change background color to green and checkmark image to filled
                strongCell.checkmark.image = [UIImage imageNamed:@"checkmarkFilled.png"];
                task.status = YES;
            }
        };
    }
    
    return cell;
}

//height per row
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Make an off screen cell
    
    
    //Which section?
    if (indexPath.section == 0) {
        
        //Get a statement from the datasource and assign it to the label
        NSArray *tasks = [[ZSWTaskStore sharedStore] futureTasks];
        ZSWTask *task = tasks[indexPath.row];
        
        CGRect labelFrame = CGRectMake(0, 0, 252, 1000);
        UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
        label.preferredMaxLayoutWidth = 252;
        UIFont *font = [UIFont fontWithName:@"Avenir" size:18];
        label.font = font;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.text = task.task;
        label.numberOfLines = 0;
        
        [label sizeToFit];
        
        //Get height of label
        float height = label.frame.size.height;
        
        if ([task.task isEqualToString:@""]){
            return 60;
        }else {
            return 40 + height;
            
        }
    } else if (indexPath.section == 1) {
        
        //Get a statement from the datasource and assign it to the label
        NSArray *tomorrowTasks = [[ZSWTaskStore sharedStore] tomorrowTasks];
        ZSWTask *task = tomorrowTasks[indexPath.row];
        
        CGRect labelFrame = CGRectMake(0, 0, 252, 1000);
        UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
        label.preferredMaxLayoutWidth = 252;
        UIFont *font = [UIFont fontWithName:@"Avenir" size:18];
        label.font = font;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.text = task.task;
        label.numberOfLines = 0;
        
        
        [label sizeToFit];
        
        //Get height of label
        float height = label.frame.size.height;
        
        //if the complish is empty return a standard height
        if ([task.task isEqualToString:@""]){
            return 60;
        }else {
            return 40 + height;
            
        }
    } else if (indexPath.section == 2) {
        
        //Get a statement from the datasource and assign it to the label
        NSArray *todayTasks = [[ZSWTaskStore sharedStore] todayTasks];
        ZSWTask *task = todayTasks[indexPath.row];
        
        CGRect labelFrame = CGRectMake(0, 0, 252, 1000);
        UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
        label.preferredMaxLayoutWidth = 252;
        UIFont *font = [UIFont fontWithName:@"Avenir" size:18];
        label.font = font;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.text = task.task;
        label.numberOfLines = 0;
        
        [label sizeToFit];
        
        //Get height of label
        float height = label.frame.size.height;
        
        if ([task.task isEqualToString:@""]){
            return 60;
        }else {
            return 40 + height;
            
        }
    } else if (indexPath.section == 3) {
        
        //Get a statement from the datasource and assign it to the label
        NSArray *yesterdayTasks = [[ZSWTaskStore sharedStore] yesterdayTasks];
        ZSWTask *task = yesterdayTasks[indexPath.row];
        
        CGRect labelFrame = CGRectMake(0, 0, 252, 1000);
        UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
        label.preferredMaxLayoutWidth = 252;
        UIFont *font = [UIFont fontWithName:@"Avenir" size:18];
        label.font = font;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.text = task.task;
        label.numberOfLines = 0;
        
        [label sizeToFit];
        
        //Get height of label
        float height = label.frame.size.height;
        
        if ([task.task isEqualToString:@""]){
            return 60;
        }else {
            return 40 + height;
            
        }
    }  else if (indexPath.section == 4) {
        
        //Get a statement from the datasource and assign it to the label
        NSArray *tasks = [[ZSWTaskStore sharedStore] tasksBeforeDate:[NSDate dateWithDaysBeforeNow:2]];
        ZSWTask *task = tasks[indexPath.row];
        
        CGRect labelFrame = CGRectMake(0, 0, 252, 1000);
        UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
        label.preferredMaxLayoutWidth = 252;
        UIFont *font = [UIFont fontWithName:@"Avenir" size:18];
        label.font = font;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.text = task.task;
        label.numberOfLines = 0;
        
        [label sizeToFit];
        
        //Get height of label
        float height = label.frame.size.height;
        
        if ([task.task isEqualToString:@""]){
            return 60;
        }else {
            return 40 + height;
            
        }
    }

    
    
    return 100;
    
    
}

/*
//selected a row
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZSSDetailComplishViewController *dcvc = [[ZSSDetailComplishViewController alloc] init];
    if (indexPath.section == 0){
        NSArray *todayComplishs = [[ZSSComplishStore sharedStore] todayComplishs];
        dcvc.complish = todayComplishs[indexPath.row];
    }else if (indexPath.section == 1) {
        NSArray *tomorrowComplishs = [[ZSSComplishStore sharedStore] tomorrowComplishs];
        dcvc.complish = tomorrowComplishs[indexPath.row];
    }
    [self.navigationController pushViewController:dcvc animated:YES];
}
*/
//header height
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

//header view
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    
    //Get colors
    NSDictionary *colors = [[ZSWTaskStore sharedStore] colors];
    UIColor *color = [colors valueForKey:@"productiveGreen"];
    
    //Configure header view
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 35)];
    view.backgroundColor = [UIColor whiteColor];
    
    UIView *grayTopBorder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 1)];
    grayTopBorder.backgroundColor = [UIColor lightGrayColor];
    UIView *grayBottomBorder=  [[UIView alloc] initWithFrame:CGRectMake(0, 34, tableView.frame.size.width, 1)];
    grayBottomBorder.backgroundColor = color;
    
    //Indent the label 55 points
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width, 35)];
    label.textColor = color;
    label.font = [UIFont fontWithName:@"Avenir" size:22];
    
    
    
    //Set name based on section
    if (section == 0) {
        label.text = @"Future";
    } else if (section == 1) {
        label.text = @"Tomorrow";
    } else if (section == 2) {
        label.text = @"Today";
    } else if (section == 3) {
        label.text = @"Yesterday";
    } else if (section == 4) {
        label.text = @"Previous";
    }
    //[view addSubview:grayTopBorder];
    [view addSubview:grayBottomBorder];
    [view addSubview:label];
    
    return view;
}

#pragma mark - Table Interaction

- (void)addTask
{
    //Get a complish from the store
    ZSWTask *task = [[ZSWTaskStore sharedStore] createTask];
    
    //New Complish Creator controller
    ZSWNewTaskViewController *ntvc = [[ZSWNewTaskViewController alloc] init];
    ntvc.task = task;
    
    
    //Configure nav
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                                            NSForegroundColorAttributeName: [UIColor whiteColor],
                                                            NSFontAttributeName: [UIFont fontWithName:@"Avenir" size:23.0f],
                                                            }];
    

    [self.navigationController pushViewController:ntvc animated:YES];
    
}

- (void)editMode
{
    [self.tableView setEditing:YES animated:YES];
    UIBarButtonItem *cancelLeftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                      target:self
                                                                                      action:@selector(cancelEdit)];
    self.navigationItem.leftBarButtonItem = cancelLeftButton;
}

- (void)cancelEdit
{
    [self.tableView setEditing:NO animated:YES];
    self.navigationItem.leftBarButtonItem = nil;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (indexPath.section == 0) {
            NSArray *tasks = [[ZSWTaskStore sharedStore] futureTasks];
            ZSWTask *task = tasks[indexPath.row];
            for (UILocalNotification *note in notifications) {
                if ([note.alertBody isEqual:task.task]){
                    [[UIApplication sharedApplication] cancelLocalNotification:note];
                }
            }
            [[ZSWTaskStore sharedStore]removeTask:task];
            
            [self.tableView reloadData];
            
        } else if (indexPath.section == 1) {
            NSArray *tasks = [[ZSWTaskStore sharedStore] tomorrowTasks];
            ZSWTask *task = tasks[indexPath.row];
            for (UILocalNotification *note in notifications) {
                if ([note.alertBody isEqual:task.task]){
                    [[UIApplication sharedApplication] cancelLocalNotification:note];
                }
            }
            [[ZSWTaskStore sharedStore]removeTask:task];
            
            [self.tableView reloadData];
            
        }else if (indexPath.section == 2) {
            NSArray *tasks = [[ZSWTaskStore sharedStore] todayTasks];
            ZSWTask *task = tasks[indexPath.row];
            for (UILocalNotification *note in notifications) {
                if ([note.alertBody isEqual:task.task]){
                    [[UIApplication sharedApplication] cancelLocalNotification:note];
                }
            }
            [[ZSWTaskStore sharedStore]removeTask:task];
            [self.tableView reloadData];
            
        }else if (indexPath.section == 3) {
            NSArray *tasks = [[ZSWTaskStore sharedStore] yesterdayTasks];
            ZSWTask *task = tasks[indexPath.row];
            for (UILocalNotification *note in notifications) {
                if ([note.alertBody isEqual:task.task]){
                    [[UIApplication sharedApplication] cancelLocalNotification:note];
                }
            }
            [[ZSWTaskStore sharedStore]removeTask:task];
            [self.tableView reloadData];
            
        }else if (indexPath.section == 4) {
            NSArray *tasks = [[ZSWTaskStore sharedStore] tasksBeforeDate:[NSDate dateWithDaysBeforeNow:2]];;
            ZSWTask *task = tasks[indexPath.row];
            for (UILocalNotification *note in notifications) {
                if ([note.alertBody isEqual:task.task]){
                    [[UIApplication sharedApplication] cancelLocalNotification:note];
                }
            }
            [[ZSWTaskStore sharedStore]removeTask:task];
            [self.tableView reloadData];
            
        }

        
        
    }
    BOOL success = [[ZSWTaskStore sharedStore] saveChanges];
    if (success) {
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        //future
        NSArray *tasks = [[ZSWTaskStore sharedStore] futureTasks];
        ZSWDetailViewController *dvc = [[ZSWDetailViewController alloc] init];
        dvc.task = tasks[indexPath.row];
        [self.navigationController pushViewController:dvc animated:YES];
        
    } else if (indexPath.section == 1) {
        //tomorrow
        NSArray *tasks = [[ZSWTaskStore sharedStore] tomorrowTasks];
        ZSWDetailViewController *dvc = [[ZSWDetailViewController alloc] init];
        dvc.task = tasks[indexPath.row];
        [self.navigationController pushViewController:dvc animated:YES];
        
    } else if (indexPath.section == 2) {
        //today
        NSArray *tasks = [[ZSWTaskStore sharedStore] todayTasks];
        ZSWDetailViewController *dvc = [[ZSWDetailViewController alloc] init];
        dvc.task = tasks[indexPath.row];
        [self.navigationController pushViewController:dvc animated:YES];

    } else if (indexPath.section == 3) {
        //Yesterday
        NSArray *tasks = [[ZSWTaskStore sharedStore] yesterdayTasks];
        ZSWDetailViewController *dvc = [[ZSWDetailViewController alloc] init];
        dvc.task = tasks[indexPath.row];
        [self.navigationController pushViewController:dvc animated:YES];
        
    } else if (indexPath.section == 4) {
        //Yesterday
        NSArray *tasks = [[ZSWTaskStore sharedStore] tasksBeforeDate:[NSDate dateWithDaysBeforeNow:2]];
        ZSWDetailViewController *dvc = [[ZSWDetailViewController alloc] init];
        dvc.task = tasks[indexPath.row];
        [self.navigationController pushViewController:dvc animated:YES];
        
    }
    
}


@end
