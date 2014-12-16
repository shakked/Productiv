//
//  ZSWAppDelegate.m
//  Productiv
//
//  Created by Zachary Shakked on 7/18/14.
//  Copyright (c) 2014 Productiv. All rights reserved.
//

#import "ZSWAppDelegate.h"
#import "ZSWTaskStore.h"

//View controllers
#import "ZSWCategoryViewController.h"
#import "ZSWTaskTableViewController.h"
#import "ZSWSummaryViewController.h"

@implementation ZSWAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
    //Nav with Category Root
    ZSWCategoryViewController *cvc = [[ZSWCategoryViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:cvc];
    
    //Nav Font
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                                            NSForegroundColorAttributeName: [UIColor whiteColor],
                                                            NSFontAttributeName: [UIFont fontWithName:@"Avenir" size:26.0f],
                                                            }];
    
    
    //Category Tab Configure
    nav.tabBarItem.image = [UIImage imageNamed:@"categories.png"];
    nav.tabBarItem.title = @"Categories";
    
    //Create the Task table view
    ZSWTaskTableViewController *ttvc = [[ZSWTaskTableViewController alloc] init];
    
    //Create the Future view controller
    //ZSSFutureViewController *fvc = [[ZSSFutureViewController alloc] init];
    
    //Create the navController for the complishTable
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:ttvc];
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                                            NSForegroundColorAttributeName: [UIColor whiteColor],
                                                            NSFontAttributeName: [UIFont fontWithName:@"Avenir" size:26.0f],
                                                            }];
    ZSWSummaryViewController *smvc = [[ZSWSummaryViewController alloc] init];
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:smvc];
    
    NSDictionary *colors = [[ZSWTaskStore sharedStore] colors];
    UIColor *color = [colors valueForKey:@"productiveGreen"];
    nav3.navigationBar.tintColor = [UIColor whiteColor];
    nav3.navigationBar.barTintColor = color;
    nav3.navigationBar.translucent = NO;
    nav3.tabBarItem.title = @"Summary";
    nav3.tabBarItem.image = [UIImage imageNamed:@"summary.png"];
    
    
    

    
    nav2.navigationBar.tintColor = [UIColor whiteColor];
    nav2.navigationBar.barTintColor = color;
    nav2.navigationBar.translucent = NO;

    nav2.tabBarItem.title = @"Tasks";
    nav2.tabBarItem.image = [UIImage imageNamed:@"filledCheckmark.png"];
    
    //Configure and create tab bar
    UITabBarController *tab = [[UITabBarController alloc] init];
    tab.tabBar.tintColor = color;
    
    tab.viewControllers = @[nav3, nav2, nav];
    tab.selectedViewController = nav2;

    //Set its tabBar title
    /*
    //Creat the category nav controller
    
    //Create the array of controllers for the tabBar
    NSArray *controllers = @[categoryNavController, complishTableNavController, fvc];
    
    //assign the array of controllers to the tab bar
    tabBar.viewControllers = controllers;
    
    //set the today controller as the main view8
    tabBar.selectedViewController = complishTableNavController;
    
    //Configure the window and set the rootViewController

    */
    
    //status bar
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = tab;
    [self.window makeKeyAndVisible];
    
    //iOS 8 REQUIRED
    //[application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    
    return YES;

}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [[ZSWTaskStore sharedStore] saveChanges];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [[ZSWTaskStore sharedStore] saveChanges];

    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Productiv" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Productiv.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
