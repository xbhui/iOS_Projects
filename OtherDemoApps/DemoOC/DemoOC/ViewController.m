//
//  ViewController.m
//  DemoOC
//
//  Created by huixiubao on 8/7/19.
//  Copyright © 2019 huixiubao. All rights reserved.
//

#import "ViewController.h"
#import "URLCache.h"
#import "ArchiveTool.h"

@interface ViewController ()
@property(nonatomic, retain) UIView* subView;
@end

@implementation ViewController


- (void)loadView {
    [super loadView];
    NSLog(@"loadView");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    NSLog(@"viewWillLayoutSubviews");
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    
    
    NSLog(@"frame:x=%f, y=%f, w=%f, h=%f",self.subView.frame.origin.x, self.subView.frame.origin.y, self.subView.frame.size.width, self.subView.frame.size.height);
    
    NSLog(@"bounds:x=%f, y=%f, w=%f, h=%f", self.subView.bounds.origin.x, self.subView.bounds.origin.y, self.subView.bounds.size.width, self.subView.bounds.size.height);
    
    
    NSLog(@"viewDidLayoutSubviews");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    NSLog(@"viewDidLoad");
    self.subView = [[UIView alloc] initWithFrame:CGRectMake(80, 60, 20, 40)];
    self.subView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.subView];
    
    
    // Do any additional setup after loading the view.
    URLCache *cache = [[URLCache alloc] init:6];
    [cache put:@"1" value:10];
    [cache put:@"2" value:20];
    [cache put:@"3" value:30];
//    NSData *data  = [NSKeyedArchiver archivedDataWithRootObject:cache requiringSecureCoding:NO error:nil];
//    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"data1.txt"];
//    [data writeToFile:path atomically:YES];
//    
//    URLCache *cache1 = [NSKeyedUnarchiver unarchivedObjectOfClass:URLCache.class fromData:data error:nil]
//    
//    
    
//    if ([ArchiveTool archiveObject:cache prefix:NSStringFromClass(cache.class)]) {
//        NSLog(@"归档成功");
//    } else {
//        NSLog(@"归档失败");
//    }
    
//    URLCache *cache1  = [ArchiveTool unarchiveClass:cache.class prefix:NSStringFromClass(cache.class)];
//    [cache1 printCache];
    //  archive
    

//    [cache printCache];
//    [cache put:@"2" value:20];
//    [cache put:@"4" value:40];
//    [cache put:@"5" value:50];
//    [cache put:@"6" value:60];
//    [cache put:@"7" value:70];
//    [cache printCache];
  //  NSLog(@"%ld", [cache get:@"6"]);
}


@end
