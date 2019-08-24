//
//  MyNotificationCenter.h
//  MyNotificationCenter
//
//  Created by huixiubao on 8/8/19.
//  Copyright © 2019 huixiubao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyNotificationCenter : NSObject
+ (instancetype)share;
- (void)addObserver:(id)observer postName:(NSString *)name block:(void(^)(NSString*))callback;
- (void)postNotification:(NSString *)name;
- (void)removeObserver:(id)observer postName:(NSString *)name;
@end

NS_ASSUME_NONNULL_END
