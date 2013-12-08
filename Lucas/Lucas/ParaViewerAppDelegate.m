//
//  ParaViewerAppDelegate.m
//  Lucas
//
//  Created by xiangyuh on 13-8-23.
//  Copyright (c) 2013年 xiangyuh. All rights reserved.
//

#import "ParaViewerAppDelegate.h"

#import "ParaViewerViewController.h"
#import "IIViewDeckController.h"
#import "LeftScopeViewController.h"
#import "IISideController.h"

@implementation ParaViewerAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize centerController = _centerController;
@synthesize leftScopeViewController = _leftScopeViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    IIViewDeckController *deckController = [self generateControllerStack];
    
    self.centerController = deckController.centerController;
    self.window.rootViewController = deckController;

    
//    NSLog(@"In application(). frame: %@", NSStringFromCGRect(deckController.view.frame));
    
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (IIViewDeckController *)generateControllerStack
{
    
//    ParaViewerViewController *paraViewerViewController = [[ParaViewerViewController alloc] initWithNibName:@"ParaViewerViewController" bundle:nil];
    UIViewController *paraViewerViewController = [[ParaViewerViewController alloc] initWithNibName:Nil bundle:Nil];
    
    [AMCommandMaster addButtons:@[[AMCommandButton createButtonWithImage:[UIImage imageNamed:@"saveIcon"] andTitle:@"save" andMenuListItems:@[@"menu item 1", @"menu item 2", @"menu item 3"]],
                                  [AMCommandButton createButtonWithImage:[UIImage imageNamed:@"deleteIcon"] andTitle:@"delete"],
                                  [AMCommandButton createButtonWithImage:[UIImage imageNamed:@"help"] andTitle:@"help"],
                                  [AMCommandButton createButtonWithImage:[UIImage imageNamed:@"settings"] andTitle:@"settings"]]
                       forGroup:@"TestGroup"];
    
    [AMCommandMaster addButtons:@[
                                  [AMCommandButton createButtonWithImage:[UIImage imageNamed:@"help"] andTitle:@"help"],
                                  [AMCommandButton createButtonWithImage:[UIImage imageNamed:@"settings"] andTitle:@"settings"]]
                       forGroup:@"TestGroup2"];
    [AMCommandMaster addToView:paraViewerViewController.view andLoadGroup:@"TestGroup"];
    [AMCommandMaster setDelegate:(id)paraViewerViewController];
    
    
    paraViewerViewController = [[UINavigationController alloc] initWithRootViewController:paraViewerViewController];
    IIViewDeckController *deckController = [[IIViewDeckController alloc] initWithCenterViewController:paraViewerViewController];
    [deckController setPanningMode:IIViewDeckNoPanning];
    
//    leftSideController.constrainedSize = 100;
//    deckController.leftSize = 100;
//    deckController.rightSize= 100;
    
//    deckController.leftController=nil;
//    deckController.rightController=nil;

//    [deckController toggleLeftViewAnimated:YES];
    return deckController;
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
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
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
