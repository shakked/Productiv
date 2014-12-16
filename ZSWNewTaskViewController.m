//
//  ZSWNewTaskViewController.m
//  Productiv
//
//  Created by Zachary Shakked on 7/19/14.
//  Copyright (c) 2014 Productiv. All rights reserved.
//

#import "ZSWNewTaskViewController.h"
#import "ZSWTaskStore.h"
#import "ZSWCategoryViewController.h"
#import "NSDate+Escort.h"
#import "ZSWNoteViewController.h"
#import "ZSWDatePickerViewController.h"
#import "ZSWRepeatSelectorViewController.h"

@interface ZSWNewTaskViewController () <UITextFieldDelegate>

//reminderView info
@property (nonatomic, strong) UIView *reminderView;
@property (nonatomic, strong) UIView *dimView;
@property (nonatomic, strong) UIDatePicker *reminderDatePicker;
@property (nonatomic, strong) NSDate *reminderDate;

//dateView info
@property (nonatomic, strong) UIView *dateView;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) NSDate *date;

//reminder display
@property (weak, nonatomic) IBOutlet UIView *reminderDisplayView;
@property (weak, nonatomic) IBOutlet UIImageView *reminderClock;
@property (weak, nonatomic) IBOutlet UILabel *reminderInfoLabel;
- (IBAction)showReminderView:(id)sender;

//setToRepeat
@property (weak, nonatomic) IBOutlet UIView *repeatDisplayView;
@property (weak, nonatomic) IBOutlet UIImageView *repeatIcon;
@property (weak, nonatomic) IBOutlet UILabel *repeatInfoLabel;
- (IBAction)setToRepeat:(id)sender;


@property (nonatomic, weak) IBOutlet UIImageView *checkmark;
@property (nonatomic, weak) IBOutlet UILabel *taskIntroLabel;
@property (nonatomic, weak) IBOutlet UITextField *textField;

//category
@property (weak, nonatomic) IBOutlet UIView *categoryDisplayView;
@property (weak, nonatomic) IBOutlet UIButton *categoryButton;
- (IBAction)showCategories:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UIImageView *categoryDownArrow;


@property (nonatomic, weak) IBOutlet UILabel *noteLabel;
@property (nonatomic, weak) IBOutlet UIButton *noteButton;
@property (nonatomic, weak) IBOutlet UIImageView *noteImage;

@property (nonatomic, weak) IBOutlet UILabel *selectADateLabel;

@property (nonatomic, weak) IBOutlet UIButton *todayButton;
@property (nonatomic, weak) IBOutlet UIButton *tomorrowButton;
@property (nonatomic, weak) IBOutlet UIButton *otherButton;

//set to repeat




//other actions
- (IBAction)switchTask:(id)sender;
- (IBAction)showNote:(id)sender;
//date buttons
- (IBAction)today:(id)sender;
- (IBAction)tomorrow:(id)sender;
- (IBAction)other:(id)sender;

@end

