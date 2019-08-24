//
//  EventEntity.h
//  Upcoming Events
//
//  Created by huixiubao on 8/23/19.
//  Copyright © 2019 huixiubao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EventEntity : NSObject
@property(nonatomic, retain)NSString* title;
@property(nonatomic, retain)NSDate* startDate;
@property(nonatomic, retain)NSDate* endDate;
@end

NS_ASSUME_NONNULL_END
