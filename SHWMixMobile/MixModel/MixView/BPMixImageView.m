//
//  BPMixImageView.m
//  BeiPaiVideoEditor
//
//  Created by yehot on 2019/7/23.
//  Copyright © 2019 Xin Hua Zhi Yun. All rights reserved.
//

#import "BPMixImageView.h"

@implementation BPMixImageView

- (instancetype)initWithSource:(BPMixMediaSource *)source {
    self = [super initWithSource:source];
    if (self) {
        self.mType = Mix_Picture;
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.mType = Mix_Picture;
    }
    return self;
}

- (void)addDefaultZoomEffectWithDuration:(int)duration {
    BPMixFilter* filter = [[BPMixFilter alloc] init];
    filter.name = [BPMixFilter glslNameWithType:BPMixFilterType_ZoomIn];
    filter.optionStr = [NSString stringWithFormat:@"duration=%d", duration];
    [self.filters addObject:filter];
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
    BPMixImageView *model = [super copyWithZone:zone];
    return model;
}

@end
