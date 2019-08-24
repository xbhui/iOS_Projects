//
//  ViewControllerA.m
//  MyNotificationCenter
//
//  Created by huixiubao on 8/8/19.
//  Copyright © 2019 huixiubao. All rights reserved.
//

#import "EventAViewController.h"
#import "MyNotificationCenter.h"
#import <UserNotifications/UserNotifications.h>
#import "MyAsycNotificationCenter.h"

@interface EventAViewController ()
@property(nonatomic, assign)Boolean switcher;
@property(nonatomic, retain)UIButton* actionBtn;
@end

@implementation EventAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.switcher = true;
    // Do any additional setup after loading the view.
    
    [[MyAsycNotificationCenter share] addObserver:self selector:@selector(asyncObserverAction) name:@"Event1" object:self];
    
    
/*
    __weak typeof(self) weakSelf = self;
    [[MyNotificationCenter share] addObserver:self postName:@"Event1" block:^(NSString * name) {
        NSLog(@"ViewControllerA  received %@", name);
        [weakSelf sendLocalNotification:name];
    }];
*/
    self.actionBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.actionBtn.frame = CGRectMake(0, 0, self.view.bounds.size.width/2, 80);
    self.actionBtn.center = self.view.center;
    [self.actionBtn setTitle:@"remove Observer" forState:UIControlStateNormal];
    [self.actionBtn setTitle:@"Observer been removed" forState:UIControlStateHighlighted];
    self.actionBtn.backgroundColor = [UIColor yellowColor];
    [self.actionBtn addTarget:self action:@selector(observerAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.actionBtn];
}

- (void)observerAction:(UIButton *)btn {
    self.switcher = !self.switcher;
    if (self.switcher == false) {
        [self.actionBtn setTitle:@"add Observer" forState:UIControlStateNormal];
        [self.actionBtn setTitle:@"Observer been added" forState:UIControlStateHighlighted];
        [[MyNotificationCenter share] removeObserver:self postName:@"Event1"];
    }else {
        [[MyNotificationCenter share] addObserver:self postName:@"Event1" block:^(NSString * name) {
            NSLog(@"ViewControllerA %@", name);
        }];
        [self.actionBtn setTitle:@"remove Observer" forState:UIControlStateNormal];
        [self.actionBtn setTitle:@"Observer been removed" forState:UIControlStateHighlighted];
    }
}
- (void)asyncObserverAction{
    NSLog(@"Event1 AsyncObserverAction callback.");
}
- (void)sendLocalNotification:(NSString* )name {
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        content.title = [NSString localizedUserNotificationStringForKey:name arguments:nil];
        content.body = [NSString localizedUserNotificationStringForKey:[NSString stringWithFormat:@"detail-%d",arc4random()%100] arguments:nil];
    
        content.sound = [UNNotificationSound defaultSound];
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"OXNotification" content:content trigger:nil];
    
        [ [UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError *_Nullable error) {
            NSLog(@"local push add success");
        }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
