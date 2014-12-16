//
//  ZSWCategoryViewController.m
//  Productiv
//
//  Created by Zachary Shakked on 7/18/14.
//  Copyright (c) 2014 Productiv. All rights reserved.
//


#import "ZSWCategoryViewController.h"
#import "ZSWNewCategoryViewController.h"
#import "ZSWTaskStore.h"
#import "ZSWTask.h"
#import "ZSWCategorySummaryViewController.h"

@interface ZSWCategoryViewController () <UIGestureRecognizerDelegate>

@end

@implementation ZSWCategoryViewController

#pragma mark - Initialization
- (id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}
- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Register the reuse identifier
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"UITableViewCell"];
    
    //Make an add button to add a new category
    UIBarButtonItem *bbiAdd = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                            target:self
                                                                            action:@selector(addCategory)];
    UINavigationItem *navItem = self.navigationItem;
    self.navigationItem.title = @"Categories";
    navItem.rightBarButtonItem = bbiAdd;
    
    //Navigation bar formatting
    self.navigationController.navigationBar.translucent = NO;
    NSDictionary *colors = [[ZSWTaskStore sharedStore] colors];
    UIColor *color = [colors valueForKey:@"productiveGreen"];
    self.navigationController.navigationBar.barTintColor = color;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    //Format tab bar
    self.tabBarController.tabBar.tintColor = color;
    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    [self.tableView reloadData];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    // Return the number of rows in the section.
    return [[[ZSWTaskStore sharedStore] allCategories] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *categories = [[ZSWTaskStore sharedStore] allCategories];
    
    NSManagedObject *category = categories[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    NSString *categoryString = [category valueForKey:@"name"];
    cell.textLabel.text = categoryString;
    cell.textLabel.font = [UIFont fontWithName:@"Avenir" size:20];
    if (self.task.category == category) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(editMode)];
    longPress.delegate = self;
    [cell addGestureRecognizer:longPress];
    
    //accessory

    if (!self.fromNewTask){
        NSDictionary *stats = [[ZSWTaskStore sharedStore] stats];
        NSArray *categoriesWithTasks = [stats valueForKey:@"categoriesWithTasks"];
        NSString *categoryName = cell.textLabel.text;
        if ([categoriesWithTasks containsObject:categoryName]){
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *categories = [[ZSWTaskStore sharedStore] allCategories];

    if (self.fromNewTask) {
        self.task.category = categories[indexPath.row];
        [self.navigationController popViewControllerAnimated:YES];
        
        [self.tableView reloadData];
    } else if (!self.fromNewTask) {
        NSManagedObject *category = categories[indexPath.row];
        NSString *categoryName = [category valueForKey:@"name"];
        NSDictionary *stats = [[ZSWTaskStore sharedStore] stats];
        NSArray *categoriesWithTasks = [stats valueForKey:@"categoriesWithTasks"];
        if ([categoriesWithTasks containsObject:categoryName]) {
            ZSWCategorySummaryViewController *csvc = [[ZSWCategorySummaryViewController alloc] init];
            csvc.category = categories[indexPath.row];
            [self.navigationController pushViewController:csvc animated:YES];
        }else {
            [self. tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
        
    }
    
}



- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addCategory
{
    ZSWNewCategoryViewController *ncvc = [[ZSWNewCategoryViewController alloc] init];
    [self.navigationController pushViewController:ncvc animated:YES];
}

#pragma mark - Edit Mode
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
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSArray *categories = [[ZSWTaskStore sharedStore] allCategories];
        NSString *category = categories[indexPath.row];
        [[ZSWTaskStore sharedStore]removeCategory:category];
        [self.tableView reloadData];
    }

    BOOL success = [[ZSWTaskStore sharedStore] saveChanges];
    if (success) {
        NSLog(@"deleted cell.");
    }
}


@end
