//
//  MyAsycNotificationCenter.h
//  MyNotificationCenter
//
//  Created by huixiubao on 8/11/19.
//  Copyright © 2019 huixiubao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyAsycNotificationCenter : NSObject
+ (instancetype)share;
- (void)addObserver:(id)observer selector:(SEL)aSelector name:(NSString *)name object:(id)anObject;
- (void)postNotificationName:(NSString *)aName object:(id)anObject;
- (void)removeObserver:(id)observer postName:(NSString *)name;
@end

NS_ASSUME_NONNULL_END
