//
//  BPMixAudio.m
//  BeiPaiVideoEditor
//
//  Created by yehot on 2019/7/22.
//  Copyright © 2019 Xin Hua Zhi Yun. All rights reserved.
//

#import "BPMixAudio.h"
//#import "BPVideoFileHandler.h"
#import <MJExtension/MJExtension.h>

@interface BPMixAudio ()

@property (nonatomic, copy, readwrite) NSString* mediaUrl;

@end


@implementation BPMixAudio

- (instancetype)init {
    self = [super init];
    if (self) {
        self.cutStartTs = 0;
        self.cutEndTs = -1;
        self.mediaDuration = 0;
        self.repeat = NO;
        self.mute = NO;
        self.speed = 1;
        self.volume = 1.0;
        self.attachTime = 0;
        self.detachTime = -1;
        self.volumeFadeInDuration = 0;
        self.volumeFadeOutDuration = 0;
    }
    return self;
}

#pragma mark - public

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

- (void)setFadeIn:(BOOL)fadeIn
{
    if (fadeIn) {
        self.volumeFadeInDuration = 1000;
    }else{
        self.volumeFadeInDuration = 0.0;
    }
}

- (void)setFadeOut:(BOOL)fadeOut
{
    if (fadeOut) {
        self.volumeFadeOutDuration = 1000;
    }else{
        self.volumeFadeOutDuration = 0.0;
    }
}

#pragma mark - getter

- (NSString *)mediaUrl {
    if (!_mediaUrl) {
//        _mediaUrl = [BPVideoFileHandler videoFilePathWithName:self.fileName];
    }
    return _mediaUrl;
}

#pragma mark - MJExtension

// 忽略以下字段，不做 model 转 json
+ (NSArray *)mj_ignoredPropertyNames {
    // 父类里忽略的属性，也需要子类再声明一次
    return @[@"mediaUrl"];
}

#pragma mark - <NSCopying>

- (id)copyWithZone:(NSZone *)zone
{
    BPMixAudio *model = [[[self class] allocWithZone:zone] init];
    model.name = [self.name copy];
    model.cutStartTs = self.cutStartTs;
    model.cutEndTs = self.cutEndTs;
    model.mediaDuration = self.mediaDuration;
//    model.mediaUrl = [self.mediaUrl copy];
    model.fileName = [self.fileName copy];
    model.repeat = self.repeat;
    model.mute = self.mute;
    model.speed = self.speed;
    model.volume = self.volume;
    model.attachTime = self.attachTime;
    model.detachTime = self.detachTime;
    model.volumeFadeInDuration = self.volumeFadeInDuration;
    model.volumeFadeOutDuration = self.volumeFadeOutDuration;
    model.effect = [self.effect copy];
    model.type = self.type;
    model.width = self.width;
    
    return model;
}

@end
