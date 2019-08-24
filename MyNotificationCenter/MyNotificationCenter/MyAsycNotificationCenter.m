//
//  MyAsycNotificationCenter.m
//  MyNotificationCenter
//
//  Created by huixiubao on 8/11/19.
//  Copyright © 2019 huixiubao. All rights reserved.
//

#import "MyAsycNotificationCenter.h"
#import <objc/message.h>

@interface ASyncNotification : NSObject
@property(nonatomic, retain)id observer;
@property(nonatomic, assign)SEL selector;
@end;

@implementation ASyncNotification
@synthesize observer;
@synthesize selector;
@end

@interface MyAsycNotificationCenter()
@property(nonatomic, retain) NSMutableDictionary* postDic;  // <postname, observers>
@end

@implementation MyAsycNotificationCenter
@synthesize postDic;

+ (instancetype)share {
    static MyAsycNotificationCenter* instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MyAsycNotificationCenter alloc] init];
    });
    return instance;
}
- (void)addObserver:(id)anObserver selector:(SEL)aSelector name:(NSString *)name object:(id)anObject {
    @synchronized (self) {
        if (!self.postDic) {
            self.postDic = [[NSMutableDictionary alloc] init];
        }
        ASyncNotification* asyncObj = [[ASyncNotification alloc] init];
        asyncObj.observer = anObserver;
        asyncObj.selector = aSelector;
        
        if (![self.postDic.allKeys containsObject:name]) {
            NSMutableArray* postlist = [[NSMutableArray alloc] init];
            [postlist addObject:asyncObj];
            [self.postDic setObject:postlist forKey:name];
        }else {
            [[self.postDic objectForKey:name] addObject:asyncObj];
        }
    }
    return;
}
- (void)postNotificationName:(NSString *)aName object:(id)anObject {
    if (![[postDic allKeys] containsObject:aName]) {
        return;
    }
    
    NSMutableArray* postList = [postDic objectForKey:aName];
    for (int i = 0; i< postList.count; i++) {
        // async perform selector
        dispatch_async(dispatch_get_main_queue(), ^{
            ASyncNotification* aSyncObj = [postList objectAtIndex:i];
            SEL method = aSyncObj.selector;
            if ([aSyncObj.observer respondsToSelector:method] && method) {
                [aSyncObj.observer performSelector:method withObject:nil afterDelay:0];
            }
        });
    }
    return;
}
- (void)removeObserver:(id)observer postName:(NSString *)aName {
    if (![self.postDic.allKeys containsObject:aName]) {
        return;
    }

    NSMutableArray* postList = [postDic objectForKey:aName];
    [postList enumerateObjectsUsingBlock:^(ASyncNotification* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.observer isEqual:observer]) {
            [postList removeObject:obj];
        }
    }];
    return;
}
@end
