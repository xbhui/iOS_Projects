//
//  ViewController.m
//  MyNotificationCenter
//
//  Created by huixiubao on 8/8/19.
//  Copyright © 2019 huixiubao. All rights reserved.
//

#import "PostViewController.h"
#import "MyNotificationCenter.h"
#import "MyAsycNotificationCenter.h"

@interface PostViewController ()

@end

@implementation PostViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton* postBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    postBtn.frame = CGRectMake(0, 0, self.view.bounds.size.width/2, 80);
    postBtn.center = self.view.center;
    [postBtn setTitle:@"Post event here" forState:UIControlStateNormal];
    [postBtn setTitle:@"event posted!" forState:UIControlStateHighlighted];
    postBtn.backgroundColor = [UIColor orangeColor];
    [postBtn addTarget:self action:@selector(postAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:postBtn];
}
- (void)postAction:(UIButton *)btn {
    NSDictionary* info = [[NSDictionary alloc] initWithObjectsAndKeys:@"object1",@"key1", nil];
    [[MyAsycNotificationCenter share] postNotificationName:@"Event1" object:info];
    [[MyAsycNotificationCenter share] postNotificationName:@"Event2" object:info];
    
/*
    [[MyNotificationCenter share] postNotification:@"Event1"];
    [[MyNotificationCenter share] postNotification:@"Event2"];
    [[MyNotificationCenter share] postNotification:@"Event3"];
*/
}


@end
