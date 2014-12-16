//
//  ZSWNewCategoryViewController.m
//  Productiv
//
//  Created by Zachary Shakked on 7/19/14.
//  Copyright (c) 2014 Productiv. All rights reserved.
//

#import "ZSWNewCategoryViewController.h"
#import "ZSWTaskStore.h"

@interface ZSWNewCategoryViewController () <UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, weak) IBOutlet UILabel *label;

@end

@implementation ZSWNewCategoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    self.textField.delegate = self;
    
    UIBarButtonItem *bbiCancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                               target:self
                                                                               action:@selector(cancelCategory)];
    
    self.navigationItem.leftBarButtonItem = bbiCancel;
    
    self.navigationItem.title = @"New";
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Dismiss Keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

- (IBAction)touchUpInside:(id)sender
{
    [self.textField endEditing:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIBarButtonItem *bbiSave = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                             target:self
                                                                             action:@selector(saveCategory)];
    self.navigationItem.rightBarButtonItem = bbiSave;
    NSLog(@"hi");
}


//cancel and save category
- (void)cancelCategory
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveCategory
{
    
    NSString *category = self.textField.text;
    //make sure category isn't empty
    if ([category isEqualToString:@""]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        //capitilize first letter
        category = [category capitalizedString];
        NSLog(@"capitlized: %@", category);
        [[ZSWTaskStore sharedStore] addCategory:category];
        [self.navigationController popViewControllerAnimated:YES];

    }
}




@end
