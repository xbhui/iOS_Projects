//
//  ViewController.m
//  TimerDemo
//
//  Created by huixiubao on 8/20/19.
//  Copyright © 2019 huixiubao. All rights reserved.
//

#import "ViewController.h"
#import "CellEntity.h"

#define NumberOfCells 50
#define InitailCellNum 0
#define initailCellStatus 0
@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(atomic, retain) UITableView* tableview;
@property(atomic, retain) NSMutableArray* cellEntities;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
    [self initDataSource];
    [self runTimer];
}

- (void)initTableView {
    self.tableview = [[UITableView alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.view addSubview:self.tableview];
}

- (void)initDataSource {
    self.cellEntities = [[NSMutableArray alloc] init];
    for (int i=0; i< NumberOfCells; i++) {
        CellEntity* entity = [[CellEntity alloc] init];
        entity.num = InitailCellNum;
        entity.status = initailCellStatus;
        [self.cellEntities addObject:entity];
    }
}
/**
 * @brief The timer for update the number in the cell which in the visible rows.
 *
 */
- (void)runTimer {
    __weak typeof(ViewController)* weakSelf = self;
    [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSArray* indexs = [weakSelf.tableview indexPathsForVisibleRows];
        for (int i=0; i< [indexs count]; i++) {
            NSIndexPath* index = [indexs objectAtIndex:i];
            UITableViewCell* cell =  [weakSelf.tableview cellForRowAtIndexPath:index];
            CellEntity* entity = weakSelf.cellEntities[index.row];
            if (!entity.status) {
                entity.num = entity.num + 1;
                cell.textLabel.text = [NSString stringWithFormat:@"%ld", entity.num];
            }
        }
    }];
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
      CellEntity* entity = self.cellEntities[indexPath.row];
      entity.status = !entity.status;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellEntities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* cellid = [NSString stringWithFormat:@"%@", @"cellIdentifier"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: cellid];
    }
    CellEntity* entity = self.cellEntities[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",entity.num];
    return cell;
}
@end
