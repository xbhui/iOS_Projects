//
//  AppDelegate.m
//  MyNotificationCenter
//
//  Created by huixiubao on 8/8/19.
//  Copyright © 2019 huixiubao. All rights reserved.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self registerLocalNotification];
    return YES;
}
- (void)registerLocalNotification {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        if (settings.authorizationStatus == UNAuthorizationStatusNotDetermined ||
            settings.authorizationStatus == UNAuthorizationStatusDenied) {
            // apply authorization
            [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge |
                                                     UNAuthorizationOptionSound |
                                                     UNAuthorizationOptionAlert )
                                  completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                      if (!error && granted) {
                                          // user allow
                                          NSLog(@"register success");
                                      } else {
                                          // user not allow
                                          NSLog(@"register failed");
                                      }
                                  }];
        }
    }];
}

#pragma mark - UNUserNotificationCenterDelegate，App in the forground
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    UNNotificationRequest *request = notification.request;
    UNNotificationContent *content = request.content;
    NSDictionary *userInfo = content.userInfo;
    NSNumber *badge = content.badge;
    NSString *body = content.body;
    UNNotificationSound *sound = content.sound;
    NSString *subtitle = content.subtitle;
    NSString *title = content.title;
    
    if ([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSLog(@"get the remove notification: %@", userInfo);
    } else {
        NSLog(@"receive the local nnotification: body:%@，title:%@, subtitle:%@, badge：%@，sound：%@， userInfo：%@",
              body, title, subtitle, badge, sound, userInfo);
    }
    // set up the presentation of the alert
    completionHandler(UNNotificationPresentationOptionBadge
                      | UNNotificationPresentationOptionSound
                      | UNNotificationPresentationOptionAlert);
}

// UNUserNotificationCenterDelegate 协议方法
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void (^)(void))completionHandler{
    completionHandler();
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