@implementation ZSWNewTaskViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"New Task";
    self.textField.delegate = self;
    //colors
    NSDictionary *colors = [[ZSWTaskStore sharedStore] colors];
    UIColor *color = [colors valueForKey:@"productiveGreen"];
    
    
    //checkmark
    if (self.task.status) {
        self.checkmark.image = [UIImage imageNamed:@"checkmarkFilled.png"];
    } else {
        self.checkmark.image = [UIImage imageNamed:@"checkmarkEmpty.png"];
    }
    
    //task intro
    self.taskIntroLabel.font = [UIFont fontWithName:@"Avenir" size:20.0];
    
    NSArray *completeButtons = @[self.todayButton, self.tomorrowButton, self.otherButton];
    //green buttons
    for (UIButton *button in completeButtons) {
        button.backgroundColor = color;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [[button layer] setCornerRadius:7.0];
        button.titleLabel.font = [UIFont fontWithName:@"Avenir" size:16.0];
    }
    
    //Category
        //view
    self.categoryDisplayView.backgroundColor = color;
    [[self.categoryDisplayView layer] setCornerRadius:7.0];
        //label
    self.categoryLabel.font = [UIFont fontWithName:@"Avenir-Heavy" size:16.0];
    self.categoryLabel.textColor = [UIColor whiteColor];
        //downArrow image
    self.categoryDownArrow.image = [UIImage imageNamed:@"downArrow.png"];
    
    
    //reminderDisplayView
    self.reminderClock.image = [UIImage imageNamed:@"reminderClock.png"];
    [[self.reminderDisplayView layer] setBorderColor:[UIColor lightGrayColor].CGColor];
    [[self.reminderDisplayView layer] setBorderWidth:1.0];
    [[self.reminderDisplayView layer] setCornerRadius:7.0];
    self.reminderDisplayView.backgroundColor = [UIColor whiteColor];

    
    //Set to repeat
    self.repeatIcon.image = [UIImage imageNamed:@"repeatIcon@2x.png"];
    [[self.repeatDisplayView layer] setBorderColor:[UIColor lightGrayColor].CGColor];
    [[self.repeatDisplayView layer] setBorderWidth:1.0];
    [[self.repeatDisplayView layer] setCornerRadius:7.0];
    self.repeatDisplayView.backgroundColor = [UIColor whiteColor];
    
    //Note Label
    self.noteLabel.textColor = color;
    
    //Note button
    self.noteImage.image = [UIImage imageNamed:@"bigNote.png"];
    
    //select a date label
    self.selectADateLabel.font = [UIFont fontWithName:@"Avenir" size:16.0];
    
    //Navigation bar
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = color;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    NSLog(@"made it to view will appear");
    //reload the category button appearence
    NSString *category = [self.task.category valueForKey:@"name"];
    if (!category || [category isEqual:@""]){
        self.categoryLabel.text = @"Category";
    } else {
        self.categoryLabel.text = category;
    }
    
    //if theres a date set show it
    if (self.task.date) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterFullStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        NSDate *date = self.task.date;
        
        NSString *formattedDateString = [dateFormatter stringFromDate:date];
        NSString *string = [[NSString alloc] init];
        if ([self.task.date isToday]) {
            string = [NSString stringWithFormat:@"Task for Today, %@.", formattedDateString];
        } else if ([self.task.date isYesterday]) {
            string = [NSString stringWithFormat:@"Task for Yesterday, %@.", formattedDateString];
        } else if ([self.task.date isTomorrow]) {
            string = [NSString stringWithFormat:@"Task for Tomorrow, %@.", formattedDateString];
        } else {
            string = [NSString stringWithFormat:@"Task for %@.", formattedDateString];
        }
        self.taskIntroLabel.text = string;
        self.taskIntroLabel.textColor = [UIColor lightGrayColor];
        self.taskIntroLabel.font = [UIFont fontWithName:@"Avenir-Heavy" size:16.0];
        
        //add a save button
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                             target:self
                                                                                      action:@selector(save)];
                                
        
        self.navigationItem.rightBarButtonItem = bbi;
    }else {
        //self.dateLabel.text = @"";
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    NSDictionary *colors = [[ZSWTaskStore sharedStore] colors];
    UIColor *color = [colors valueForKey:@"productiveGreen"];
    UIColor *textGray = [colors valueForKey:@"textGray"];
    //setToRepeat
    if (self.task.repeatString) {
        //calculate label height:
        self.repeatInfoLabel.text = self.task.repeatString;
        self.repeatIcon.image = [UIImage imageNamed:@"repeatIconFilled.png"];
        self.repeatInfoLabel.textColor = color;
        [[self.repeatDisplayView layer] setBorderColor:color.CGColor];
    }else{
        self.repeatInfoLabel.text = @"Set this task to repeat";
        self.repeatIcon.image = [UIImage imageNamed:@"repeatIcon.png"];
        self.repeatInfoLabel.textColor = textGray;
        [[self.repeatDisplayView layer] setBorderColor:textGray.CGColor];
    }

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (!self.task.repeatString) {
        self.task.setToRepeatDictionary = nil;
    }
    if ([self.task.task isEqual:@""]) {
        [[ZSWTaskStore sharedStore] removeTask:self.task];
    }
    [self.textField endEditing:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Textfield and Keyboard


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

- (IBAction)touchUpInside:(id)sender
{
    
    if ([self.textField isEditing]) {
        [self.textField endEditing:YES];
    }else {
        return;
    }
    
}
#pragma mark - Set a Date
- (void)showDateView
{
    [self.textField endEditing:YES];
    NSDictionary *colors = [[ZSWTaskStore sharedStore] colors];
    UIColor *color = [colors valueForKey:@"productiveGreen"];
    
    //dateView
    CGRect newViewFrame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 270);
    self.dateView = [[UIView alloc] initWithFrame:newViewFrame];
    self.dateView.backgroundColor = [UIColor whiteColor];
    
    //cancel button
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, self.dateView.bounds.size.width / 2 - 20, 30)];
    cancelButton.backgroundColor = color;
    [[cancelButton layer] setCornerRadius:7.0];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont fontWithName:@"Avenir" size:16.0];
    cancelButton.titleLabel.textColor = [UIColor blackColor];
    [cancelButton addTarget:self action:@selector(cancelDate) forControlEvents:UIControlEventTouchUpInside];
    //save button
    UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(self.dateView.bounds.size.width / 2 + 10, 10, self.dateView.bounds.size.width / 2 - 20, 30)];
    saveButton.backgroundColor = color;
    [[saveButton layer] setCornerRadius:7.0];
    [saveButton setTitle:@"Save Date" forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Heavy" size:16.0];
    saveButton.titleLabel.textColor = [UIColor blackColor];
    [saveButton addTarget:self action:@selector(saveDate) forControlEvents:UIControlEventTouchUpInside];
    
    //date picker
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, self.dateView.bounds.size.width, 180)];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    
    //dim view
    self.dimView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.dimView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.dimView];
    
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.dateView.frame = CGRectMake(0, self.view.bounds.size.height-320, self.view.bounds.size.width, 270);
                         self.dimView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5];
                         
                     }];
    
    
    [self.dimView addSubview:self.dateView];
    [self.dateView addSubview:cancelButton];
    [self.dateView addSubview:saveButton];
    [self.dateView addSubview:self.datePicker];
    
}

