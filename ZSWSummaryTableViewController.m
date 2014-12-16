//
//  ZSWTaskTableViewController.m
//
//
//  Created by Zachary Shakked on 7/19/14.
//
//
#import "ZSWSummaryTableViewController.h"
#import "ZSWTaskByCategoryTableViewController.h"
#import "ZSWTaskCellTableViewCell.h"
#import "SVPullToRefresh.h"
#import "ZSWTaskStore.h"
#import "ZSWTask.h"
#import "ZSWNewTaskViewController.h"
#import "ZSWDetailViewController.h"
#import "NSDate+Escort.h"

@interface ZSWSummaryTableViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UISegmentedControl *segControl;

@end


@implementation ZSWSummaryTableViewController

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
    
    //Category
    self.navigationItem.title = @"Tasks";
    
    //Load the NIB file for the customized cell view
    UINib *nib = [UINib nibWithNibName:@"ZSWTaskCellTableViewCell" bundle:nil];
    
    //tableView
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    //Register this Nib, which contains the cell
    [self.tableView registerNib:nib forCellReuseIdentifier:@"ZSWTaskCellTableViewCell"];
    
    //pull to refresh
    __weak ZSWSummaryTableViewController *weakSelf = self;
    
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
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [[ZSWTaskStore sharedStore] updateWithRepeats];
    [super viewWillAppear:animated];
    //Make sure its not editing
    [self.tableView setEditing:NO animated:NO];
    
    BOOL success = [[ZSWTaskStore sharedStore] saveChanges];
    if(success) {
        NSLog(@"Successfully saved.");
    }
    //clean the tasks
    [[ZSWTaskStore sharedStore] cleanTasksThatAreEmpty];
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
    return 1;
}

//rows per section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *tasks = [[NSArray alloc] init];
    if (self.segIndex == 0) {
        tasks = [[ZSWTaskStore sharedStore] allTasksOrdered];
    } else if (self.segIndex == 1) {
        tasks = [[ZSWTaskStore sharedStore] completeTasks];
    } else if (self.segIndex == 2) {
        tasks = [[ZSWTaskStore sharedStore] incompleteTasks];
    }
    return [tasks count];
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
    if (indexPath.section == 0) {
        [cell addGestureRecognizer:longPress];
        [cell addGestureRecognizer:rightSwipe];
        [cell addGestureRecognizer:leftSwipe];
        //Get complishs for section and make the complish
        NSArray *tasks = [[NSArray alloc] init];
        if (self.segIndex == 0) {
            tasks = [[ZSWTaskStore sharedStore] allTasksOrdered];
        } else if (self.segIndex == 1) {
            tasks = [[ZSWTaskStore sharedStore] completeTasks];
        } else if (self.segIndex == 2) {
            tasks = [[ZSWTaskStore sharedStore] incompleteTasks];
        }
        ZSWTask *task = tasks[indexPath.row];
        //Format cell based on status
        if (task.status) {
            cell.checkmark.image = [UIImage imageNamed:@"checkmarkFilled.png"];
        }else {
            cell.checkmark.image = [UIImage imageNamed:@"checkmarkEmpty.png"];
        }
        
        //days ago
        if([task.date isToday]) {
            cell.dateLabel.text = @"Today";
        } else if ([task.date isYesterday]) {
            cell.dateLabel.text = @"Yesterday";
        } else if ([task.date isTomorrow]) {
            cell.dateLabel.text = @"Tomorrow";
        } else if ([task.date isInPast]) {
            NSInteger daysAgo = [task.date daysBeforeDate:[NSDate date]];
            cell.dateLabel.text = [NSString stringWithFormat:@"%ld days ago", (long)daysAgo];
        } else if ([task.date isInFuture]) {
            NSInteger daysUntil = [task.date daysAfterDate:[NSDate date]];
            cell.dateLabel.text = [NSString stringWithFormat:@"In %ld days", (long)daysUntil];
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
    return cell;
}

//height per row
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Which section?
    if (indexPath.section == 0) {
        NSArray *tasks = [[NSArray alloc] init];
        if (self.segIndex == 0) {
            tasks = [[ZSWTaskStore sharedStore] allTasksOrdered];
        } else if (self.segIndex == 1) {
            tasks = [[ZSWTaskStore sharedStore] completeTasks];
        } else if (self.segIndex == 2) {
            tasks = [[ZSWTaskStore sharedStore] incompleteTasks];
        }        //Get a statement from the datasource and assign it to the label
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
        
        //if the complish is empty return a standard height
        if ([task.task isEqualToString:@""]){
            return 60;
        }else {
            return 40 + height;
            
        }
    }
    
    return 100;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}

//header view
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSDictionary *colors = [[ZSWTaskStore sharedStore] colors];
    UIColor *color = [colors valueForKey:@"productiveGreen"];
    
    //Configure header view
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
    view.backgroundColor = [UIColor whiteColor];
    
    //Segmented Control
    self.segControl = [[UISegmentedControl alloc] initWithItems:@[@"All", @"Complete", @"Incomplete"]];
    self.segControl.frame = CGRectMake(10, 5, self.tableView.frame.size.width-20,35);
    [self.segControl addTarget:self action:@selector(showSet) forControlEvents:UIControlEventValueChanged];
    if (self.segIndex) {
        NSLog(@"self.segindex: %ld", (long)self.segIndex);
        self.segControl.selectedSegmentIndex = self.segIndex;
    } else {
        self.segControl.selectedSegmentIndex = 0;
    }
    
    [view addSubview:self.segControl];
    self.segControl.tintColor = color;
    return view;
}

#pragma mark - Table Interaction

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
            NSArray *tasks = [[NSArray alloc] init];
            if (self.segIndex == 0) {
                tasks = [[ZSWTaskStore sharedStore] allTasksOrdered];
            } else if (self.segIndex == 1) {
                tasks = [[ZSWTaskStore sharedStore] completeTasks];
            } else if (self.segIndex == 2) {
                tasks = [[ZSWTaskStore sharedStore] incompleteTasks];
            }
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
        //categoryTasks
        NSArray *tasks = [[NSArray alloc] init];
        if (self.segIndex == 0) {
            tasks = [[ZSWTaskStore sharedStore] allTasksOrdered];
        } else if (self.segIndex == 1) {
            tasks = [[ZSWTaskStore sharedStore] completeTasks];
        } else if (self.segIndex == 2) {
            tasks = [[ZSWTaskStore sharedStore] incompleteTasks];
        }
        
        ZSWDetailViewController *dvc = [[ZSWDetailViewController alloc] init];
        dvc.task = tasks[indexPath.row];
        [self.navigationController pushViewController:dvc animated:YES];
        
    }
    
}

#pragma mark - Seg Control Actions
-(void)showSet
{    
    if (self.segControl.selectedSegmentIndex == 0) {
        self.segIndex = 0;
    } else if (self.segControl.selectedSegmentIndex == 1) {
        self.segIndex = 1;
    } else if (self.segControl.selectedSegmentIndex == 2) {
        self.segIndex = 2;
    }
    
    [self.tableView reloadData];
    
}


@end
