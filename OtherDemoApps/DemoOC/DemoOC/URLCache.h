//
//  URLCache.h
//  DemoOC
//
//  Created by huixiubao on 8/8/19.
//  Copyright © 2019 huixiubao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface URLCache : NSObject<NSCoding>
- (instancetype)init:(NSInteger)capacity;
- (NSInteger)get:(NSString *)key;
- (void)put:(NSString *)key value:(NSInteger)value;
- (void)printCache;
- (NSString *)description;
@end

NS_ASSUME_NONNULL_END
