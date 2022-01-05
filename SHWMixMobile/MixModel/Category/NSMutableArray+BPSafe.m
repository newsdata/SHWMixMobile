//
//  NSMutableArray+BPSafe.m
//  BeiPaiVideoEditor
//
//  Created by yehot on 2019/8/30.
//  Copyright © 2019 Xin Hua Zhi Yun. All rights reserved.
//

#import "NSMutableArray+BPSafe.h"
#import "BPLogger.h"

@implementation NSMutableArray (BPSafe)

- (void)bp_addObject:(nonnull id)object {
    if (!object) {
        DDLogError(@"bp array index error");
        return;
    }
    [self addObject:object];
}

- (id)bp_objectAtIndex:(NSUInteger)index {
    if (index >= self.count) {
        DDLogError(@"bp array index error");
        return nil;
    }
    return [self objectAtIndex:index];
}

- (NSInteger)bp_indexOfObject:(id)obj {
    if (!obj) {
        return NSNotFound;
    }
    return [self indexOfObject:obj];
}

- (void)bp_removeObjectAtIndex:(NSUInteger)index {
    if (index >= self.count) {
        DDLogError(@"bp array index error");
        return;
    }
    [self removeObjectAtIndex:index];
}

- (void)bp_removeObject:(id)obj {
    if (!obj) {
        DDLogError(@"bp array index error");
        return;
    }
    [self removeObject:obj];
}

- (void)bp_insertObject:(id)anObject atIndex:(NSUInteger)index {
    if (index > self.count + 1) {
        DDLogError(@"bp array index error");
        return;
    }
    [self insertObject:anObject atIndex:index];
}

@end
