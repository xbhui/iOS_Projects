//
//  MyNotificationCenter.m
//  MyNotificationCenter
//
//  Created by huixiubao on 8/8/19.
//  Copyright © 2019 huixiubao. All rights reserved.
//

#import "MyNotificationCenter.h"

@interface MyNotificationObject: NSObject
@property(nonatomic, retain)id target;
@property(nonatomic, copy)void (^callback)(NSString *name);
@end

@implementation MyNotificationObject

@end

@interface MyNotificationCenter()
@property(nonatomic, retain)NSMutableDictionary* postList;
@end

@implementation MyNotificationCenter
@synthesize postList;
static MyNotificationCenter* share;
+ (instancetype)share;{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (share == nil) {
            share = [[MyNotificationCenter alloc] init];
        }
    });
    return share;
}
- (void)addObserver:(id)observer postName:(NSString *)name block:(void(^)(NSString*))block {
    if (postList == NULL) {
        postList = [[NSMutableDictionary alloc] init];
    }
    
    if (![name isKindOfClass:[NSString class]]) {
        NSLog(@"[Error][MyNotificationCenter][addObserver] name should be String.");
        return;
    }
    if (name.length <= 0) {
        NSLog(@"[Error][MyNotificationCenter][addObserver] length of name should bigger than 0.");
        return;
    }
    
    MyNotificationObject* obj = [[MyNotificationObject alloc] init];
    obj.target = observer;
    obj.callback = block;
    if ([[postList allKeys] containsObject:name]) {
        [[postList objectForKey:name] addObject:obj];
    }else {
        NSMutableArray* objList = [[NSMutableArray alloc] init];
        [objList addObject:obj];
        [postList setObject:objList forKey:name];
    }
    return;
}

- (void)postNotification:(NSString *)name {
    if (![name isKindOfClass:[NSString class]]) {
        NSLog(@"[Error][MyNotificationCenter][postNotification] name should be String.");
        return;
    }
    if (![postList isKindOfClass:[NSMutableDictionary class]]) {
        NSLog(@"[Error][MyNotificationCenter][postNotification] postList didn't be initialized.");
        return;
    }
    if (![[postList allKeys] containsObject:name]) {
        NSLog(@"[MyNotificationCenter][postNotification] the post already exists.");
        return;
    }
    if (![[postList objectForKey:name] isKindOfClass:[NSMutableArray class]]) {
        NSLog(@"[MyNotificationCenter][postNotification] no one register the post now.");
        return;
    }
    NSMutableArray* objList = [postList objectForKey:name];
    for (int i = 0; i< [objList count]; i++) {
        if (![[objList objectAtIndex:i] isKindOfClass:[MyNotificationObject class]]) {
            NSLog(@"[Error][MyNotificationCenter][postNotification] obj not the same type with MyNotificationObject");
            return;
        }
        MyNotificationObject* obj = [objList objectAtIndex:i];
        if (obj.callback != NULL) {
            obj.callback(name);
        }
    }
    return;
}

- (void)removeObserver:(id)observer postName:(NSString *)name{

    if (![postList isKindOfClass:[NSMutableDictionary class]]) {
        NSLog(@"[Error][MyNotificationCenter][removeObserver] postList didn't be initialized.");
        return;
    }
    if (![postList.allKeys containsObject:name]) {
        NSLog(@"[MyNotificationCenter][postNotification] the post %@ doesn't exists.", name);
        return;
    }
    NSMutableArray* objList = [postList objectForKey:name];
    NSUInteger objIdx = -1;
    for (int i = 0; i< [objList count]; i++) {
        if (![[objList objectAtIndex:i] isKindOfClass:[MyNotificationObject class]]) {
            NSLog(@"[Error][MyNotificationCenter][removeObserver] obj not the same type with MyNotificationObject.");
            return;
        }
        MyNotificationObject* obj = [objList objectAtIndex:i];
        if ([obj.target isEqual:observer]) {
            objIdx = i;
        }
    }
    if (objIdx < 0) {
        NSLog(@"[MyNotificationCenter][postNotification] the observer doesn't exists.");
        return;
    }
    [[postList objectForKey:name] removeObjectAtIndex:objIdx];
    return;
}
@end
