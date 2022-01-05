//
//  BPMixTransitionView.m
//  BeiPaiVideoEditor
//
//  Created by yehot on 2019/7/23.
//  Copyright © 2019 Xin Hua Zhi Yun. All rights reserved.
//

#import "BPMixTransitionView.h"

@implementation BPMixTransitionView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.mType = Mix_Transition;
        self.duration = 1000;
        self.isTailVideo = NO;  // 转场不能是片尾
    }
    return self;
}

- (long)cutDuration {
    return 0;
}

#pragma mark - <NSCopying>

- (id)copyWithZone:(NSZone *)zone
{
    BPMixTransitionView *model = [super copyWithZone:zone];

    model.name = [self.name copy];
    model.duration = self.duration;
    model.options = [self.options copy];

    return model;
}

@end
