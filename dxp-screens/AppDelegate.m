//
//  AppDelegate.m
//  dxp-screens
//
//  Created by Dimple Koticha on 2016-02-04.
//  Copyright © 2016 Liferay. All rights reserved.
//

#import "AppDelegate.h"
#import "LRPushNotificationsDeviceService_v62.h"

@interface AppDelegate () <UISplitViewControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSLog(@"DidFinishLaunchingWithOptions");
    
    [self registerForPushNotifications:application];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)registerForPushNotifications:(UIApplication *)application {
    
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    //UIUserNotificationSettings stores settings for the type of notification app will use
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
}


//Delegate method letting you know what notification settings the user has given permissions for
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
   
    //If the user registered for at least one type of notification
    if (notificationSettings.types != UIUserNotificationTypeNone) {
         [application registerForRemoteNotifications];
    }
  else {
    // same as response to didFailToRegisterForRemoteNotificationsWithError
    NSDictionary* data = [NSDictionary dictionaryWithObject:@"" forKey:@"deviceToken"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationsRegistered" object:self userInfo:data];
  }
}

//Tells the delegate that the app successfully registered with Apple Push Notification service (APNs)
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    
    //Code I swiped to convert NSData to NSString
    const unsigned *tokenBytes = [deviceToken bytes];
    NSString *hexToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                          ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                          ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    NSLog(hexToken);
    
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    NSLog(@"Failed to Register for Remote Notifications Error: %@", error);

    
}


@end
