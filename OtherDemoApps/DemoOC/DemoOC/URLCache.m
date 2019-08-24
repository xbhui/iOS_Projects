//
//  URLCache.m
//  DemoOC
//
//  Created by huixiubao on 8/8/19.
//  Copyright © 2019 huixiubao. All rights reserved.
//

#import "URLCache.h"

@interface URLCache()
@end

@implementation URLCache
{
 //   NSLock *_lock;
    NSInteger _maxLimit;
    NSMutableArray* _urlArray;     // key
    NSMutableDictionary* _urlDic; // key value
}
- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    [aCoder encodeObject:@(_maxLimit) forKey:@"maxlimt"];
    [aCoder encodeObject:_urlArray forKey:@"urlarray"];
    [aCoder encodeObject:_urlDic forKey:@"urddic"];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder {
    if (self = [super init]) {
        _maxLimit = [[aDecoder decodeObjectForKey:@"maxlimt"] integerValue];
        _urlArray = [aDecoder decodeObjectForKey:@"urlarray"];
        _urlDic = [aDecoder decodeObjectForKey:@"urddic"];
       }
    return self;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (NSString *)description {
    NSString *string = [NSString stringWithFormat:@"%ld,%@,%@", _maxLimit, _urlArray, _urlDic];
    return string;
}

- (instancetype)init:(NSInteger)capacity {
    self = [super init];
    if (self) {
        _maxLimit = capacity;
        _urlArray = [[NSMutableArray alloc] initWithCapacity:capacity];
        _urlDic = [[NSMutableDictionary alloc] initWithCapacity:capacity];
    }
    return self;
}
- (NSInteger)get:(NSString *)key {
    // check exists
    @synchronized (self) {
        if (![_urlDic.allKeys containsObject:key]) {
            return -1;
        }
        
        [self moveToEnd:key];
        NSInteger value = [[_urlDic objectForKey:key] integerValue];
        return value;
    }
}

- (void)moveToEnd:(NSString *)key {
    @synchronized (self) {
        if ([_urlDic.allKeys containsObject:key]) {
            [_urlArray removeObject:key];
            [_urlArray addObject:key];
        }
    }
    return;
}
- (void)put:(NSString *)key value:(NSInteger)value {

    if (key == NULL) {
        return;
    }
    @synchronized (self) {
        if ([_urlDic.allKeys containsObject:key]) {
            // move to end
            [self moveToEnd:key];
            return;
        }
        if (_urlArray.count >= _maxLimit) {
            // remove the first
            NSString* topKey = [_urlArray objectAtIndex:0];
            [_urlDic removeObjectForKey:topKey];
            [_urlArray removeObjectAtIndex:0];
        }
        [_urlDic setObject:[NSNumber numberWithInteger:value] forKey:key];
        [_urlArray addObject:key];
    }
    return;
}
- (void)printCache {
    @synchronized (self) {
        for (int i = 0; i< _urlArray.count; i++) {
            NSLog(@"%ld", (long)[[_urlArray objectAtIndex:i] integerValue]);
        }
    }
}
@end
