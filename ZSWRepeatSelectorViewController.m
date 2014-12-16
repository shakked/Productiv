//
//  ZSWRepeatSelectorViewController.m
//  Productiv
//
//  Created by Zachary Shakked on 7/21/14.
//  Copyright (c) 2014 Productiv. All rights reserved.
//

#import "ZSWRepeatSelectorViewController.h"
#import "ZSWTask.h"
#import "ZSWTaskStore.h"


@interface ZSWRepeatSelectorViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, weak) UIColor *color;
@property (nonatomic, weak) IBOutlet UILabel *setToRepeatLabel;

@property (nonatomic, weak) IBOutlet UIButton *repeatDailyButton;
@property (nonatomic) BOOL repeatDaily;
@property (nonatomic, weak) IBOutlet UIButton *repeatWeeklyButton;
@property (nonatomic) BOOL repeatWeekly;
@property (nonatomic, weak) IBOutlet UIButton *repeatMonthlyButton;
@property (nonatomic) BOOL repeatMonthly;

@property (nonatomic, weak) IBOutlet UIButton *sundayButton;
@property (nonatomic) BOOL sunday;

@property (nonatomic, weak) IBOutlet UIButton *mondayButton;
@property (nonatomic) BOOL monday;

@property (nonatomic, weak) IBOutlet UIButton *tuesdayButton;
@property (nonatomic) BOOL tuesday;

@property (nonatomic, weak) IBOutlet UIButton *wednesdayButton;
@property (nonatomic) BOOL wednesday;

@property (nonatomic, weak) IBOutlet UIButton *thursdayButton;
@property (nonatomic) BOOL thursday;

@property (nonatomic, weak) IBOutlet UIButton *fridayButton;
@property (nonatomic) BOOL friday;

@property (nonatomic, weak) IBOutlet UIButton *saturdayButton;
@property (nonatomic) BOOL saturday;

@property (nonatomic, weak) IBOutlet UIButton *oneButton;
@property (nonatomic) BOOL one;
@property (nonatomic, weak) IBOutlet UIButton *twoButton;
@property (nonatomic) BOOL two;
@property (nonatomic, weak) IBOutlet UIButton *threeButton;
@property (nonatomic) BOOL three;
@property (nonatomic, weak) IBOutlet UIButton *fourButton;
@property (nonatomic) BOOL four;
@property (nonatomic, weak) IBOutlet UIButton *fiveButton;
@property (nonatomic) BOOL five;
@property (nonatomic, weak) IBOutlet UIButton *sixButton;
@property (nonatomic) BOOL six;
@property (nonatomic, weak) IBOutlet UIButton *sevenButton;
@property (nonatomic) BOOL seven;
@property (nonatomic, weak) IBOutlet UIButton *eightButton;
@property (nonatomic) BOOL eight;
@property (nonatomic, weak) IBOutlet UIButton *nineButton;
@property (nonatomic) BOOL nine;
@property (nonatomic, weak) IBOutlet UIButton *tenButton;
@property (nonatomic) BOOL ten;
@property (nonatomic, weak) IBOutlet UIButton *elevenButton;
@property (nonatomic) BOOL eleven;
@property (nonatomic, weak) IBOutlet UIButton *twelveButton;
@property (nonatomic) BOOL twelve;
@property (nonatomic, weak) IBOutlet UIButton *thirteenButton;
@property (nonatomic) BOOL thirteen;
@property (nonatomic, weak) IBOutlet UIButton *fourteenButton;
@property (nonatomic) BOOL fourteen;
@property (nonatomic, weak) IBOutlet UIButton *fifteenButton;
@property (nonatomic) BOOL fifteen;
@property (nonatomic, weak) IBOutlet UIButton *sixteenButton;
@property (nonatomic) BOOL sixteen;
@property (nonatomic, weak) IBOutlet UIButton *seventeenButton;
@property (nonatomic) BOOL seventeen;
@property (nonatomic, weak) IBOutlet UIButton *eighteenButton;
@property (nonatomic) BOOL eighteen;
@property (nonatomic, weak) IBOutlet UIButton *nineteenButton;
@property (nonatomic) BOOL nineteen;
@property (nonatomic, weak) IBOutlet UIButton *twentyButton;
@property (nonatomic) BOOL twenty;
@property (nonatomic, weak) IBOutlet UIButton *twentyOneButton;
@property (nonatomic) BOOL twentyOne;
@property (nonatomic, weak) IBOutlet UIButton *twentyTwoButton;
@property (nonatomic) BOOL twentyTwo;
@property (nonatomic, weak) IBOutlet UIButton *twentyThreeButton;
@property (nonatomic) BOOL twentyThree;
@property (nonatomic, weak) IBOutlet UIButton *twentyFourButton;
@property (nonatomic) BOOL twentyFour;
@property (nonatomic, weak) IBOutlet UIButton *twentyFiveButton;
@property (nonatomic) BOOL twentyFive;
@property (nonatomic, weak) IBOutlet UIButton *twentySixButton;
@property (nonatomic) BOOL twentySix;
@property (nonatomic, weak) IBOutlet UIButton *twentySevenButton;
@property (nonatomic) BOOL twentySeven;
@property (nonatomic, weak) IBOutlet UIButton *twentyEightButton;
@property (nonatomic) BOOL twentyEight;
@property (nonatomic, weak) IBOutlet UIButton *twentyNineButton;
@property (nonatomic) BOOL twentyNine;
@property (nonatomic, weak) IBOutlet UIButton *thirtyButton;
@property (nonatomic) BOOL thirty;
@property (nonatomic, weak) IBOutlet UIButton *thirtyOneButton;
@property (nonatomic) BOOL thirtyOne;





@property (nonatomic, weak) IBOutlet UIPickerView *dayPicker;

@property (nonatomic, strong) NSArray *weekButtons;
@property (nonatomic, strong) NSArray *monthButtons;
@property (nonatomic, strong) NSArray *colorButtons;
@property (nonatomic, strong) NSArray *besidesWeekButtons;
@property (nonatomic, strong) NSMutableArray *repeatStrings;

@end

