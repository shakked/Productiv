//
//  ZSWDatePickerViewController.m
//  Productiv
//
//  Created by Zachary Shakked on 7/21/14.
//  Copyright (c) 2014 Productiv. All rights reserved.
//

#import "ZSWDatePickerViewController.h"
#import "ZSWTaskStore.h"

@interface ZSWDatePickerViewController ()

@property (nonatomic, weak) IBOutlet UILabel *todayIsLabel;
@property (nonatomic, weak) IBOutlet UIDatePicker *datePicker;

@end

@implementation ZSWDatePickerViewController

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
    //colors
    NSDictionary *colors = [[ZSWTaskStore sharedStore]  colors];
    UIColor *color = [colors valueForKey:@"productiveGreen"];
    
    //todayIsLabel
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        //formatting
    NSString *dateString = [dateFormatter stringFromDate:date];
    NSString *string = [NSString stringWithFormat:@"Today is: %@", dateString];
    NSRange range;
    range = [string rangeOfString:@":"];
    NSInteger length = [dateString length];
    NSRange rangeForColon = NSMakeRange(range.location + 2, length);
    NSMutableAttributedString *formattedDateString = [[NSMutableAttributedString alloc] initWithString:string];
    [formattedDateString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Avenir-Heavy" size:18.0] range:rangeForColon];
    self.todayIsLabel.attributedText = formattedDateString;
    
    //date picker
    self.datePicker.date = [NSDate date];

    [[self.datePicker layer] setBorderWidth:1.0];
    [[self.datePicker layer] setBorderColor:color.CGColor];

    //nav bar
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                         target:self
                                                                         action:@selector(saveDate)];
    self.navigationItem.rightBarButtonItem = bbi;
    self.navigationItem.title = @"Date";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Interaction

- (void)saveDate
{
    self.task.date = self.datePicker.date;
    [self.navigationController popViewControllerAnimated:YES];
}

@end
