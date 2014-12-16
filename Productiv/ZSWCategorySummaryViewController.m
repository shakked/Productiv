//
//  ZSWCategorySummaryViewController.m
//  Productiv
//
//  Created by Zachary Shakked on 7/30/14.
//  Copyright (c) 2014 Productiv. All rights reserved.
//

#import "ZSWCategorySummaryViewController.h"
#import "ZSWTask.h"
#import "ZSWTaskStore.h"
#import <MagicPieLayer.h>
#import "PieLayer.h"
#import "ZSWTaskByCategoryTableViewController.h"

@interface ZSWCategorySummaryViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) PieLayer *pieLayer;
@property (nonatomic, strong) PieElement *pieElementGreen;
@property (nonatomic, strong) PieElement *pieElementGray;
@property (nonatomic, strong) UILabel *percentageOfTasksLabel;
@property (nonatomic, strong) UILabel *totalNumberOfTasksLabel;
@property (nonatomic, strong) UILabel *totalNumberOfCompleteTasksLabel;
@property (nonatomic, strong) UILabel *totalNumberOfIncompleteTasksLabel;


@end

@implementation ZSWCategorySummaryViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
        CGRect screenRect = self.view.bounds; //the overall big one
        CGRect bigRect = screenRect; //the big rect
        bigRect.size.height *= 1.3; //enlarge the size by 2.0
        
        //Create a screen-sized scroll view and add it to the window
        self.scrollView = [[UIScrollView alloc] initWithFrame:screenRect];
        self.scrollView.contentSize = bigRect.size;
        [self.view addSubview:self.scrollView];
        
        //Main View
        UIView *view = [[UIView alloc] initWithFrame:bigRect];
        view.backgroundColor = [UIColor whiteColor];
        [self.scrollView addSubview:view];
        
        //Colors
        NSDictionary *colors = [[ZSWTaskStore sharedStore] colors];
        UIColor *color = [colors valueForKey:@"productiveGreen"];
        UIColor *lightGray = [colors valueForKey:@"lightGray"];
        
        //pieLayer
        self.pieLayer = [[PieLayer alloc] init];
        self.pieLayer.frame = CGRectMake(0, 30, self.view.frame.size.width, 300);
        self.pieElementGreen = [PieElement pieElementWithValue:3 color:color];
        self.pieElementGray = [PieElement pieElementWithValue:3 color:lightGray];
        [self.pieLayer addValues:@[self.pieElementGreen, self.pieElementGray] animated:YES];
        [self.scrollView.layer addSublayer:self.pieLayer];

        
        //percentageOfTasks
        CGRect percentageOfTasksLabelFrame = CGRectMake(10, 10, self.view.frame.size.width - 20, 60);
        self.percentageOfTasksLabel = [[UILabel alloc] initWithFrame:percentageOfTasksLabelFrame];
        self.percentageOfTasksLabel.textAlignment = NSTextAlignmentCenter;
        self.percentageOfTasksLabel.textColor = color;
        self.percentageOfTasksLabel.backgroundColor = [UIColor whiteColor];
        self.percentageOfTasksLabel.numberOfLines = 0;
        [[self.percentageOfTasksLabel layer] setBorderColor:color.CGColor];
        [[self.percentageOfTasksLabel layer] setBorderWidth:1.0];
        [[self.percentageOfTasksLabel layer] setCornerRadius:7.0];
        self.percentageOfTasksLabel.font = [UIFont fontWithName:@"Avenir" size:17.0];
        
        [self.scrollView addSubview:self.percentageOfTasksLabel];
        
        //totalNumberOfTasks
        UIButton *totalNumberOfTasksButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 290, self.view.frame.size.width - 20, 30)];
        [totalNumberOfTasksButton addTarget:self
                                     action:@selector(showAllTasks)
                           forControlEvents:UIControlEventTouchUpInside];
        totalNumberOfTasksButton.backgroundColor = [UIColor clearColor];
        [totalNumberOfTasksButton setTitle:@"" forState:UIControlStateNormal];
        
        CGRect totalNumberOfTasksLabelFrame = CGRectMake(10, 290, self.view.frame.size.width - 20, 30);
        self.totalNumberOfTasksLabel = [[UILabel alloc] initWithFrame:totalNumberOfTasksLabelFrame];
        [[self.totalNumberOfTasksLabel layer] setCornerRadius:7.0];
        self.totalNumberOfTasksLabel.clipsToBounds = YES;
        self.totalNumberOfTasksLabel.textAlignment = NSTextAlignmentCenter;
        self.totalNumberOfTasksLabel.textColor = [UIColor whiteColor];
        self.totalNumberOfTasksLabel.backgroundColor = color;
        self.totalNumberOfTasksLabel.numberOfLines = 0;
        self.totalNumberOfTasksLabel.font = [UIFont fontWithName:@"Avenir" size:16.0];
        
        [self.scrollView addSubview:totalNumberOfTasksButton];
        [self.scrollView addSubview:self.totalNumberOfTasksLabel];
        
        //totalNumberOfCompleteTasks
        UIButton *totalNumberOfCompleteTasksButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 330, self.view.frame.size.width - 20, 30)];
        [totalNumberOfCompleteTasksButton addTarget:self
                                             action:@selector(showAllCompleteTasks)
                                   forControlEvents:UIControlEventTouchUpInside];
        totalNumberOfTasksButton.backgroundColor = [UIColor clearColor];
        [totalNumberOfTasksButton setTitle:@"" forState:UIControlStateNormal];
        CGRect totalNumberOfCompleteTasksLabelFrame = CGRectMake(10, 330, self.view.frame.size.width - 20, 30);
        self.totalNumberOfCompleteTasksLabel = [[UILabel alloc] initWithFrame:totalNumberOfCompleteTasksLabelFrame];
        self.totalNumberOfCompleteTasksLabel.textAlignment = NSTextAlignmentCenter;
        self.totalNumberOfCompleteTasksLabel.textColor = [UIColor whiteColor];
        self.totalNumberOfCompleteTasksLabel.backgroundColor = color;
        self.totalNumberOfCompleteTasksLabel.numberOfLines = 0;
        [[self.totalNumberOfCompleteTasksLabel layer] setCornerRadius:7.0];
        self.totalNumberOfCompleteTasksLabel.clipsToBounds = YES;
        self.totalNumberOfCompleteTasksLabel.font = [UIFont fontWithName:@"Avenir" size:16.0];
        
        [self.scrollView addSubview:totalNumberOfCompleteTasksButton];
        [self.scrollView addSubview:self.totalNumberOfCompleteTasksLabel];
        
        //totalNumberOfIncompleteTasks
        UIButton *totalNumberOfIncompleteTasksButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 370, self.view.frame.size.width - 20, 30)];
        [totalNumberOfIncompleteTasksButton addTarget:self
                                               action:@selector(showAllIncompleteTasks)
                                     forControlEvents:UIControlEventTouchUpInside];
        totalNumberOfIncompleteTasksButton.backgroundColor = [UIColor clearColor];
        [totalNumberOfIncompleteTasksButton setTitle:@"" forState:UIControlStateNormal];
        CGRect totalNumberOfIncompleteTasksLabelFrame = CGRectMake(10, 370, self.view.frame.size.width - 20, 30);
        self.totalNumberOfIncompleteTasksLabel = [[UILabel alloc] initWithFrame:totalNumberOfIncompleteTasksLabelFrame];
        self.totalNumberOfIncompleteTasksLabel.textAlignment = NSTextAlignmentCenter;
        self.totalNumberOfIncompleteTasksLabel.textColor = [UIColor whiteColor];
        self.totalNumberOfIncompleteTasksLabel.backgroundColor = color;
        self.totalNumberOfIncompleteTasksLabel.numberOfLines = 0;
        [[self.totalNumberOfIncompleteTasksLabel layer] setCornerRadius:7.0];
        self.totalNumberOfIncompleteTasksLabel.clipsToBounds = YES;
        self.totalNumberOfIncompleteTasksLabel.font = [UIFont fontWithName:@"Avenir" size:16.0];
        
        [self.scrollView addSubview:totalNumberOfIncompleteTasksButton];
        [self.scrollView addSubview:self.totalNumberOfIncompleteTasksLabel];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //Colors
    NSDictionary *colors = [[ZSWTaskStore sharedStore] colors];
    UIColor *color = [colors valueForKey:@"productiveGreen"];
    UIColor *lightGray = [colors valueForKey:@"lightGray"];
    
    //navigation
    NSString *categoryName = [self.category valueForKey:@"name"];
    self.navigationItem.title = categoryName;
    
    NSDictionary *stats = [[ZSWTaskStore sharedStore] stats];
    NSDictionary *categoryStats = [stats valueForKey:@"categoryStats"];
    NSDictionary *categoryDictionary = [categoryStats valueForKey:categoryName];
    
    
    NSNumber *totalNumberOfTasks = [categoryDictionary valueForKey:@"numberOfTasks"];
    NSNumber *totalNumberOfCompleteTasks = [categoryDictionary valueForKey:@"totalNumberOfCompleteTasks"];
    NSNumber *totalNumberOfIncompleteTasks = [categoryDictionary valueForKey:@"totalNumberOfIncompleteTasks"];
    //NSNumber *percentageOfTasksInThisCategory = [categoryDictionary valueForKey:@"percentageOfTasksInThisCategory"];
    
    
    float percentageOfTasksCompleted = totalNumberOfCompleteTasks.floatValue / totalNumberOfTasks.floatValue;
    percentageOfTasksCompleted *= 100;
    
    
    //percentageOfCompleted
    NSString *percentageCompletedString = [NSString stringWithFormat:@"You've completed:\n %.2f%% of your %@ tasks.", percentageOfTasksCompleted, categoryName];
    //range for category and percent
    NSRange rangeForBoldedPercentage = [percentageCompletedString rangeOfString:@"."];
    NSRange categoryRange = [percentageCompletedString rangeOfString:categoryName];
    NSRange range;
    if (percentageOfTasksCompleted > 99.99) {
        range = NSMakeRange(rangeForBoldedPercentage.location - 3, 7);
    }else if (percentageOfTasksCompleted > 9.99) {
        range = NSMakeRange(rangeForBoldedPercentage.location - 2, 6);
    }else {
        range = NSMakeRange(rangeForBoldedPercentage.location - 1, 5);
    }
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:percentageCompletedString];
    
    if (totalNumberOfTasks.intValue != 0) {
        [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Avenir-Heavy" size:17.0] range:range];
        [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Avenir-Heavy" size:17.0] range:categoryRange];
        self.percentageOfTasksLabel.attributedText = string;

    } else {
        self.percentageOfTasksLabel.text = @"You haven't made any tasks in this category.";
    }
    
    //Pie Graph
    [PieElement animateChanges:^{
        NSLog(@"complete: %@", totalNumberOfCompleteTasks);
        NSLog(@"incomplete: %@", totalNumberOfIncompleteTasks);
        self.pieElementGreen.val = totalNumberOfCompleteTasks.intValue;
        self.pieElementGreen.color = color;
        self.pieElementGray.val = totalNumberOfIncompleteTasks.intValue;
        self.pieElementGray.color  = lightGray;
    }];

    //totalNumberOfTasks
    NSString *totalNumberOfTasksString = [NSString stringWithFormat:@"Total number of tasks: %d", totalNumberOfTasks.intValue];
    NSRange rangeForColon = [totalNumberOfTasksString rangeOfString:@":"];
    NSInteger length = [totalNumberOfTasks.stringValue length];
    NSRange rangeForTotalNumberOfTasks = NSMakeRange(rangeForColon.location + 2, length);
    NSMutableAttributedString *totalNumberOfTasksStringFormatted = [[NSMutableAttributedString alloc] initWithString:totalNumberOfTasksString];
    [totalNumberOfTasksStringFormatted addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Avenir-Heavy" size:16.0] range:rangeForTotalNumberOfTasks];
    self.totalNumberOfTasksLabel.attributedText = totalNumberOfTasksStringFormatted;
    
    
    //totalNumberOfCompleteTasks
    NSString *totalNumberOfCompleteTasksString = [NSString stringWithFormat:@"Total number of complete tasks: %d", totalNumberOfCompleteTasks.intValue];
    rangeForColon = [totalNumberOfCompleteTasksString rangeOfString:@":"];
    length = [totalNumberOfCompleteTasks.stringValue length];
    NSRange rangeForTotalNumberOfCompleteTasks = NSMakeRange(rangeForColon.location + 2, length);
    NSMutableAttributedString *totalNumberOfCompleteTasksFormatted = [[NSMutableAttributedString alloc] initWithString:totalNumberOfCompleteTasksString];
    [totalNumberOfCompleteTasksFormatted addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Avenir-Heavy" size:16.0] range:rangeForTotalNumberOfCompleteTasks];
    self.totalNumberOfCompleteTasksLabel.attributedText = totalNumberOfCompleteTasksFormatted;
    
    
    //totalNumberOfIncompleteTasks
    NSString *totalNumberOfIncompleteTasksString = [NSString stringWithFormat:@"Total number of incomplete tasks: %d", totalNumberOfIncompleteTasks.intValue];
    rangeForColon = [totalNumberOfIncompleteTasksString rangeOfString:@":"];
    length = [totalNumberOfIncompleteTasks.stringValue length];
    NSRange rangeForTotalNumberOfIncompleteTasks = NSMakeRange(rangeForColon.location + 2, length);
    NSMutableAttributedString *totalNumberOfIncompleteTasksStringFormatted = [[NSMutableAttributedString alloc] initWithString:totalNumberOfIncompleteTasksString];
    [totalNumberOfIncompleteTasksStringFormatted addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Avenir-Heavy" size:16.0] range:rangeForTotalNumberOfIncompleteTasks];
    self.totalNumberOfIncompleteTasksLabel.attributedText = totalNumberOfIncompleteTasksStringFormatted;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
}

- (void)showAllTasks
{
    ZSWTaskByCategoryTableViewController *tbct = [[ZSWTaskByCategoryTableViewController alloc] init];
    tbct.category = self.category;
    tbct.segIndex = 0;
    [self.navigationController pushViewController:tbct animated:YES];
}
- (void)showAllCompleteTasks
{
    ZSWTaskByCategoryTableViewController *tbct = [[ZSWTaskByCategoryTableViewController alloc] init];
    tbct.category = self.category;
    tbct.segIndex = 1;
    [self.navigationController pushViewController:tbct animated:YES];
}

- (void)showAllIncompleteTasks
{
    ZSWTaskByCategoryTableViewController *tbct = [[ZSWTaskByCategoryTableViewController alloc] init];
    tbct.category = self.category;
    tbct.segIndex = 2;
    [self.navigationController pushViewController:tbct animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
