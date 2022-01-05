//
//  BPMixMediaView.m
//  BeiPaiVideoEditor
//
//  Created by yehot on 2019/7/23.
//  Copyright © 2019 Xin Hua Zhi Yun. All rights reserved.
//

#import "BPMixMediaView.h"

#import "BPFileUtil.h"

@interface BPMixMediaView ()

@property (nonatomic, copy, readwrite) NSString *mediaUrl;
@property (nonatomic, strong, readwrite) BPMixMediaSource *mdeiaSource;

@end

@implementation BPMixMediaView

- (instancetype)initWithSource:(BPMixMediaSource *)source {
    self = [super init];
    if (self) {
        [self defaultConfig];
        self.mdeiaSource = source;
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self defaultConfig];
    }
    return self;
}

- (void)defaultConfig {
    self.mType = Mix_MediaView;
    self.mdeiaSource = [[BPMixMediaSource alloc] init];
    self.cutStartTs = 0;
    self.cutEndTs = -1;
    self.mediaDuration = 0;
    self.attachTime = 0;
    self.isTailVideo = NO;
    self.volume = 1.0;
    self.volumeFadeInDuration = 0;
    self.volumeFadeOutDuration = 0;
    self.videoFadeInDuration = 0;
    self.videoFadeOutDuration = 0;
    self.scaleType = @"Normal";
    
    self.filters = [NSMutableArray array];
    self.crop = [[BPMixCrop alloc] init];
}

#pragma mark - public

- (BOOL)hadBeautifyFaceFilter {
    if (self.filters.count) {
        for (BPMixFilter* filter in self.filters) {
            if ([filter isKindOfBeautifyFaceFilter]) {
                return YES;
            }
        }
    }
    return NO;
}

- (void)removeBeautifyFaceFilter {
    if (self.filters.count) {
        for (BPMixFilter* filter in self.filters) {
            if ([filter isKindOfBeautifyFaceFilter]) {
                [self.filters removeObject:filter];
            }
        }
    }
}

- (void)addBeautifyFaceFilter {
    if ([self hadBeautifyFaceFilter]) { // 只能添加一层 美颜滤镜
        return;
    }
    BPMixFilter* filter = [[BPMixFilter alloc] init];
    filter.name = [BPMixFilter glslNameWithType:BPMixFilterType_Beautify];
    [self.filters addObject:filter];
}

- (long)cutDuration {
    long duration = 0;
    if (self.cutEndTs == -1) {
        self.cutEndTs = self.mediaDuration;
    }
    duration = self.cutEndTs - self.cutStartTs;
    
    if (duration < 0) { // 异常处理？
        duration = 0;
    }
    return duration;
}

- (NSString *)formatedCutDuration {
    return [NSString stringWithFormat:@"%0.1fs", self.cutDuration / 1000.0];
}

#pragma mark - getter

- (NSString *)mediaUrl {
    return self.mdeiaSource.absoluteFilePath;
}

#pragma mark - MJExtension

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"filters" : [BPMixFilter class]
             };
}

/// 忽略以下字段，不做 model 转 json
+ (NSArray *)mj_ignoredPropertyNames {
    // 父类的要忽略的属性，也需要子类再声明一次
    return @[@"mType"];
}

#pragma mark - <NSCopying>

- (id)copyWithZone:(NSZone *)zone
{
    BPMixMediaView *model = [super copyWithZone:zone];
    model.mdeiaSource = [self.mdeiaSource copyWithZone:zone];

    model.cutStartTs = self.cutStartTs;
    model.cutEndTs = self.cutEndTs;
    model.mediaDuration = self.mediaDuration;
    model.mediaUrl = [self.mediaUrl copy];
    model.attachTime = self.attachTime;
    model.crop = [self.crop copyWithZone:zone];
    model.isTailVideo = self.isTailVideo;
    model.rotation = self.rotation;
    model.layout = [self.layout copyWithZone:zone];
    
    model.volume = self.volume;
    model.volumeFadeInDuration = self.volumeFadeInDuration;
    model.volumeFadeOutDuration = self.volumeFadeOutDuration;
    model.videoFadeInDuration = self.videoFadeInDuration;
    model.videoFadeOutDuration = self.videoFadeOutDuration;
    model.scaleType = [self.scaleType copy];
    
    model.filters = [[NSMutableArray alloc] initWithArray:self.filters copyItems:YES];
//    for (BPMixFilter* filter in self.filters) {
//        BPMixFilter* f = [filter copyWithZone:zone];
//        [model.filters addObject:f];
//    }

    return model;
}

@end
