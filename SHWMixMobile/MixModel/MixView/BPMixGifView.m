//
//  BPMixGifView.m
//  BeiPaiVideoEditor
//
//  Created by yehot on 2019/7/23.
//  Copyright © 2019 Xin Hua Zhi Yun. All rights reserved.
//

#import "BPMixGifView.h"

@implementation BPMixGifView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.mType = Mix_Gif;
    }
    return self;
}

- (instancetype)initWithSource:(BPMixMediaSource *)source {
    self = [super initWithSource:source];
    if (self) {
        self.mType = Mix_Gif;
    }
    return self;
}

#pragma mark - MJExtension

/// 忽略以下字段，不做 model 转 json
+ (NSArray *)mj_ignoredPropertyNames {
    // 父类里忽略的属性，也需要子类再声明一次
    return @[@"mediaUrl", @"mType"];
}

#pragma mark - <NSCopying>

- (id)copyWithZone:(NSZone *)zone
{
    BPMixGifView *model = [super copyWithZone:zone];
    return model;
}

@end
