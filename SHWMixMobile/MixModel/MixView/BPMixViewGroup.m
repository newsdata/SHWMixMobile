//
//  BPMixViewGroup.m
//  BeiPaiVideoEditor
//
//  Created by yehot on 2019/7/23.
//  Copyright © 2019 Xin Hua Zhi Yun. All rights reserved.
//

#import "BPMixViewGroup.h"
#import "NSMutableArray+BPSafe.h"
#import "BPLogger.h"

@implementation BPMixViewGroup

- (instancetype)init {
    self = [super init];
    if (self) {
        self.mType = Mix_Group;
        self.views = [NSMutableArray array];
    }
    return self;
}

#pragma mark - public

// 删除后，前后的转场都删除
- (void)deleteItemAtIndex:(NSInteger)index {
    [self.views bp_removeObjectAtIndex:index];
    
    if ([self isTransitonOfIndex:index]) { // 如果删除后，当前位置是转场，也删除
        [self.views bp_removeObjectAtIndex:index];
    }
    NSInteger lastIndex = index - 1;
    if ([self isTransitonOfIndex:lastIndex]) { // 如果删除位置的前一个位置是转场，也删除
        [self.views bp_removeObjectAtIndex:lastIndex];
    }
}

- (void)insertVidoe:(BPMixView *)model atIndex:(NSInteger)index {
    if (!model) {
        DDLogError(@"insert empty video");
        return;
    }
    [self.views bp_insertObject:model atIndex:index];
}

/// 是否最后一个片段是片尾类型
- (BOOL)hasTailVideo {
    if ([self.views.lastObject isKindOfClass:[BPMixMediaView class]]) {
        BPMixMediaView* video = self.views.lastObject;
        if (video.isTailVideo) {
            return YES;
        }
    }
    return NO;
}

// 已经有片尾，替换，没有片尾，追加
- (void)appendOrUpdateTailVideo:(BPMixView *)model {
    if (!model) {
        return;
    }
    
    if ([self.views.lastObject isKindOfClass:[BPMixMediaView class]]) {
        BPMixMediaView* lastVideo = self.views.lastObject;
        if (lastVideo.isTailVideo) { // 已经有片尾，替换，
            [self.views replaceObjectAtIndex:(self.views.count - 1) withObject:model];
        } else { // 没有片尾，追加
            [self.views addObject:model];
        }
    }
}

- (int)getMediaViewTypeCount {
    int count = (int)self.views.count;
    
    for (BPMixView *view in self.views) {
        if (view.mType == Mix_Transition) {
            count--; // 不计算转场
        }
    }
    return count;
}

#pragma mark - private

/// 判断当前 index 是否是转场
- (BOOL)isTransitonOfIndex:(NSInteger)index {
    BPMixView* view = [self.views bp_objectAtIndex:index];
    if (!view) {
        return NO;
    }
    if (view.mType == Mix_Transition) {
        return YES;
    }
    return NO;
}

#pragma mark - getter

- (NSMutableArray<BPMixView *> *)views {
    if (!_views) {
        _views = [NSMutableArray array];
    }
    return _views;
}

#pragma mark - MJExtension

//+ (NSArray *)mj_ignoredPropertyNames {
//    // 父类里忽略的属性，也需要子类再声明一次
//    return @[];
//}

#pragma mark - <NSCopying>

- (id)copyWithZone:(NSZone *)zone
{
    BPMixViewGroup *model = [super copyWithZone:zone];
    model.views = [[NSMutableArray alloc] initWithArray:self.views copyItems:YES];
    return model;
}

@end