@implementation ZSWRepeatSelectorViewController

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
    self.weekButtons = @[self.sundayButton, self.mondayButton, self.tuesdayButton, self.wednesdayButton, self.thursdayButton, self.fridayButton, self.saturdayButton];
    
    self.colorButtons = @[self.repeatDailyButton, self.repeatWeeklyButton, self.repeatMonthlyButton, self.sundayButton, self.mondayButton, self.tuesdayButton, self.wednesdayButton, self.thursdayButton, self.fridayButton, self.saturdayButton];
    
    self.besidesWeekButtons = @[self.repeatDailyButton, self.repeatMonthlyButton];
    
    self.monthButtons = @[self.oneButton, self.twoButton , self.threeButton, self.fourButton, self.fiveButton, self.sixButton, self.sevenButton, self.eightButton, self.nineButton, self.tenButton, self.elevenButton, self.twelveButton, self.thirteenButton, self.fourteenButton, self.fifteenButton, self.sixteenButton, self.seventeenButton, self.eighteenButton, self.nineteenButton, self.twentyButton, self.twentyOneButton, self.twentyTwoButton, self.twentyThreeButton, self.twentyFourButton, self.twentyFiveButton, self.twentySixButton, self.twentySevenButton, self.twentyEightButton, self.twentyNineButton, self.thirtyButton, self.thirtyOneButton];
    
    //week repeat bools
    self.repeatDaily = NO;
    self.repeatWeekly = NO;
    self.repeatMonthly = NO;
    self.sunday = NO;
    self.monday = NO;
    self.tuesday = NO;
    self.wednesday = NO;
    self.thursday = NO;
    self.friday = NO;
    self.saturday = NO;
    
    //month repeat bools
    self.one = NO;
    self.two = NO;
    self.three = NO;
    self.four = NO;
    self.five = NO;
    self.six = NO;
    self.seven = NO;
    self.eight = NO;
    self.nine = NO;
    self.ten = NO;
    self.eleven = NO;
    self.twelve = NO;
    self.thirteen = NO;
    self.fourteen = NO;
    self.fifteen = NO;
    self.sixteen = NO;
    self.seventeen = NO;
    self.eighteen = NO;
    self.nineteen = NO;
    self.twenty = NO;
    self.twentyOne = NO;
    self.twentyTwo = NO;
    self.twentyThree = NO;
    self.twentyFour = NO;
    self.twentyFive = NO;
    self.twentySix = NO;
    self.twentySeven = NO;
    self.twentyEight = NO;
    self.twentyNine = NO;
    self.thirty = NO;
    self.thirtyOne = NO;
    
    
    //navBar
    self.navigationItem.title = @"Set to Repeat";
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                         target:self
                                                                         action:@selector(saveRepeat)];
    self.navigationItem.rightBarButtonItem = bbi;
    
    //font
    UIFont *font = [UIFont fontWithName:@"Avenir" size:17];
    //color
    NSDictionary *colors = [[ZSWTaskStore sharedStore] colors];
    UIColor *color = [colors valueForKey:@"productiveGreen"];
    self.color = color;
    //setToRepeatLabel
    self.setToRepeatLabel.font = font;
    self.setToRepeatLabel.numberOfLines = 0;
    
    //repeatDailyButton
    [self.repeatDailyButton setTitleColor:color forState:UIControlStateNormal];
    self.repeatDailyButton.titleLabel.font = font;
    [[self.repeatDailyButton layer] setBorderColor:color.CGColor];
    [[self.repeatDailyButton layer] setBorderWidth:1.0];
    [[self.repeatDailyButton layer] setCornerRadius:7.0];
    
    //repeatWeeklyButton
    [self.repeatWeeklyButton setTitleColor:color forState:UIControlStateNormal];
    self.repeatWeeklyButton.titleLabel.font = font;
    [[self.repeatWeeklyButton layer] setBorderColor:color.CGColor];
    [[self.repeatWeeklyButton layer] setBorderWidth:1.0];
    [[self.repeatWeeklyButton layer] setCornerRadius:7.0];
    
    //weekButtons
    for (UIButton *button in self.weekButtons) {
        [button setTitleColor:color forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:@"Avenir" size:16.0];
        [[button layer] setBorderColor:color.CGColor];
        [[button layer] setBorderWidth:1.0];
        [[button layer] setCornerRadius:4.0];
    }
    
    //repeatMonthly
    [self.repeatMonthlyButton setTitleColor:color forState:UIControlStateNormal];
    self.repeatMonthlyButton.titleLabel.font = font;
    [[self.repeatMonthlyButton layer] setBorderColor:color.CGColor];
    [[self.repeatMonthlyButton layer] setBorderWidth:1.0];
    [[self.repeatMonthlyButton layer] setCornerRadius:7.0];
    
    for (UIButton *button in self.monthButtons) {
        [button setTitleColor:color forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:@"Avenir" size:16.0];
        [[button layer] setBorderColor:color.CGColor];
        [[button layer] setBorderWidth:1.0];
        [[button layer] setCornerRadius:4.0];
    }
    
    self.dayPicker.delegate = self;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSDictionary *setToRepeatDictionary = self.task.setToRepeatDictionary;
    
    //configure screen to match dictionary;
    self.repeatDaily = [[setToRepeatDictionary valueForKey:@"repeatDaily"] boolValue];
    NSLog(@"self.repeatDaily: %hhd", self.repeatDaily);
    self.repeatWeekly = [[setToRepeatDictionary valueForKey:@"repeatWeekly"] boolValue];
    NSLog(@"self.repeatWeekly: %hhd", self.repeatWeekly);
    self.repeatMonthly = [[setToRepeatDictionary valueForKey:@"repeatMonthly"] boolValue];
    NSArray *weekDaysToRepeat = [setToRepeatDictionary valueForKey:@"weekDaysToRepeat"];
    NSArray *monthDaysToRepeat = [setToRepeatDictionary valueForKey:@"monthDaysToRepeat"];
    NSLog(@"weekDaysToRepeatFromDictionary: %@", weekDaysToRepeat);
    
    //fix bools
    [self fixBools];

    //repeatDaily
    if (self.repeatDaily) {
        [self.repeatDailyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.repeatDailyButton.backgroundColor = self.color;
    }
    
    if (self.repeatWeekly) {
        [self.repeatWeeklyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.repeatWeeklyButton.backgroundColor = self.color;
        NSLog(@"got this far");
        //set the week buttons
        UIButton *button;
        for (NSNumber *number in weekDaysToRepeat) {
            button = self.weekButtons[number.intValue];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.backgroundColor = self.color;
        }
    }
    
    if (self.repeatMonthly) {
        [self.repeatMonthlyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.repeatMonthlyButton.backgroundColor = self.color;
        NSLog(@"got this far");
        //set the week buttons
        UIButton *button;
        for (NSNumber *number in monthDaysToRepeat) {
            button = self.monthButtons[number.intValue];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.backgroundColor = self.color;
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSLog(@"self.task: %@", self.task);
    [[ZSWTaskStore sharedStore] syncRepeatsWithTask:self.task];
    
}

- (void)fixBools
{
    //check the dictionary
    NSDictionary *setToRepeatDictionary = self.task.setToRepeatDictionary;
    NSArray *weekDaysToRepeat = [setToRepeatDictionary valueForKey:@"weekDaysToRepeat"];
    //loop through the week days
    for (NSNumber *number in weekDaysToRepeat) {
        if (number.intValue == 0){
            self.sunday = YES;
        } else if (number.intValue == 1) {
            self.monday = YES;
        } else if (number.intValue == 2) {
            self.tuesday = YES;
        } else if (number.intValue == 3) {
            self.wednesday = YES;
        } else if (number.intValue == 4) {
            self.thursday = YES;
        } else if (number.intValue  == 5) {
            self.friday = YES;
        } else if (number.intValue == 6) {
            self.saturday = YES;
        }
    }
    
    NSArray *monthDaysToRepeat = [setToRepeatDictionary valueForKey:@"monthDaysToRepeat"];
    for (NSNumber *number in monthDaysToRepeat) {
        if (number.intValue == 0){
            self.one = YES;
        } else if (number.intValue == 1) {
            self.two = YES;
        } else if (number.intValue == 2) {
            self.three = YES;
        } else if (number.intValue == 3) {
            self.four = YES;
        } else if (number.intValue == 4) {
            self.five = YES;
        } else if (number.intValue == 5) {
            self.six = YES;
        } else if (number.intValue == 6) {
            self.seven = YES;
        } else if (number.intValue == 7) {
            self.eight = YES;
        } else if (number.intValue == 8) {
            self.nine = YES;
        } else if (number.intValue == 9) {
            self.ten = YES;
        } else if (number.intValue == 10) {
            self.eleven = YES;
        } else if (number.intValue == 11) {
            self.twelve = YES;
        } else if (number.intValue == 12) {
            self.thirteen = YES;
        } else if (number.intValue == 13) {
            self.fourteen = YES;
        } else if (number.intValue == 14) {
            self.fifteen = YES;
        } else if (number.intValue == 15) {
            self.sixteen = YES;
        } else if (number.intValue == 16) {
            self.seventeen = YES;
        } else if (number.intValue == 17) {
            self.eighteen = YES;
        } else if (number.intValue == 18) {
            self.nineteen = YES;
        } else if (number.intValue == 19) {
            self.twenty = YES;
        } else if (number.intValue == 20) {
            self.twentyOne = YES;
        } else if (number.intValue == 21) {
            self.twentyTwo = YES;
        } else if (number.intValue == 22) {
            self.twentyThree = YES;
        } else if (number.intValue == 23) {
            self.twentyFour = YES;
        } else if (number.intValue == 24) {
            self.twentyFive = YES;
        } else if (number.intValue == 25) {
            self.twentySix = YES;
        } else if (number.intValue == 26) {
            self.twentySeven = YES;
        } else if (number.intValue == 27) {
            self.twentyEight = YES;
        } else if (number.intValue == 28) {
            self.twentyNine = YES;
        } else if (number.intValue == 29) {
            self.thirty = YES;
        } else if (number.intValue == 30) {
            self.thirtyOne = YES;
        }
    }
}

- (void)saveRepeat
{
    NSNumber *repeatDaily = [NSNumber numberWithBool:self.repeatDaily];
    NSLog(@"repeatDaily: %@", repeatDaily);
    NSNumber *repeatWeekly = [NSNumber numberWithBool:self.repeatWeekly];
    NSLog(@"repeatWeekly: %@", repeatWeekly);
    NSNumber *repeatMonthly = [NSNumber numberWithBool:self.repeatMonthly];
    NSLog(@"repeatMonthly: %@", repeatMonthly);
    
    NSArray *weekDaysToRepeat = [self findWeekDaysToRepeat];
    NSLog(@"weekDaysToRepeat: %@", weekDaysToRepeat);
    NSArray *monthDaysToRepeat = [self findMonthDaysToRepeat];
    NSLog(@"monthDaysToRepeat: %@", monthDaysToRepeat);
    
    NSDictionary *setToRepeatDictionary = @{@"repeatDaily" : repeatDaily,
                                            @"repeatWeekly" : repeatWeekly,
                                            @"repeatMonthly" : repeatMonthly,
                                            @"weekDaysToRepeat" : weekDaysToRepeat,
                                            @"monthDaysToRepeat" : monthDaysToRepeat};
    self.task.setToRepeatDictionary = setToRepeatDictionary;
    [[ZSWTaskStore sharedStore] saveChanges];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PickerView
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 50.0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30.0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *string = [NSString stringWithFormat:@"%d", (int)row + 1];
    return string;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 30;
}

#pragma mark - Interaction

- (IBAction)repeatDaily:(id)sender
{
    //clear all other buttons
    for (UIButton *button in self.colorButtons) {
        [button setTitleColor:self.color forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
    }
    //clear all month buttons
    for (UIButton *button in self.monthButtons) {
        [button setTitleColor:self.color forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
    }
    
    if (self.repeatDaily) {
        self.repeatDaily = NO;
        [self.repeatDailyButton setTitleColor:self.color forState:UIControlStateNormal];
        self.repeatDailyButton.backgroundColor = [UIColor whiteColor];

    } else {
        self.repeatDaily = YES;
        [self.repeatDailyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.repeatDailyButton.backgroundColor = self.color;

    }
    //weekDays
    //skip
    self.repeatWeekly = NO;
    self.repeatMonthly = NO;
    self.sunday = NO;
    self.monday = NO;
    self.tuesday = NO;
    self.wednesday = NO;
    self.thursday = NO;
    self.friday = NO;
    self.saturday = NO;
    
    //monthDays
    self.one = NO;
    self.two = NO;
    self.three = NO;
    self.four = NO;
    self.five = NO;
    self.six = NO;
    self.seven = NO;
    self.eight = NO;
    self.nine = NO;
    self.ten = NO;
    self.eleven = NO;
    self.twelve = NO;
    self.thirteen = NO;
    self.fourteen = NO;
    self.fifteen = NO;
    self.sixteen = NO;
    self.seventeen = NO;
    self.eighteen = NO;
    self.nineteen = NO;
    self.twenty = NO;
    self.twentyOne = NO;
    self.twentyTwo = NO;
    self.twentyThree = NO;
    self.twentyFour = NO;
    self.twentyFive = NO;
    self.twentySix = NO;
    self.twentySeven = NO;
    self.twentyEight = NO;
    self.twentyNine = NO;
    self.thirty = NO;
    self.thirtyOne = NO;
}

- (IBAction)repeatWeekly:(id)sender
{
    //clear all other buttons
    for (UIButton *button in self.colorButtons) {
        [button setTitleColor:self.color forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
    }
    //clear all month buttons
    for (UIButton *button in self.monthButtons) {
        [button setTitleColor:self.color forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
    }
    
    if (self.repeatWeekly) {
        self.repeatWeekly = NO;
        [self.repeatWeeklyButton setTitleColor:self.color forState:UIControlStateNormal];
        self.repeatWeeklyButton.backgroundColor = [UIColor whiteColor];

    } else {
        self.repeatWeekly = YES;
        [self.repeatWeeklyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.repeatWeeklyButton.backgroundColor = self.color;

    }
    //weekDays
    self.repeatDaily = NO;
    //skip
    self.repeatMonthly = NO;
    self.sunday = NO;
    self.monday = NO;
    self.tuesday = NO;
    self.wednesday = NO;
    self.thursday = NO;
    self.friday = NO;
    self.saturday = NO;
    
    //monthDays
    self.one = NO;
    self.two = NO;
    self.three = NO;
    self.four = NO;
    self.five = NO;
    self.six = NO;
    self.seven = NO;
    self.eight = NO;
    self.nine = NO;
    self.ten = NO;
    self.eleven = NO;
    self.twelve = NO;
    self.thirteen = NO;
    self.fourteen = NO;
    self.fifteen = NO;
    self.sixteen = NO;
    self.seventeen = NO;
    self.eighteen = NO;
    self.nineteen = NO;
    self.twenty = NO;
    self.twentyOne = NO;
    self.twentyTwo = NO;
    self.twentyThree = NO;
    self.twentyFour = NO;
    self.twentyFive = NO;
    self.twentySix = NO;
    self.twentySeven = NO;
    self.twentyEight = NO;
    self.twentyNine = NO;
    self.thirty = NO;
    self.thirtyOne = NO;
    
    
}

- (IBAction)repeatMonthly:(id)sender
{
    //Make all other buttons clear
    for (UIButton *button in self.colorButtons) {
        [button setTitleColor:self.color forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
    }
    //make all day buttons clear
    for (UIButton *button in self.monthButtons) {
        [button setTitleColor:self.color forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
    }
    
    if (self.repeatMonthly) {
        self.repeatMonthly = NO;
        [self.repeatMonthlyButton setTitleColor:self.color forState:UIControlStateNormal];
        self.repeatMonthlyButton.backgroundColor = [UIColor whiteColor];

    } else {
        self.repeatMonthly = YES;
        [self.repeatMonthlyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.repeatMonthlyButton.backgroundColor = self.color;

    }
    
    self.repeatDaily = NO;
    self.repeatWeekly = NO;
    //skip
    self.sunday = NO;
    self.monday = NO;
    self.tuesday = NO;
    self.wednesday = NO;
    self.thursday = NO;
    self.friday = NO;
    self.saturday = NO;
    
    //monthDays
    self.one = NO;
    self.two = NO;
    self.three = NO;
    self.four = NO;
    self.five = NO;
    self.six = NO;
    self.seven = NO;
    self.eight = NO;
    self.nine = NO;
    self.ten = NO;
    self.eleven = NO;
    self.twelve = NO;
    self.thirteen = NO;
    self.fourteen = NO;
    self.fifteen = NO;
    self.sixteen = NO;
    self.seventeen = NO;
    self.eighteen = NO;
    self.nineteen = NO;
    self.twenty = NO;
    self.twentyOne = NO;
    self.twentyTwo = NO;
    self.twentyThree = NO;
    self.twentyFour = NO;
    self.twentyFive = NO;
    self.twentySix = NO;
    self.twentySeven = NO;
    self.twentyEight = NO;
    self.twentyNine = NO;
    self.thirty = NO;
    self.thirtyOne = NO;
    
}

#pragma mark - Days of the Week Actions
- (IBAction)sunday:(id)sender
{
    //clear daily and week buttons
    for (UIButton *button in self.besidesWeekButtons) {
        [button setTitleColor:self.color forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
    }
    
    //make all day buttons clear
    for (UIButton *button in self.monthButtons) {
        [button setTitleColor:self.color forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
    }
    //monthDays
    self.one = NO;
    self.two = NO;
    self.three = NO;
    self.four = NO;
    self.five = NO;
    self.six = NO;
    self.seven = NO;
    self.eight = NO;
    self.nine = NO;
    self.ten = NO;
    self.eleven = NO;
    self.twelve = NO;
    self.thirteen = NO;
    self.fourteen = NO;
    self.fifteen = NO;
    self.sixteen = NO;
    self.seventeen = NO;
    self.eighteen = NO;
    self.nineteen = NO;
    self.twenty = NO;
    self.twentyOne = NO;
    self.twentyTwo = NO;
    self.twentyThree = NO;
    self.twentyFour = NO;
    self.twentyFive = NO;
    self.twentySix = NO;
    self.twentySeven = NO;
    self.twentyEight = NO;
    self.twentyNine = NO;
    self.thirty = NO;
    self.thirtyOne = NO;
    
    self.repeatDaily = NO;
    self.repeatMonthly = NO;

    //repeatWeeklyButton
    self.repeatWeekly = YES;
    [self.repeatWeeklyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.repeatWeeklyButton.backgroundColor = self.color;
    
    if (self.sunday) {
        self.sunday = NO;
        [self.sundayButton setTitleColor:self.color forState:UIControlStateNormal];
        self.sundayButton.backgroundColor = [UIColor whiteColor];
    } else {
        self.sunday = YES;
        [self.sundayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.sundayButton.backgroundColor = self.color;
    }
    
}

- (IBAction)monday:(id)sender
{
    //clear daily and week buttons
    for (UIButton *button in self.besidesWeekButtons) {
        [button setTitleColor:self.color forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
    }
    
    //make all day buttons clear
    for (UIButton *button in self.monthButtons) {
        [button setTitleColor:self.color forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
    }
    //monthDays
    self.one = NO;
    self.two = NO;
    self.three = NO;
    self.four = NO;
    self.five = NO;
    self.six = NO;
    self.seven = NO;
    self.eight = NO;
    self.nine = NO;
    self.ten = NO;
    self.eleven = NO;
    self.twelve = NO;
    self.thirteen = NO;
    self.fourteen = NO;
    self.fifteen = NO;
    self.sixteen = NO;
    self.seventeen = NO;
    self.eighteen = NO;
    self.nineteen = NO;
    self.twenty = NO;
    self.twentyOne = NO;
    self.twentyTwo = NO;
    self.twentyThree = NO;
    self.twentyFour = NO;
    self.twentyFive = NO;
    self.twentySix = NO;
    self.twentySeven = NO;
    self.twentyEight = NO;
    self.twentyNine = NO;
    self.thirty = NO;
    self.thirtyOne = NO;
    
    self.repeatDaily = NO;
    self.repeatMonthly = NO;
    
    //repeatWeeklyButton
    self.repeatWeekly = YES;
    [self.repeatWeeklyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.repeatWeeklyButton.backgroundColor = self.color;
    
    if (self.monday) {
        self.monday = NO;
        [self.mondayButton setTitleColor:self.color forState:UIControlStateNormal];
        self.mondayButton.backgroundColor = [UIColor whiteColor];
    } else {
        self.monday = YES;
        [self.mondayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.mondayButton.backgroundColor = self.color;
    }
}

- (IBAction)tuesday:(id)sender
{
    //clear daily and week buttons
    for (UIButton *button in self.besidesWeekButtons) {
        [button setTitleColor:self.color forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
    }
    
    //make all day buttons clear
    for (UIButton *button in self.monthButtons) {
        [button setTitleColor:self.color forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
    }
    //monthDays
    self.one = NO;
    self.two = NO;
    self.three = NO;
    self.four = NO;
    self.five = NO;
    self.six = NO;
    self.seven = NO;
    self.eight = NO;
    self.nine = NO;
    self.ten = NO;
    self.eleven = NO;
    self.twelve = NO;
    self.thirteen = NO;
    self.fourteen = NO;
    self.fifteen = NO;
    self.sixteen = NO;
    self.seventeen = NO;
    self.eighteen = NO;
    self.nineteen = NO;
    self.twenty = NO;
    self.twentyOne = NO;
    self.twentyTwo = NO;
    self.twentyThree = NO;
    self.twentyFour = NO;
    self.twentyFive = NO;
    self.twentySix = NO;
    self.twentySeven = NO;
    self.twentyEight = NO;
    self.twentyNine = NO;
    self.thirty = NO;
    self.thirtyOne = NO;
    self.repeatDaily = NO;
    self.repeatMonthly = NO;
    
    //repeatWeeklyButton
    self.repeatWeekly = YES;
    [self.repeatWeeklyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.repeatWeeklyButton.backgroundColor = self.color;
    
    if (self.tuesday) {
        self.tuesday = NO;
        [self.tuesdayButton setTitleColor:self.color forState:UIControlStateNormal];
        self.tuesdayButton.backgroundColor = [UIColor whiteColor];
    } else {
        self.tuesday = YES;
        [self.tuesdayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.tuesdayButton.backgroundColor = self.color;
    }
}

- (IBAction)wednesday:(id)sender
{
    //clear daily and week buttons
    for (UIButton *button in self.besidesWeekButtons) {
        [button setTitleColor:self.color forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
    }
    
    //make all day buttons clear
    for (UIButton *button in self.monthButtons) {
        [button setTitleColor:self.color forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
    }
    //monthDays
    self.one = NO;
    self.two = NO;
    self.three = NO;
    self.four = NO;
    self.five = NO;
    self.six = NO;
    self.seven = NO;
    self.eight = NO;
    self.nine = NO;
    self.ten = NO;
    self.eleven = NO;
    self.twelve = NO;
    self.thirteen = NO;
    self.fourteen = NO;
    self.fifteen = NO;
    self.sixteen = NO;
    self.seventeen = NO;
    self.eighteen = NO;
    self.nineteen = NO;
    self.twenty = NO;
    self.twentyOne = NO;
    self.twentyTwo = NO;
    self.twentyThree = NO;
    self.twentyFour = NO;
    self.twentyFive = NO;
    self.twentySix = NO;
    self.twentySeven = NO;
    self.twentyEight = NO;
    self.twentyNine = NO;
    self.thirty = NO;
    self.thirtyOne = NO;
    self.repeatDaily = NO;
    self.repeatMonthly = NO;
    
    //repeatWeeklyButton
    self.repeatWeekly = YES;
    [self.repeatWeeklyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.repeatWeeklyButton.backgroundColor = self.color;
    
    if (self.wednesday) {
        self.wednesday = NO;
        [self.wednesdayButton setTitleColor:self.color forState:UIControlStateNormal];
        self.wednesdayButton.backgroundColor = [UIColor whiteColor];
    } else {
        self.wednesday = YES;
        [self.wednesdayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.wednesdayButton.backgroundColor = self.color;
    }
}

- (IBAction)thursday:(id)sender
{
    //clear daily and week buttons
    for (UIButton *button in self.besidesWeekButtons) {
        [button setTitleColor:self.color forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
    }
    
    //make all day buttons clear
    for (UIButton *button in self.monthButtons) {
        [button setTitleColor:self.color forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
    }
    //monthDays
    self.one = NO;
    self.two = NO;
    self.three = NO;
    self.four = NO;
    self.five = NO;
    self.six = NO;
    self.seven = NO;
    self.eight = NO;
    self.nine = NO;
    self.ten = NO;
    self.eleven = NO;
    self.twelve = NO;
    self.thirteen = NO;
    self.fourteen = NO;
    self.fifteen = NO;
    self.sixteen = NO;
    self.seventeen = NO;
    self.eighteen = NO;
    self.nineteen = NO;
    self.twenty = NO;
    self.twentyOne = NO;
    self.twentyTwo = NO;
    self.twentyThree = NO;
    self.twentyFour = NO;
    self.twentyFive = NO;
    self.twentySix = NO;
    self.twentySeven = NO;
    self.twentyEight = NO;
    self.twentyNine = NO;
    self.thirty = NO;
    self.thirtyOne = NO;
    self.repeatDaily = NO;
    self.repeatMonthly = NO;
    
    //repeatWeeklyButton
    self.repeatWeekly = YES;
    [self.repeatWeeklyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.repeatWeeklyButton.backgroundColor = self.color;
    
    if (self.thursday) {
        self.thursday = NO;
        [self.thursdayButton setTitleColor:self.color forState:UIControlStateNormal];
        self.thursdayButton.backgroundColor = [UIColor whiteColor];
    } else {
        self.thursday = YES;
        [self.thursdayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.thursdayButton.backgroundColor = self.color;
    }
}

- (IBAction)friday:(id)sender
{
    //clear daily and week buttons
    for (UIButton *button in self.besidesWeekButtons) {
        [button setTitleColor:self.color forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
    }
    
    //make all day buttons clear
    for (UIButton *button in self.monthButtons) {
        [button setTitleColor:self.color forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
    }
    //monthDays
    self.one = NO;
    self.two = NO;
    self.three = NO;
    self.four = NO;
    self.five = NO;
    self.six = NO;
    self.seven = NO;
    self.eight = NO;
    self.nine = NO;
    self.ten = NO;
    self.eleven = NO;
    self.twelve = NO;
    self.thirteen = NO;
    self.fourteen = NO;
    self.fifteen = NO;
    self.sixteen = NO;
    self.seventeen = NO;
    self.eighteen = NO;
    self.nineteen = NO;
    self.twenty = NO;
    self.twentyOne = NO;
    self.twentyTwo = NO;
    self.twentyThree = NO;
    self.twentyFour = NO;
    self.twentyFive = NO;
    self.twentySix = NO;
    self.twentySeven = NO;
    self.twentyEight = NO;
    self.twentyNine = NO;
    self.thirty = NO;
    self.thirtyOne = NO;
    self.repeatDaily = NO;
    self.repeatMonthly = NO;
    
    //repeatWeeklyButton
    self.repeatWeekly = YES;
    [self.repeatWeeklyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.repeatWeeklyButton.backgroundColor = self.color;
    
    if (self.friday) {
        self.friday = NO;
        [self.fridayButton setTitleColor:self.color forState:UIControlStateNormal];
        self.fridayButton.backgroundColor = [UIColor whiteColor];
    } else {
        self.friday = YES;
        [self.fridayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.fridayButton.backgroundColor = self.color;
    }
}

- (IBAction)saturday:(id)sender
{
    //clear daily and week buttons
    for (UIButton *button in self.besidesWeekButtons) {
        [button setTitleColor:self.color forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
    }
    
    //make all day buttons clear
    for (UIButton *button in self.monthButtons) {
        [button setTitleColor:self.color forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
    }
    //monthDays
    self.one = NO;
    self.two = NO;
    self.three = NO;
    self.four = NO;
    self.five = NO;
    self.six = NO;
    self.seven = NO;
    self.eight = NO;
    self.nine = NO;
    self.ten = NO;
    self.eleven = NO;
    self.twelve = NO;
    self.thirteen = NO;
    self.fourteen = NO;
    self.fifteen = NO;
    self.sixteen = NO;
    self.seventeen = NO;
    self.eighteen = NO;
    self.nineteen = NO;
    self.twenty = NO;
    self.twentyOne = NO;
    self.twentyTwo = NO;
    self.twentyThree = NO;
    self.twentyFour = NO;
    self.twentyFive = NO;
    self.twentySix = NO;
    self.twentySeven = NO;
    self.twentyEight = NO;
    self.twentyNine = NO;
    self.thirty = NO;
    self.thirtyOne = NO;
    
    self.repeatDaily = NO;
    self.repeatMonthly = NO;
    
    //repeatWeeklyButton
    self.repeatWeekly = YES;
    [self.repeatWeeklyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.repeatWeeklyButton.backgroundColor = self.color;
    
    if (self.saturday) {
        self.saturday = NO;
        [self.saturdayButton setTitleColor:self.color forState:UIControlStateNormal];
        self.saturdayButton.backgroundColor = [UIColor whiteColor];
    } else {
        self.saturday = YES;
        [self.saturdayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.saturdayButton.backgroundColor = self.color;
    }
}

#pragma mark - Days of the Month
- (IBAction)one:(id)sender
{
    for (UIButton *button in self.colorButtons) {
        [button setTitleColor:self.color forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
    }
    self.repeatDaily = NO;
    self.repeatWeekly = NO;
    
    self.sunday = NO;
    self.monday = NO;
    self.tuesday = NO;
    self.wednesday = NO;
    self.thursday = NO;
    self.friday = NO;
    self.saturday = NO;
    
    //repeatMonthlyButton
    self.repeatMonthly = YES;
    [self.repeatMonthlyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.repeatMonthlyButton.backgroundColor = self.color;
    
    if (self.one) {
        self.one = NO;
        [self.oneButton setTitleColor:self.color forState:UIControlStateNormal];
        self.oneButton.backgroundColor = [UIColor whiteColor];
        

    } else {
        self.one = YES;
        [self.oneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.oneButton.backgroundColor = self.color;
        

    }

}

- (IBAction)two:(id)sender
{
    for (UIButton *button in self.colorButtons) {
        [button setTitleColor:self.color forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
    }
    self.repeatDaily = NO;
    self.repeatWeekly = NO;
    
    self.sunday = NO;
    self.monday = NO;
    self.tuesday = NO;
    self.wednesday = NO;
    self.thursday = NO;
    self.friday = NO;
    self.saturday = NO;
    
    //repeatMonthlyButton
    self.repeatMonthly = YES;
    [self.repeatMonthlyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.repeatMonthlyButton.backgroundColor = self.color;
    
    if (self.two) {
        self.two = NO;
        [self.twoButton setTitleColor:self.color forState:UIControlStateNormal];
        self.twoButton.backgroundColor = [UIColor whiteColor];
    } else {
        self.two = YES;
        [self.twoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.twoButton.backgroundColor = self.color;
        
    }
}

- (IBAction)three:(id)sender
{
    for (UIButton *button in self.colorButtons) {
        [button setTitleColor:self.color forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
    }
    self.repeatDaily = NO;
    self.repeatWeekly = NO;
    
    self.sunday = NO;
    self.monday = NO;
    self.tuesday = NO;
    self.wednesday = NO;
    self.thursday = NO;
    self.friday = NO;
    self.saturday = NO;
    
    //repeatMonthlyButton
    self.repeatMonthly = YES;
    [self.repeatMonthlyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.repeatMonthlyButton.backgroundColor = self.color;
    
    if (self.three) {
        self.three = NO;
        [self.threeButton setTitleColor:self.color forState:UIControlStateNormal];
        self.threeButton.backgroundColor = [UIColor whiteColor];
    } else {
        self.three = YES;
        [self.threeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.threeButton.backgroundColor = self.color;
    }
}

- (IBAction)four:(id)sender
{
    for (UIButton *button in self.colorButtons) {
        [button setTitleColor:self.color forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
    }
    self.repeatDaily = NO;
    self.repeatWeekly = NO;
    
    self.sunday = NO;
    self.monday = NO;
    self.tuesday = NO;
    self.wednesday = NO;
    self.thursday = NO;
    self.friday = NO;
    self.saturday = NO;
    
    //repeatMonthlyButton
    self.repeatMonthly = YES;
    [self.repeatMonthlyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.repeatMonthlyButton.backgroundColor = self.color;
    
    if (self.four) {
        self.four = NO;
        [self.fourButton setTitleColor:self.color forState:UIControlStateNormal];
        self.fourButton.backgroundColor = [UIColor whiteColor];
    } else {
        self.four = YES;
        [self.fourButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.fourButton.backgroundColor = self.color;
    }
}

- (IBAction)five:(id)sender
{
    for (UIButton *button in self.colorButtons) {
        [button setTitleColor:self.color forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
    }
    self.repeatDaily = NO;
    self.repeatWeekly = NO;
    
    self.sunday = NO;
    self.monday = NO;
    self.tuesday = NO;
    self.wednesday = NO;
    self.thursday = NO;
    self.friday = NO;
    self.saturday = NO;
    
    //repeatMonthlyButton
    self.repeatMonthly = YES;
    [self.repeatMonthlyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.repeatMonthlyButton.backgroundColor = self.color;
    
    if (self.five) {
        self.five = NO;
        [self.fiveButton setTitleColor:self.color forState:UIControlStateNormal];
        self.fiveButton.backgroundColor = [UIColor whiteColor];
    } else {
        self.five = YES;
        [self.fiveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.fiveButton.backgroundColor = self.color;
    }
}

- (IBAction)six:(id)sender
{
    for (UIButton *button in self.colorButtons) {
        [button setTitleColor:self.color forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
    }
    self.repeatDaily = NO;
    self.repeatWeekly = NO;
    
    self.sunday = NO;
    self.monday = NO;
    self.tuesday = NO;
    self.wednesday = NO;
    self.thursday = NO;
    self.friday = NO;
    self.saturday = NO;
    
    //repeatMonthlyButton
    self.repeatMonthly = YES;
    [self.repeatMonthlyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.repeatMonthlyButton.backgroundColor = self.color;
    
    if (self.six) {
        self.six = NO;
        [self.sixButton setTitleColor:self.color forState:UIControlStateNormal];
        self.sixButton.backgroundColor = [UIColor whiteColor];
    } else {
        self.six = YES;
        [self.sixButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.sixButton.backgroundColor = self.color;
    }
}

- (IBAction)seven:(id)sender
{
    for (UIButton *button in self.colorButtons) {
        [button setTitleColor:self.color forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
    }
    self.repeatDaily = NO;
    self.repeatWeekly = NO;
    
    self.sunday = NO;
    self.monday = NO;
    self.tuesday = NO;
    self.wednesday = NO;
    self.thursday = NO;
    self.friday = NO;
    self.saturday = NO;
    
    //repeatMonthlyButton
    self.repeatMonthly = YES;
    [self.repeatMonthlyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.repeatMonthlyButton.backgroundColor = self.color;
    
    if (self.seven) {
        self.seven = NO;
        [self.sevenButton setTitleColor:self.color forState:UIControlStateNormal];
        self.sevenButton.backgroundColor = [UIColor whiteColor];
    } else {
        self.seven = YES;
        [self.sevenButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.sevenButton.backgroundColor = self.color;
    }
}

- (IBAction)eight:(id)sender
{
    for (UIButton *button in self.colorButtons) {
        [button setTitleColor:self.color forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
    }
    self.repeatDaily = NO;
    self.repeatWeekly = NO;
    
    self.sunday = NO;
    self.monday = NO;
    self.tuesday = NO;
    self.wednesday = NO;
    self.thursday = NO;
    self.friday = NO;
    self.saturday = NO;
    
    //repeatMonthlyButton
    self.repeatMonthly = YES;
    [self.repeatMonthlyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.repeatMonthlyButton.backgroundColor = self.color;
    
    if (self.eight) {
        self.eight = NO;
        [self.eightButton setTitleColor:self.color forState:UIControlStateNormal];
        self.eightButton.backgroundColor = [UIColor whiteColor];
    } else {
        self.eight = YES;
        [self.eightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.eightButton.backgroundColor = self.color;
    }
}

- (IBAction)nine:(id)sender
{
    for (UIButton *button in self.colorButtons) {
        [button setTitleColor:self.color forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
    }
    self.repeatDaily = NO;
    self.repeatWeekly = NO;
    
    self.sunday = NO;
    self.monday = NO;
    self.tuesday = NO;
    self.wednesday = NO;
    self.thursday = NO;
    self.friday = NO;
    self.saturday = NO;
    
    //repeatMonthlyButton
    self.repeatMonthly = YES;
    [self.repeatMonthlyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.repeatMonthlyButton.backgroundColor = self.color;
    
    if (self.nine) {
        self.nine = NO;
        [self.nineButton setTitleColor:self.color forState:UIControlStateNormal];
        self.nineButton.backgroundColor = [UIColor whiteColor];
    } else {
        self.nine = YES;
        [self.nineButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.nineButton.backgroundColor = self.color;
    }
}

- (IBAction)ten:(id)sender
{
    for (UIButton *button in self.colorButtons) {
        [button setTitleColor:self.color forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
    }
    self.repeatDaily = NO;
    self.repeatWeekly = NO;
    
    self.sunday = NO;
    self.monday = NO;
    self.tuesday = NO;
    self.wednesday = NO;
    self.thursday = NO;
    self.friday = NO;
    self.saturday = NO;
    
    //repeatMonthlyButton
    self.repeatMonthly = YES;
    [self.repeatMonthlyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.repeatMonthlyButton.backgroundColor = self.color;
    
    if (self.ten) {
        self.ten = NO;
        [self.tenButton setTitleColor:self.color forState:UIControlStateNormal];
        self.tenButton.backgroundColor = [UIColor whiteColor];
    } else {
        self.ten = YES;
        [self.tenButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.tenButton.backgroundColor = self.color;
    }
}

- (IBAction)eleven:(id)sender
{
    for (UIButton *button in self.colorButtons) {
        [button setTitleColor:self.color forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
    }
    self.repeatDaily = NO;
    self.repeatWeekly = NO;
    
    self.sunday = NO;
    self.monday = NO;
    self.tuesday = NO;
    self.wednesday = NO;
    self.thursday = NO;
    self.friday = NO;
    self.saturday = NO;
    
    //repeatMonthlyButton
    self.repeatMonthly = YES;
    [self.repeatMonthlyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.repeatMonthlyButton.backgroundColor = self.color;
    
    if (self.eleven) {
        self.eleven = NO;
        [self.elevenButton setTitleColor:self.color forState:UIControlStateNormal];
        self.elevenButton.backgroundColor = [UIColor whiteColor];
    } else {
        self.eleven = YES;
        [self.elevenButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.elevenButton.backgroundColor = self.color;
    }
}

- (IBAction)twelve:(id)sender
{
    for (UIButton *button in self.colorButtons) {
        [button setTitleColor:self.color forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
    }
    self.repeatDaily = NO;
    self.repeatWeekly = NO;
    
    self.sunday = NO;
    self.monday = NO;
    self.tuesday = NO;
    self.wednesday = NO;
    self.thursday = NO;
    self.friday = NO;
    self.saturday = NO;
    
    //repeatMonthlyButton
    self.repeatMonthly = YES;
    [self.repeatMonthlyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.repeatMonthlyButton.backgroundColor = self.color;
    
    if (self.twelve) {
        self.twelve = NO;
        [self.twelveButton setTitleColor:self.color forState:UIControlStateNormal];
        self.twelveButton.backgroundColor = [UIColor whiteColor];
    } else {
        self.twelve = YES;
        [self.twelveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.twelveButton.backgroundColor = self.color;
    }
}

- (IBAction)thirteen:(id)sender
{
    for (UIButton *button in self.colorButtons) {
        [button setTitleColor:self.color forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
    }
    self.repeatDaily = NO;
    self.repeatWeekly = NO;
    
    self.sunday = NO;
    self.monday = NO;
    self.tuesday = NO;
    self.wednesday = NO;
    self.thursday = NO;
    self.friday = NO;
    self.saturday = NO;
    
    //repeatMonthlyButton
    self.repeatMonthly = YES;
    [self.repeatMonthlyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.repeatMonthlyButton.backgroundColor = self.color;
    
    if (self.thirteen) {
        self.thirteen = NO;
        [self.thirteenButton setTitleColor:self.color forState:UIControlStateNormal];
        self.thirteenButton.backgroundColor = [UIColor whiteColor];
    } else {
        self.thirteen = YES;
        [self.thirteenButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.thirteenButton.backgroundColor = self.color;
    }
}

- (IBAction)fourteen:(id)sender
{
    for (UIButton *button in self.colorButtons) {
        [button setTitleColor:self.color forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
    }
    self.repeatDaily = NO;
    self.repeatWeekly = NO;
    
    self.sunday = NO;
    self.monday = NO;
    self.tuesday = NO;
    self.wednesday = NO;
    self.thursday = NO;
    self.friday = NO;
    self.saturday = NO;
    
    //repeatMonthlyButton
    self.repeatMonthly = YES;
    [self.repeatMonthlyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.repeatMonthlyButton.backgroundColor = self.color;
    
    if (self.fourteen) {
        self.fourteen = NO;
        [self.fourteenButton setTitleColor:self.color forState:UIControlStateNormal];
        self.fourteenButton.backgroundColor = [UIColor whiteColor];
    } else {
        self.fourteen = YES;
        [self.fourteenButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.fourteenButton.backgroundColor = self.color;
    }
}

- (IBAction)fifteen:(id)sender
{
    for (UIButton *button in self.colorButtons) {
        [button setTitleColor:self.color forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
    }
    self.repeatDaily = NO;
    self.repeatWeekly = NO;
    
    self.sunday = NO;
    self.monday = NO;
    self.tuesday = NO;
    self.wednesday = NO;
    self.thursday = NO;
    self.friday = NO;
    self.saturday = NO;
    
    //repeatMonthlyButton
    self.repeatMonthly = YES;
    [self.repeatMonthlyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.repeatMonthlyButton.backgroundColor = self.color;
    
    if (self.fifteen) {
        self.fifteen = NO;
        [self.fifteenButton setTitleColor:self.color forState:UIControlStateNormal];
        self.fifteenButton.backgroundColor = [UIColor whiteColor];
    } else {
        self.fifteen = YES;
        [self.fifteenButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.fifteenButton.backgroundColor = self.color;
    }
}

- (IBAction)sixteen:(id)sender
{
    for (UIButton *button in self.colorButtons) {
        [button setTitleColor:self.color forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
    }
    self.repeatDaily = NO;
    self.repeatWeekly = NO;
    
    self.sunday = NO;
    self.monday = NO;
    self.tuesday = NO;
    self.wednesday = NO;
    self.thursday = NO;
    self.friday = NO;
    self.saturday = NO;
    
    //repeatMonthlyButton
    self.repeatMonthly = YES;
    [self.repeatMonthlyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.repeatMonthlyButton.backgroundColor = self.color;
    
    if (self.sixteen) {
        self.sixteen = NO;
        [self.sixteenButton setTitleColor:self.color forState:UIControlStateNormal];
        self.sixteenButton.backgroundColor = [UIColor whiteColor];
    } else {
        self.sixteen = YES;
        [self.sixteenButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.sixteenButton.backgroundColor = self.color;
    }
}

- (IBAction)seventeen:(id)sender
{
    for (UIButton *button in self.colorButtons) {
        [button setTitleColor:self.color forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
    }
    self.repeatDaily = NO;
    self.repeatWeekly = NO;
    
    self.sunday = NO;
    self.monday = NO;
    self.tuesday = NO;
    self.wednesday = NO;
    self.thursday = NO;
    self.friday = NO;
    self.saturday = NO;
    
    //repeatMonthlyButton
    self.repeatMonthly = YES;
    [self.repeatMonthlyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.repeatMonthlyButton.backgroundColor = self.color;
    
    if (self.seventeen) {
        self.seventeen = NO;
        [self.seventeenButton setTitleColor:self.color forState:UIControlStateNormal];
        self.seventeenButton.backgroundColor = [UIColor whiteColor];
    } else {
        self.seventeen = YES;
        [self.seventeenButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.seventeenButton.backgroundColor = self.color;
    }
}

- (IBAction)eighteen:(id)sender
{
    for (UIButton *button in self.colorButtons) {
        [button setTitleColor:self.color forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
    }
    self.repeatDaily = NO;
    self.repeatWeekly = NO;
    
    self.sunday = NO;
    self.monday = NO;
    self.tuesday = NO;
    self.wednesday = NO;
    self.thursday = NO;
    self.friday = NO;
    self.saturday = NO;
    
    //repeatMonthlyButton
    self.repeatMonthly = YES;
    [self.repeatMonthlyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.repeatMonthlyButton.backgroundColor = self.color;
    
    if (self.eighteen) {
        self.eighteen = NO;
        [self.eighteenButton setTitleColor:self.color forState:UIControlStateNormal];
        self.eighteenButton.backgroundColor = [UIColor whiteColor];
    } else {
        self.eighteen = YES;
        [self.eighteenButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.eighteenButton.backgroundColor = self.color;
    }
}

- (IBAction)nineteen:(id)sender
{
    for (UIButton *button in self.colorButtons) {
        [button setTitleColor:self.color forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
    }
    self.repeatDaily = NO;
    self.repeatWeekly = NO;
    
    self.sunday = NO;
    self.monday = NO;
    self.tuesday = NO;
    self.wednesday = NO;
    self.thursday = NO;
    self.friday = NO;
    self.saturday = NO;
    
    //repeatMonthlyButton
    self.repeatMonthly = YES;
    [self.repeatMonthlyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.repeatMonthlyButton.backgroundColor = self.color;
    
    if (self.nineteen) {
        self.nineteen = NO;
        [self.nineteenButton setTitleColor:self.color forState:UIControlStateNormal];
        self.nineteenButton.backgroundColor = [UIColor whiteColor];
    } else {
        self.nineteen = YES;
        [self.nineteenButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.nineteenButton.backgroundColor = self.color;
    }
}

- (IBAction)twenty:(id)sender
{
    for (UIButton *button in self.colorButtons) {
        [button setTitleColor:self.color forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
    }
    self.repeatDaily = NO;
    self.repeatWeekly = NO;
    
    self.sunday = NO;
    self.monday = NO;
    self.tuesday = NO;
    self.wednesday = NO;
    self.thursday = NO;
    self.friday = NO;
    self.saturday = NO;
    
    //repeatMonthlyButton
    self.repeatMonthly = YES;
    [self.repeatMonthlyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.repeatMonthlyButton.backgroundColor = self.color;
    
    if (self.twenty) {
        self.twenty = NO;
        [self.twentyButton setTitleColor:self.color forState:UIControlStateNormal];
        self.twentyButton.backgroundColor = [UIColor whiteColor];
    } else {
        self.twenty = YES;
        [self.twentyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.twentyButton.backgroundColor = self.color;
    }
}

- (IBAction)twentyOne:(id)sender
{
    for (UIButton *button in self.colorButtons) {
        [button setTitleColor:self.color forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
    }
    self.repeatDaily = NO;
    self.repeatWeekly = NO;
    
    self.sunday = NO;
    self.monday = NO;
    self.tuesday = NO;
    self.wednesday = NO;
    self.thursday = NO;
    self.friday = NO;
    self.saturday = NO;
    
    //repeatMonthlyButton
    self.repeatMonthly = YES;
    [self.repeatMonthlyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.repeatMonthlyButton.backgroundColor = self.color;
    
    if (self.twentyOne) {
        self.twentyOne = NO;
        [self.twentyOneButton setTitleColor:self.color forState:UIControlStateNormal];
        self.twentyOneButton.backgroundColor = [UIColor whiteColor];
    } else {
        self.twentyOne = YES;
        [self.twentyOneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.twentyOneButton.backgroundColor = self.color;
    }
}

- (IBAction)twentyTwo:(id)sender
{
    for (UIButton *button in self.colorButtons) {
        [button setTitleColor:self.color forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
    }
    self.repeatDaily = NO;
    self.repeatWeekly = NO;
    
    self.sunday = NO;
    self.monday = NO;
    self.tuesday = NO;
    self.wednesday = NO;
    self.thursday = NO;
    self.friday = NO;
    self.saturday = NO;
    
    //repeatMonthlyButton
    self.repeatMonthly = YES;
    [self.repeatMonthlyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.repeatMonthlyButton.backgroundColor = self.color;
    
    if (self.twentyTwo) {
        self.twentyTwo = NO;
        [self.twentyTwoButton setTitleColor:self.color forState:UIControlStateNormal];
        self.twentyTwoButton.backgroundColor = [UIColor whiteColor];
    } else {
        self.twentyTwo = YES;
        [self.twentyTwoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.twentyTwoButton.backgroundColor = self.color;
    }
}

- (IBAction)twentyThree:(id)sender
{
    for (UIButton *button in self.colorButtons) {
        [button setTitleColor:self.color forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
    }
    self.repeatDaily = NO;
    self.repeatWeekly = NO;
    
    self.sunday = NO;
    self.monday = NO;
    self.tuesday = NO;
    self.wednesday = NO;
    self.thursday = NO;
    self.friday = NO;
    self.saturday = NO;
    
    //repeatMonthlyButton
    self.repeatMonthly = YES;
    [self.repeatMonthlyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.repeatMonthlyButton.backgroundColor = self.color;
    
    if (self.twentyThree) {
        self.twentyThree = NO;
        [self.twentyThreeButton setTitleColor:self.color forState:UIControlStateNormal];
        self.twentyThreeButton.backgroundColor = [UIColor whiteColor];
    } else {
        self.twentyThree = YES;
        [self.twentyThreeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.twentyThreeButton.backgroundColor = self.color;
    }
}

- (IBAction)twentyFour:(id)sender
{
    for (UIButton *button in self.colorButtons) {
        [button setTitleColor:self.color forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
    }
    self.repeatDaily = NO;
    self.repeatWeekly = NO;
    
    self.sunday = NO;
    self.monday = NO;
    self.tuesday = NO;
    self.wednesday = NO;
    self.thursday = NO;
    self.friday = NO;
    self.saturday = NO;
    
    //repeatMonthlyButton
    self.repeatMonthly = YES;
    [self.repeatMonthlyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.repeatMonthlyButton.backgroundColor = self.color;
    
    if (self.twentyFour) {
        self.twentyFour = NO;
        [self.twentyFourButton setTitleColor:self.color forState:UIControlStateNormal];
        self.twentyFourButton.backgroundColor = [UIColor whiteColor];
    } else {
        self.twentyFour = YES;
        [self.twentyFourButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.twentyFourButton.backgroundColor = self.color;
    }
}

- (IBAction)twentyFive:(id)sender
{
    for (UIButton *button in self.colorButtons) {
        [button setTitleColor:self.color forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
    }
    self.repeatDaily = NO;
    self.repeatWeekly = NO;
    
    self.sunday = NO;
    self.monday = NO;
    self.tuesday = NO;
    self.wednesday = NO;
    self.thursday = NO;
    self.friday = NO;
    self.saturday = NO;
    
    //repeatMonthlyButton
    self.repeatMonthly = YES;
    [self.repeatMonthlyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.repeatMonthlyButton.backgroundColor = self.color;
    
    if (self.twentyFive) {
        self.twentyFive = NO;
        [self.twentyFiveButton setTitleColor:self.color forState:UIControlStateNormal];
        self.twentyFiveButton.backgroundColor = [UIColor whiteColor];
    } else {
        self.twentyFive = YES;
        [self.twentyFiveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.twentyFiveButton.backgroundColor = self.color;
    }
}

- (IBAction)twentySix:(id)sender
{
    for (UIButton *button in self.colorButtons) {
        [button setTitleColor:self.color forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
    }
    self.repeatDaily = NO;
    self.repeatWeekly = NO;
    
    self.sunday = NO;
    self.monday = NO;
    self.tuesday = NO;
    self.wednesday = NO;
    self.thursday = NO;
    self.friday = NO;
    self.saturday = NO;
    
    //repeatMonthlyButton
    self.repeatMonthly = YES;
    [self.repeatMonthlyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.repeatMonthlyButton.backgroundColor = self.color;
    
    if (self.twentySix) {
        self.twentySix = NO;
        [self.twentySixButton setTitleColor:self.color forState:UIControlStateNormal];
        self.twentySixButton.backgroundColor = [UIColor whiteColor];
    } else {
        self.twentySix = YES;
        [self.twentySixButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.twentySixButton.backgroundColor = self.color;
    }
}
- (IBAction)twentySeven:(id)sender
{
    for (UIButton *button in self.colorButtons) {
        [button setTitleColor:self.color forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
    }
    self.repeatDaily = NO;
    self.repeatWeekly = NO;
    
    self.sunday = NO;
    self.monday = NO;
    self.tuesday = NO;
    self.wednesday = NO;
    self.thursday = NO;
    self.friday = NO;
    self.saturday = NO;
    
    //repeatMonthlyButton
    self.repeatMonthly = YES;
    [self.repeatMonthlyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.repeatMonthlyButton.backgroundColor = self.color;
    
    if (self.twentySeven) {
        self.twentySeven = NO;
        [self.twentySevenButton setTitleColor:self.color forState:UIControlStateNormal];
        self.twentySevenButton.backgroundColor = [UIColor whiteColor];
    } else {
        self.twentySeven = YES;
        [self.twentySevenButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.twentySevenButton.backgroundColor = self.color;
    }
}

- (IBAction)twentyEight:(id)sender
{
    for (UIButton *button in self.colorButtons) {
        [button setTitleColor:self.color forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
    }
    self.repeatDaily = NO;
    self.repeatWeekly = NO;
    
    self.sunday = NO;
    self.monday = NO;
    self.tuesday = NO;
    self.wednesday = NO;
    self.thursday = NO;
    self.friday = NO;
    self.saturday = NO;
    
    //repeatMonthlyButton
    self.repeatMonthly = YES;
    [self.repeatMonthlyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.repeatMonthlyButton.backgroundColor = self.color;
    
    if (self.twentyEight) {
        self.twentyEight = NO;
        [self.twentyEightButton setTitleColor:self.color forState:UIControlStateNormal];
        self.twentyEightButton.backgroundColor = [UIColor whiteColor];
    } else {
        self.twentyEight = YES;
        [self.twentyEightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.twentyEightButton.backgroundColor = self.color;
    }
}

- (IBAction)twentyNine:(id)sender
{
    for (UIButton *button in self.colorButtons) {
        [button setTitleColor:self.color forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
    }
    self.repeatDaily = NO;
    self.repeatWeekly = NO;
    
    self.sunday = NO;
    self.monday = NO;
    self.tuesday = NO;
    self.wednesday = NO;
    self.thursday = NO;
    self.friday = NO;
    self.saturday = NO;
    
    //repeatMonthlyButton
    self.repeatMonthly = YES;
    [self.repeatMonthlyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.repeatMonthlyButton.backgroundColor = self.color;
    
    if (self.twentyNine) {
        self.twentyNine = NO;
        [self.twentyNineButton setTitleColor:self.color forState:UIControlStateNormal];
        self.twentyNineButton.backgroundColor = [UIColor whiteColor];
    } else {
        self.twentyNine = YES;
        [self.twentyNineButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.twentyNineButton.backgroundColor = self.color;
    }
}

- (IBAction)thirty:(id)sender
{
    for (UIButton *button in self.colorButtons) {
        [button setTitleColor:self.color forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
    }
    self.repeatDaily = NO;
    self.repeatWeekly = NO;
    
    self.sunday = NO;
    self.monday = NO;
    self.tuesday = NO;
    self.wednesday = NO;
    self.thursday = NO;
    self.friday = NO;
    self.saturday = NO;
    
    //repeatMonthlyButton
    self.repeatMonthly = YES;
    [self.repeatMonthlyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.repeatMonthlyButton.backgroundColor = self.color;
    
    if (self.thirty) {
        self.thirty = NO;
        [self.thirtyButton setTitleColor:self.color forState:UIControlStateNormal];
        self.thirtyButton.backgroundColor = [UIColor whiteColor];
    } else {
        self.thirty = YES;
        [self.thirtyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.thirtyButton.backgroundColor = self.color;
    }
}

- (IBAction)thirtyOne:(id)sender
{
    for (UIButton *button in self.colorButtons) {
        [button setTitleColor:self.color forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
    }
    self.repeatDaily = NO;
    self.repeatWeekly = NO;
    
    self.sunday = NO;
    self.monday = NO;
    self.tuesday = NO;
    self.wednesday = NO;
    self.thursday = NO;
    self.friday = NO;
    self.saturday = NO;
    
    //repeatMonthlyButton
    self.repeatMonthly = YES;
    [self.repeatMonthlyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.repeatMonthlyButton.backgroundColor = self.color;
    
    if (self.thirtyOne) {
        self.thirtyOne = NO;
        [self.thirtyOneButton setTitleColor:self.color forState:UIControlStateNormal];
        self.thirtyOneButton.backgroundColor = [UIColor whiteColor];
    } else {
        self.thirtyOne = YES;
        [self.thirtyOneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.thirtyOneButton.backgroundColor = self.color;
    }
}

#pragma mark - Functions
- (NSArray *)findWeekDaysToRepeat
{
    NSMutableArray *weekDaysToRepeat = [[NSMutableArray alloc] init];
    if (self.sunday) {
        [weekDaysToRepeat addObject:@0];
    }
    if (self.monday) {
        [weekDaysToRepeat addObject:@1];
    }
    if (self.tuesday) {
        [weekDaysToRepeat addObject:@2];
    }
    if (self.wednesday) {
        [weekDaysToRepeat addObject:@3];
    }
    if (self.thursday) {
        [weekDaysToRepeat addObject:@4];
    }
    if (self.friday) {
        [weekDaysToRepeat addObject:@5];
    }
    if (self.saturday) {
        [weekDaysToRepeat addObject:@6];
    }
    
    return weekDaysToRepeat;
}

- (NSArray *)findMonthDaysToRepeat
{
    NSMutableArray *monthDaysToRepeat = [[NSMutableArray alloc] init];
    if (self.one) {
        [monthDaysToRepeat addObject:@0];
    }
    if (self.two) {
        [monthDaysToRepeat addObject:@1];
    }
    if (self.three) {
        [monthDaysToRepeat addObject:@2];
    }
    if (self.four) {
        [monthDaysToRepeat addObject:@3];
    }
    if (self.five) {
        [monthDaysToRepeat addObject:@4];
    }
    if (self.six) {
        [monthDaysToRepeat addObject:@5];
    }
    if (self.seven) {
        [monthDaysToRepeat addObject:@6];
    }
    if (self.eight) {
        [monthDaysToRepeat addObject:@7];
    }
    if (self.nine) {
        [monthDaysToRepeat addObject:@8];
    }
    if (self.ten) {
        [monthDaysToRepeat addObject:@9];
    }
    if (self.eleven) {
        [monthDaysToRepeat addObject:@10];
    }
    if (self.twelve) {
        [monthDaysToRepeat addObject:@11];
    }
    if (self.thirteen) {
        [monthDaysToRepeat addObject:@12];
    }
    if (self.fourteen) {
        [monthDaysToRepeat addObject:@13];
    }
    if (self.fifteen) {
        [monthDaysToRepeat addObject:@14];
    }
    if (self.sixteen) {
        [monthDaysToRepeat addObject:@15];
    }
    if (self.seventeen) {
        [monthDaysToRepeat addObject:@16];
    }
    if (self.eighteen) {
        [monthDaysToRepeat addObject:@17];
    }
    if (self.nineteen) {
        [monthDaysToRepeat addObject:@18];
    }
    if (self.twenty) {
        [monthDaysToRepeat addObject:@19];
    }
    if (self.twentyOne) {
        [monthDaysToRepeat addObject:@20];
    }
    if (self.twentyTwo) {
        [monthDaysToRepeat addObject:@21];
    }
    if (self.twentyThree) {
        [monthDaysToRepeat addObject:@22];
    }
    if (self.twentyFour) {
        [monthDaysToRepeat addObject:@23];
    }
    if (self.twentyFive) {
        [monthDaysToRepeat addObject:@24];
    }
    if (self.twentySix) {
        [monthDaysToRepeat addObject:@25];
    }
    if (self.twentySeven) {
        [monthDaysToRepeat addObject:@26];
    }
    if (self.twentyEight) {
        [monthDaysToRepeat addObject:@27];
    }
    if (self.twentyNine) {
        [monthDaysToRepeat addObject:@28];
    }
    if (self.thirty) {
        [monthDaysToRepeat addObject:@29];
    }
    if (self.thirtyOne) {
        [monthDaysToRepeat addObject:@30];
    }
    
    return monthDaysToRepeat;
}

@end
