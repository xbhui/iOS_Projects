//
//  EventViewController.m
//  Upcoming Events
//
//  Created by huixiubao on 8/23/19.
//  Copyright © 2019 huixiubao. All rights reserved.
//

#import "EventViewController.h"

@interface EventViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation EventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];

    // Do any additional setup after loading the view.
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSString* cellid = @"tableviewcellid";
    UITableViewCell * cell = cell = [tableView dequeueReusableCellWithIdentifier:cellid];;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.textLabel.text = @"Title";
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}





@end
