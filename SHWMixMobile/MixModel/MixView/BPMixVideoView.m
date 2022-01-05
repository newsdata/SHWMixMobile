//
//  BPMixVideoView.m
//  BeiPaiVideoEditor
//
//  Created by yehot on 2019/7/23.
//  Copyright © 2019 Xin Hua Zhi Yun. All rights reserved.
//

#import "BPMixVideoView.h"

@implementation BPMixVideoView

- (instancetype)initWithSource:(BPMixMediaSource *)source {
    self = [super initWithSource:source];
    if (self) {
        self.mType = Mix_Video;
        
        self.speed = 1.0;
        self.rmSound = NO;
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.mType = Mix_Video;
        
        self.speed = 1.0;
        self.rmSound = NO;
    }
    return self;
}

- (long)cutDuration {
    long duration = 0;
    if (self.cutEndTs == -1) {
        self.cutEndTs = self.mediaDuration;
    }
    duration = (self.cutEndTs - self.cutStartTs) / self.speed;
    
    if (duration < 0) { // 异常处理？
        duration = 0;
    }
    return duration;
}

#pragma mark - MJExtension

/// 忽略以下字段，不做 model 转 json
+ (NSArray *)mj_ignoredPropertyNames {
    // 父类里忽略的属性，也需要子类再声明一次
    return @[@"coverImage", @"mediaUrl", @"mType"];
}

#pragma mark - <NSCopying>

- (id)copyWithZone:(NSZone *)zone
{
    BPMixVideoView *model = [super copyWithZone:zone];
    
    model.rmSound = self.rmSound;
    model.speed = self.speed;
    
    return model;
}

@end