- (void)cancelDate
{
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.dateView.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 270);
                         self.dimView.backgroundColor = [UIColor clearColor];
                         
                     }
                     completion:^ (BOOL finished){
                         [self.dimView removeFromSuperview];
                     }];
    
    
}

- (void)saveDate
{
    //add save button
    if (!self.navigationItem.rightBarButtonItem) {
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                             target:self
                                                                             action:@selector(save)];
        self.navigationItem.rightBarButtonItem = bbi;
    }
    
    self.date = self.datePicker.date;
    self.task.date = self.date;
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.dateView.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 270);
                         self.dimView.backgroundColor = [UIColor clearColor];
                         
                     }
                     completion:^ (BOOL finished){
                         [self.dimView removeFromSuperview];
                         NSDateFormatter *formatDate = [[NSDateFormatter alloc] init];
                         [formatDate setDateFormat:@"MMM dd, yyyy"];
                         
                         NSString *dateStringDate = [formatDate stringFromDate:self.task.date];
                         
                         NSString *dateString = [NSString stringWithFormat:@"Task for %@", dateStringDate];
                         self.taskIntroLabel.text = dateString;
                         self.taskIntroLabel.font = [UIFont fontWithName:@"Avenir" size:16.0];
                         self.taskIntroLabel.textColor = [UIColor grayColor];
                         
                     }];
    
    
    
    
}


