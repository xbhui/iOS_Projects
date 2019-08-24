//
//  CellEntity.h
//  TimerDemo
//
//  Created by huixiubao on 8/20/19.
//  Copyright © 2019 huixiubao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CellEntity : NSObject
@property(nonatomic, assign) NSInteger num;    // num display on the cell
@property(nonatomic, assign) NSInteger status; //0 runing, 1 stop
@end

NS_ASSUME_NONNULL_END
