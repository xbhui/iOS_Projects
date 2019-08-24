//
//  ArchiveTool.h
//  DemoOC
//
//  Created by huixiubao on 8/11/19.
//  Copyright © 2019 huixiubao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ArchiveTool : NSObject
+ (BOOL)archiveObject:(id)object prefix:(NSString *)prefix;
+ (id)unarchiveClass:(Class)class prefix:(NSString *)prefix;
+ (NSString *)getPathWithPrefix:(NSString *)prefix;
@end

NS_ASSUME_NONNULL_END