#pragma mark - Set a Reminder
- (IBAction)showReminderView:(id)sender
{
    [self.textField endEditing:YES];
    NSDictionary *colors = [[ZSWTaskStore sharedStore] colors];
    UIColor *color = [colors valueForKey:@"productiveGreen"];
    
    //reminderView
    CGRect newViewFrame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 270);
    self.reminderView = [[UIView alloc] initWithFrame:newViewFrame];
    self.reminderView.backgroundColor = [UIColor whiteColor];
    
    //cancel button
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, self.reminderView.bounds.size.width / 2 - 20, 30)];
    cancelButton.backgroundColor = color;
    [[cancelButton layer] setCornerRadius:7.0];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont fontWithName:@"Avenir" size:16.0];
    cancelButton.titleLabel.textColor = [UIColor blackColor];
    [cancelButton addTarget:self action:@selector(cancelReminder) forControlEvents:UIControlEventTouchUpInside];
    //save button
    UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(self.reminderView.bounds.size.width / 2 + 10, 10, self.reminderView.bounds.size.width / 2 - 20, 30)];
    saveButton.backgroundColor = color;
    [[saveButton layer] setCornerRadius:7.0];
    [saveButton setTitle:@"Save Reminder" forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Heavy" size:16.0];
    saveButton.titleLabel.textColor = [UIColor blackColor];
    [saveButton addTarget:self action:@selector(saveReminder) forControlEvents:UIControlEventTouchUpInside];
    
    //date picker
    self.reminderDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, self.reminderView.bounds.size.width, 180)];
    
    //dim view
    self.dimView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.dimView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.dimView];

    
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.reminderView.frame = CGRectMake(0, self.view.bounds.size.height-320, self.view.bounds.size.width, 270);
                         self.dimView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5];
                         
                     }];
    
    
    [self.dimView addSubview:self.reminderView];
    [self.reminderView addSubview:cancelButton];
    [self.reminderView addSubview:saveButton];
    [self.reminderView addSubview:self.reminderDatePicker];

}

- (void)cancelReminder
{
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.reminderView.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 270);
                         self.dimView.backgroundColor = [UIColor clearColor];

                     }
                     completion:^ (BOOL finished){
                         [self.dimView removeFromSuperview];
                     }];

    
}

- (void)saveReminder
{
    NSDictionary *colors = [[ZSWTaskStore sharedStore] colors];
    UIColor *color = [colors valueForKey:@"productiveGreen"];
    
    self.reminderDate = self.reminderDatePicker.date;
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.reminderView.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 270);
                         self.dimView.backgroundColor = [UIColor clearColor];
                         
                     }
                     completion:^ (BOOL finished){
                         [self.dimView removeFromSuperview];
                         NSDateFormatter *formatTime = [[NSDateFormatter alloc] init];
                         [formatTime setDateFormat:@"hh:mm a"];
                         
                         NSDateFormatter *formatDate = [[NSDateFormatter alloc] init];
                         [formatDate setDateFormat:@"MMM dd, yyyy"];
                         
                         NSString *dateStringTime = [formatTime stringFromDate:self.reminderDate];
                         NSString *dateStringDate = [formatDate stringFromDate:self.reminderDate];
                         
                         NSString *dateString = [NSString stringWithFormat:@"%@ on %@", dateStringTime, dateStringDate];
                         self.reminderInfoLabel.text = dateString;
                         self.reminderClock.image = [UIImage imageNamed:@"reminderClockSet.png"];
                         self.reminderInfoLabel.textColor = color;
                         [[self.reminderDisplayView layer] setBorderColor:color.CGColor];

                     }];
    

    
    
}

#pragma mark - Set to Repeat
- (IBAction)setToRepeat:(id)sender
{
    ZSWRepeatSelectorViewController *rsvc = [[ZSWRepeatSelectorViewController alloc] init];
    rsvc.task = self.task;
    [self.navigationController pushViewController:rsvc animated:YES];
}

#pragma mark - Task Actions




- (void)takePicture
{
    
}

- (IBAction)switchTask:(id)sender
{
    if (self.task.status) {
        self.task.status = NO;
        self.checkmark.image = [UIImage imageNamed:@"checkmarkEmpty.png"];
    } else {
        self.task.status = YES;
        self.checkmark.image = [UIImage imageNamed:@"checkmarkFilled.png"];
    }
}
- (IBAction)showCategories:(id)sender
{
    //Dismiss keyboard
    [self.textField endEditing:YES];
    
    ZSWCategoryViewController *cvc = [[ZSWCategoryViewController alloc] init];
    //Pass the task to the controller
    cvc.fromNewTask = YES;
    cvc.task = self.task;
    [self.navigationController pushViewController:cvc animated:YES];
    
}

