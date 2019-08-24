//
//  AppDelegate.h
//  Upcoming Events
//
//  Created by huixiubao on 8/23/19.
//  Copyright © 2019 huixiubao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

