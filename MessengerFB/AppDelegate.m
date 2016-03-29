//
//  AppDelegate.m
//  MessengerFB
//
//  Created by iMac309 on 24.03.16.
//  Copyright (c) 2016 Antonpetrovmak. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        UINavigationController *usersNavigationController = [storyboard instantiateViewControllerWithIdentifier:@"UsersNavigationController"];
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.rootViewController = usersNavigationController;
        [self.window makeKeyAndVisible];
    } else {
        [[FBSDKApplicationDelegate sharedInstance] application:application
                                 didFinishLaunchingWithOptions:launchOptions];
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {

}

- (void)applicationWillEnterForeground:(UIApplication *)application {

}

- (void)applicationDidBecomeActive:(UIApplication *)application {

}

- (void)applicationWillTerminate:(UIApplication *)application {

}

@end