- (IBAction)showNote:(id)sender
{
    ZSWNoteViewController *nvc = [[ZSWNoteViewController alloc] init];
    nvc.task = self.task;
    [self.navigationController pushViewController:nvc animated:YES];
}

- (IBAction)today:(id)sender
{
    self.task.task = self.textField.text;
    self.task.date = [NSDate date];
    //taskIntroLabel
    NSDateFormatter *formatDate = [[NSDateFormatter alloc] init];
    [formatDate setDateFormat:@"MMM dd, yyyy"];
    
    NSString *dateStringDate = [formatDate stringFromDate:self.task.date];
    
    NSString *dateString = [NSString stringWithFormat:@"Task for Today, %@", dateStringDate];
    self.taskIntroLabel.text = dateString;
    self.taskIntroLabel.font = [UIFont fontWithName:@"Avenir" size:16.0];
    self.taskIntroLabel.textColor = [UIColor grayColor];
    
    //bold button
    NSArray *completeButtons = @[self.todayButton, self.tomorrowButton, self.otherButton];
    for (UIButton *button in completeButtons) {
        button.titleLabel.font = [UIFont fontWithName:@"Avenir" size:16.0];
    }
    self.todayButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Heavy" size:18.0];
    //add save button
    if (!self.navigationItem.rightBarButtonItem) {
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                             target:self
                                                                             action:@selector(save)];
        self.navigationItem.rightBarButtonItem = bbi;
    }
}

- (IBAction)tomorrow:(id)sender
{
    self.task.task = self.textField.text;
    self.task.date = [NSDate dateTomorrow];
    
    //taskIntroLabel
    NSDateFormatter *formatDate = [[NSDateFormatter alloc] init];
    [formatDate setDateFormat:@"MMM dd, yyyy"];
    
    NSString *dateStringDate = [formatDate stringFromDate:self.task.date];
    
    NSString *dateString = [NSString stringWithFormat:@"Task for Tomorrow, %@", dateStringDate];
    self.taskIntroLabel.text = dateString;
    self.taskIntroLabel.font = [UIFont fontWithName:@"Avenir" size:16.0];
    self.taskIntroLabel.textColor = [UIColor grayColor];
    
    //bold button
    NSArray *completeButtons = @[self.todayButton, self.tomorrowButton, self.otherButton];
    for (UIButton *button in completeButtons) {
        button.titleLabel.font = [UIFont fontWithName:@"Avenir" size:16.0];
    }
    self.tomorrowButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Heavy" size:18.0];
    //add save button
    if (!self.navigationItem.rightBarButtonItem) {
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                             target:self
                                                                             action:@selector(save)];
        self.navigationItem.rightBarButtonItem = bbi;
    }
}

- (IBAction)other:(id)sender
{
    //Bold button
    NSArray *completeButtons = @[self.todayButton, self.tomorrowButton, self.otherButton];
    for (UIButton *button in completeButtons) {
        button.titleLabel.font = [UIFont fontWithName:@"Avenir" size:16.0];
    }
    self.otherButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Heavy" size:18.0];
    
    [self showDateView];
}

- (void)save
{
    self.task.task = self.textField.text;
    
    //reminder notificatin
    if (![self.task.task isEqual:@""]) {
        UILocalNotification *note = [[UILocalNotification alloc] init];
        note.alertBody = [NSString stringWithFormat:@"%@", self.task.task];
        note.fireDate = self.reminderDate;
        note.timeZone = [NSTimeZone systemTimeZone];
        note.soundName = UILocalNotificationDefaultSoundName;

        [[UIApplication sharedApplication] scheduleLocalNotification:note];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        self.taskIntroLabel.textColor = [UIColor redColor];
        self.taskIntroLabel.text = @"Your task is blank!";
    }
}

@end
