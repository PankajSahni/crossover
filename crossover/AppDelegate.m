//
//  AppDelegate.m
//  crossover
//
//  Created by Mac on 27/02/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "GameController.h"
#import "GlobalSingleton.h"
@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //[application setStatusBarHidden:withAnimation:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    int device_height = (int)([ [ UIScreen mainScreen ] bounds ].size.height);
    //NSLog(@"device_height %d",device_height);
    switch (device_height) {
        case 480:
            [GlobalSingleton sharedManager].string_my_device_type = @"iphone";
            break;
        case 1024:
            [GlobalSingleton sharedManager].string_my_device_type = @"ipad";
            break;
        case 568:
            [GlobalSingleton sharedManager].string_my_device_type = @"iphone5";
            break;
        default:
            break;
    }
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.viewController = [[GameController alloc] initWithNibName:@"ViewController_iPhone" bundle:nil];
    } else {
        self.viewController = [[GameController alloc] initWithNibName:@"ViewController_iPad" bundle:nil];
    }
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}


/*-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window

{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return UIInterfaceOrientationMaskAll;
    else   iphone
        return UIInterfaceOrientationMaskAllButUpsideDown;
} */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if ( application.applicationState == UIApplicationStateActive ){
        
    }
        // app was already in the foreground
    else{
        [_viewController getBoard];
    }
            // app was just brought from background to foreground
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    if ([GlobalSingleton sharedManager].animation_in_progress) {
        if ([GlobalSingleton sharedManager].save_game) {
            [self saveGameState:[GlobalSingleton sharedManager].save_game];
        }
    }
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}
-(void)saveGameState:(NSDictionary *)opposition_turn{
    
    int move = [[opposition_turn objectForKey:@"move"] intValue];
    int newposition = [[opposition_turn objectForKey:@"newposition"] intValue];
    int captured = 0;
    if ([opposition_turn objectForKey:@"captured"]) {
        captured = [[opposition_turn objectForKey:@"captured"] intValue];
    }
    NSString *opposite_player;
    if ([GlobalSingleton sharedManager].GC) {
        if ([GlobalSingleton sharedManager].isPlayer1) {
            opposite_player = @"2";
        }else{
            
            opposite_player = @"1";
        }
    }
        [[GlobalSingleton sharedManager].array_initial_player_positions
                          replaceObjectAtIndex:move withObject:@"0"];
        [[GlobalSingleton sharedManager].array_initial_player_positions
                          replaceObjectAtIndex:newposition withObject:opposite_player];
                         if (captured) {
                             [[GlobalSingleton sharedManager].array_initial_player_positions
                              replaceObjectAtIndex:captured withObject:@"0"];
                         }
    
}
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [_viewController getBoard];
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
