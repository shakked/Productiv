//
//  ZSWSummaryViewController.m
//  Productiv
//
//  Created by Zachary Shakked on 7/25/14.
//  Copyright (c) 2014 Productiv. All rights reserved.
//

#import "ZSWSummaryViewController.h"
#import "ZSWTaskStore.h"
#import <MagicPieLayer.h>
#import "PieLayer.h"
#import "ZSWSummaryTableViewController.h"


@interface ZSWSummaryViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) PieLayer *pieLayer;
@property (nonatomic, strong) PieElement *pieElementGreen;
@property (nonatomic, strong) PieElement *pieElementGray;
@property (nonatomic, strong) UILabel *percentageOfTasksLabel;
@property (nonatomic, strong) UILabel *totalNumberOfTasksLabel;
@property (nonatomic, strong) UILabel *totalNumberOfCompleteTasksLabel;
@property (nonatomic, strong) UILabel *totalNumberOfIncompleteTasksLabel;
@property (nonatomic, strong) UILabel *averageNumberOfTasksPerDayLabel;
@property (nonatomic, strong) UILabel *favoriteCategoryLabel;

@end

@implementation ZSWSummaryViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        self.view.backgroundColor = [UIColor whiteColor];
        CGRect screenRect = self.view.bounds; //the overall big one
        CGRect bigRect = screenRect; //the big rect
        bigRect.size.height *= 1.3; //enlarge the size by 2.0
        
        self.navigationItem.title = @"Task Summary";
        
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
        
        //Avg number of tasks per day
        CGRect averageNumberOfTasksPerDayFrame = CGRectMake(10, 410, self.view.frame.size.width - 20, 30);
        self.averageNumberOfTasksPerDayLabel = [[UILabel alloc] initWithFrame:averageNumberOfTasksPerDayFrame];
        self.averageNumberOfTasksPerDayLabel.textAlignment = NSTextAlignmentCenter;
        self.averageNumberOfTasksPerDayLabel.textColor = color;
        self.averageNumberOfTasksPerDayLabel.backgroundColor = [UIColor whiteColor];
        self.averageNumberOfTasksPerDayLabel.numberOfLines = 0;
        [[self.averageNumberOfTasksPerDayLabel layer] setBorderColor:color.CGColor];
        [[self.averageNumberOfTasksPerDayLabel layer] setBorderWidth:1.0];
        [[self.averageNumberOfTasksPerDayLabel layer] setCornerRadius:7.0];
        self.averageNumberOfTasksPerDayLabel.font = [UIFont fontWithName:@"Avenir" size:16.0];
        
        [self.scrollView addSubview:self.averageNumberOfTasksPerDayLabel];

        //Favorite Category
        CGRect favoriteCategoryFrame = CGRectMake(10, 450, self.view.frame.size.width - 20, 30);
        self.favoriteCategoryLabel = [[UILabel alloc] initWithFrame:favoriteCategoryFrame];
        self.favoriteCategoryLabel.textAlignment = NSTextAlignmentCenter;
        self.favoriteCategoryLabel.textColor = color;
        self.favoriteCategoryLabel.backgroundColor = [UIColor whiteColor];
        self.favoriteCategoryLabel.numberOfLines = 0;
        [[self.favoriteCategoryLabel layer] setBorderColor:color.CGColor];
        [[self.favoriteCategoryLabel layer] setBorderWidth:1.0];
        [[self.favoriteCategoryLabel layer] setCornerRadius:7.0];
        self.favoriteCategoryLabel.font = [UIFont fontWithName:@"Avenir" size:16.0];

        [self.scrollView addSubview:self.favoriteCategoryLabel];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;

    NSDictionary *stats = [[ZSWTaskStore sharedStore] stats];
    
    //Colors
    NSDictionary *colors = [[ZSWTaskStore sharedStore] colors];
    UIColor *color = [colors valueForKey:@"productiveGreen"];
    UIColor *lightGray = [colors valueForKey:@"lightGray"];

    //data

    NSNumber *totalNumberOfTasks = [stats valueForKey:@"totalNumberOfTasks"];
    NSNumber *totalNumberOfCompleteTasks = [stats valueForKey:@"totalNumberOfCompleteTasks"];
    NSNumber *totalNumberOfIncompleteTasks = [stats valueForKey:@"totalNumberOfIncompleteTasks"];
    NSNumber *averageNumberOfTasksPerDay = [stats valueForKey:@"averageNumberOfTasksPerDay"];

    NSManagedObject *favoriteCategory = [stats valueForKey:@"favoriteCategory"];

    float percentageOfTasksCompleted = totalNumberOfCompleteTasks.floatValue / totalNumberOfTasks.floatValue;
    percentageOfTasksCompleted *= 100;

    
    //totalNumberOfTasks
    NSString *percentageCompletedString = [NSString stringWithFormat:@"You've completed %.2f%% of your tasks.", percentageOfTasksCompleted];
    NSRange rangeForBoldedPercentage = [percentageCompletedString rangeOfString:@"."];
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
        [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Avenir-Heavy" size:16.0] range:range];
        self.percentageOfTasksLabel.attributedText = string;
    } else {
        self.percentageOfTasksLabel.text = @"You haven't made any tasks.";
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
    
    //averageNumberOfTasksPerDay
    NSString *averageNumberOfTasksPerDayString = [NSString stringWithFormat:@"Average number of tasks per day: %.2f", averageNumberOfTasksPerDay.floatValue];
    rangeForColon = [averageNumberOfTasksPerDayString rangeOfString:@":"];
    length = [averageNumberOfTasksPerDay.stringValue length];
    NSRange rangeForAverageNumberOfTasksPerDay;
    if (averageNumberOfTasksPerDay.floatValue < 9.9999999999999) {
        rangeForAverageNumberOfTasksPerDay = NSMakeRange(rangeForColon.location + 2, 4);
    } else if(averageNumberOfTasksPerDay.floatValue < 99.99999999999) {
        rangeForAverageNumberOfTasksPerDay = NSMakeRange(rangeForColon.location + 2, 5);
    } else if (averageNumberOfTasksPerDay.floatValue < 999.9999999999999) {
        rangeForAverageNumberOfTasksPerDay = NSMakeRange(rangeForColon.location + 2, 6);
    }else {
        rangeForAverageNumberOfTasksPerDay = NSMakeRange(rangeForColon.location + 2, 3);
    }
    NSMutableAttributedString *averageNumberOfTasksPerDayStringFormatted = [[NSMutableAttributedString alloc] initWithString:averageNumberOfTasksPerDayString];
    [averageNumberOfTasksPerDayStringFormatted addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Avenir-Heavy" size:16.0] range:rangeForAverageNumberOfTasksPerDay];
    self.averageNumberOfTasksPerDayLabel.attributedText = averageNumberOfTasksPerDayStringFormatted;
    
    //favoriteCategory
    if ([favoriteCategory valueForKey:@"name"]) {
        NSString *favoriteCategoryString = [NSString stringWithFormat:@"Favorite Category: %@", [favoriteCategory valueForKey:@"name"]];
        rangeForColon = [favoriteCategoryString rangeOfString:@":"];
        length = [[favoriteCategory valueForKey:@"name"] length];
        NSRange rangeForFavoriteCategory = NSMakeRange(rangeForColon.location + 2, length);
        NSMutableAttributedString *favoriteCategoryStringFormatted = [[NSMutableAttributedString alloc] initWithString:favoriteCategoryString];
        [favoriteCategoryStringFormatted addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Avenir-Heavy" size:16.0] range:rangeForFavoriteCategory];
        self.favoriteCategoryLabel.attributedText = favoriteCategoryStringFormatted;
    } else {
        self.favoriteCategoryLabel.text = @"No Favorite Category.";
    }
    
}


- (void)showAllTasks
{
    ZSWSummaryTableViewController *tbct = [[ZSWSummaryTableViewController alloc] init];
    tbct.segIndex = 0;
    [self.navigationController pushViewController:tbct animated:YES];
}
- (void)showAllCompleteTasks
{
    ZSWSummaryTableViewController *tbct = [[ZSWSummaryTableViewController alloc] init];
    tbct.segIndex = 1;
    [self.navigationController pushViewController:tbct animated:YES];
}

- (void)showAllIncompleteTasks
{
    ZSWSummaryTableViewController *tbct = [[ZSWSummaryTableViewController alloc] init];
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
