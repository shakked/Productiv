//
//  ZSWNoteViewController.m
//  Productiv
//
//  Created by Zachary Shakked on 7/21/14.
//  Copyright (c) 2014 Productiv. All rights reserved.
//

#import "ZSWNoteViewController.h"
#import "ZSWTaskStore.h"

@interface ZSWNoteViewController () <UITextViewDelegate>

@property (nonatomic, weak) IBOutlet UITextView *textView;

@end

@implementation ZSWNoteViewController

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
    // Do any additional setup after loading the view from its nib.
    
    //delegate
    self.textView.delegate = self;
    
    //colors
    NSDictionary *colors = [[ZSWTaskStore sharedStore] colors];
    UIColor *color = [colors valueForKey:@"productiveGreen"];
    
    //textView
    [[self.textView layer] setBorderColor:color.CGColor];
    [[self.textView layer] setBorderWidth:1.0];
    self.textView.font = [UIFont fontWithName:@"Avenir" size:16.0];
    [[self.textView layer] setCornerRadius:7.0];
    
    //navigation bar
    self.navigationItem.title = @"Note";
    //bar buttons
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                         target:self
                                                                         action:@selector(saveNote)];
    self.navigationItem.rightBarButtonItem = bbi;
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([self.task.note isEqual:@""] || !self.task.note) {
        self.textView.text = @"Enter text here";
        self.textView.textColor = [UIColor lightGrayColor];
    } else {
        self.textView.text = self.task.note;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.textView endEditing:YES];
    
    [[ZSWTaskStore sharedStore] saveChanges];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Interaction
- (void)saveNote
{
    
    NSLog(@"this is the note: %@", self.textView.text);
    self.task.note = self.textView.text;
    NSLog(@"this is the note from the task: %@", self.task.note);
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([self.textView.text isEqual:@"Enter text here"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}

@end
