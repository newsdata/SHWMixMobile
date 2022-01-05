//
//  BPMixWindow+Adjust.m
//  BeiPaiVideoEditor
//
//  Created by yehot on 2019/9/22.
//  Copyright © 2019 Xin Hua Zhi Yun. All rights reserved.
//

#import "BPMixWindow+Adjust.h"
#import "NSMutableArray+BPSafe.h"
#import "BPLogger.h"

typedef NS_ENUM(NSInteger, BPQuadrantType) {
    BPQuadrantType_One          =  1,
    BPQuadrantType_Two          =  2,   // 默认在 第二象限
    BPQuadrantType_Three        =  3,
    BPQuadrantType_Four         =  4,
};

//音频字幕允许最短时长 0.5s
static NSTimeInterval MIN_DURATION = 500.f;


@implementation BPMixWindow (Adjust)

- (void)bp_adjustAttachTime {
    //获取现在的时长
    NSTimeInterval videoDuration = [self allVideoDuration];
    
    // 订正音频
    NSMutableArray<BPMixAudio *> *audios = self.audios;
    NSMutableArray<BPMixAudio *> *tmpAudios = [[NSMutableArray alloc]init]; //存储需要丢弃的音频
    [audios enumerateObjectsUsingBlock:^(BPMixAudio * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //检查音频的切出时间是否超出视频长度
        if (obj.detachTime > videoDuration) { //应处理音频的长度
            // 对音频进行裁剪
            long audioCutDuration = videoDuration - obj.attachTime;
            // 检查裁剪后的音频时间是否在最短时长范围内
            if (audioCutDuration < MIN_DURATION) { // 应该弃掉，先添加到废弃的数组
                [tmpAudios addObject:obj];
            }else{ //订正音频时长
                if (obj.type == BPAudioType_Audio) {
                    obj.cutEndTs = obj.cutStartTs + audioCutDuration;
                }
                obj.detachTime = videoDuration;
            }
        }
    }];
    
    // 弃掉视频时长之外的音频
    [tmpAudios enumerateObjectsUsingBlock:^(BPMixAudio * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [audios removeObject:obj];
    }];
    
    // 订正字幕
    NSMutableArray<__kindof BPMixView *> *views = self.attaches.views;
    NSMutableArray<BPMixSubtitleView *> *tmpSubtitles = [[NSMutableArray alloc]init];
    
    [views enumerateObjectsUsingBlock:^(__kindof BPMixView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[BPMixSubtitleView class]]) {
            BPMixSubtitleView *view = (BPMixSubtitleView *)obj;
            // 检查字幕的切出时间是否超过视频时长
            if (view.detachTime > videoDuration) {
                view.detachTime = videoDuration;
            }
            // 检查裁剪后的字幕时间是否在最短时长范围内
            if (view.detachTime - view.attachTime < MIN_DURATION) {
                [tmpSubtitles addObject:obj];
            }
        }
    }];
    
    [tmpSubtitles enumerateObjectsUsingBlock:^(BPMixSubtitleView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.attaches.views removeObject:obj];
    }];
}

- (void)bp_adjustAttachLocationWithLastSize:(CGSize)lastSize {
    if (CGSizeEqualToSize(lastSize, CGSizeZero)) {
        // last size 为 0 时，不需要校正
        return;
    }
    for (BPMixView *view in self.attaches.views) {
        if (view.mType == Mix_Subtitle) { // 字幕
            [self bp_adjustSubtitleLocation:(BPMixSubtitleView *)view lastSize:lastSize];
        } else if (view.mType == Mix_Picture) { // 贴图
            [self bp_adjustLogoLocation:(BPMixImageView *)view];
        }
    }
}

- (BPMixWindow *)bp_copyAndFilterWithSelectedView:(BPMixView *)mixView {
    // 分割页面，只播放一个片段，且移除全部的贴图、字幕、音乐
    BPMixWindow *window = [self copy];
    [window.attaches.views removeAllObjects]; //移除字幕、贴图
    [window.audios removeAllObjects];   // 移除音乐
    BPMixView* video = [mixView copy];
    [window.video.views removeAllObjects];
    [window.video.views addObject:video];
    window.startIndex = 0;
    window.endIndex = 0;   // 只有一个片段
    return window;
}


- (void)bp_adjustTranstion {
    // 校正转场数据，如果转场两边的视频小于 0.5s，需要把转场去掉
     NSInteger videoCount = self.video.views.count;
     for (int i = 0; i < videoCount; i++) {
         
         BPMixView* front = [self.video.views bp_objectAtIndex:i-1];
         BPMixView* middle = [self.video.views bp_objectAtIndex:i];
         BPMixView* back = [self.video.views bp_objectAtIndex:i+1];
         
         if (middle.mType == Mix_Transition && [front isMixMediaViewType] && [back isMixMediaViewType]) {
             BPMixMediaView* v1 = (BPMixMediaView *)front;
             BPMixMediaView* v2 = (BPMixMediaView *)back;
             if (v1.cutDuration < 500 || v2.cutDuration < 500) { // 转场左右视频不能小于 500 毫秒
                 [self.video.views removeObject:middle];
             }
         }
         
         if ([middle isMixMediaViewType] && front.mType == Mix_Transition && back.mType == Mix_Transition) { // 当前视频小于 1s 时，不能左右同时有转场
             BPMixMediaView* v = (BPMixMediaView *)middle;
             if (v.cutDuration < 1000) {
                 [self.video.views removeObject:front];
                 [self.video.views removeObject:back];
             }
         }
     }
}

#pragma mark - private

// 中心点 和 相对左上 x、y
- (BPQuadrantType)bp_quadrantWithCenter:(CGPoint)center
                                     rx:(int)rx
                                     ry:(int)ry {
    BPQuadrantType type;
    
    if (rx > center.x && ry < center.y) { // 第一象限
        type = BPQuadrantType_One;
    } else if (rx < center.x && ry < center.y) { // 第二象限
        type = BPQuadrantType_Two;
    } else if (rx < center.x && ry > center.y) { // 第三象限
        type = BPQuadrantType_Three;
    } else  { // if (rx > center.x && ry > center.y) { // 第四象限
        type = BPQuadrantType_Four;
    }
    return type;
}

- (void)bp_adjustSubtitleLocation:(BPMixSubtitleView *)model
                         lastSize:(CGSize)lastSize {
    // 切换画幅前的中心点，判断出在第几象限
    CGPoint lastCenter = CGPointMake(lastSize.width / 2, lastSize.height / 2);
    
    BPQuadrantType qType = [self bp_quadrantWithCenter:lastCenter rx:model.layout.rx ry:model.layout.ry];
    
    // 一、四象限，需要 移动 x ( right padding 保持不变)
    if (qType == BPQuadrantType_One || qType == BPQuadrantType_Four) {
        if (self.config.width < lastSize.width) {
            int rightPadding = lastSize.width - model.layout.rx - model.layout.width;
            model.layout.rx = self.config.width - rightPadding - model.layout.width;
        }
    }
    // 三、四象限，需要移动 y (bottom padding 保持不变)
    if (qType == BPQuadrantType_Three || qType == BPQuadrantType_Four) {
        int bottomPadding = lastSize.height - model.layout.ry - model.layout.height;
        model.layout.ry = self.config.height - bottomPadding - model.layout.height;
    }
    
    if (model.layout.rx < 0) {
        model.layout.rx = 0;
    }
    if (model.layout.ry < 0) {
        model.layout.ry = 0;
    }
//    model.layout.position = (int)qType;
}

- (void)bp_adjustLogoLocation:(BPMixImageView *)model {
    CGPoint center = CGPointMake(self.config.width / 2, self.config.height / 2);

    // logo 默认的 padding 是 40，这里需要和 BPEditStickerMenuView 里定义的一致
    int padding = 40;
    
    // logo 目前只有 1、3、5、7、9 这 5个位置
    if (model.layout.ios_Position == 1) { // 左上对齐
        model.layout.rx = padding;
        model.layout.ry = padding;
    } else if (model.layout.ios_Position == 3) { // 右上对齐
        model.layout.rx = self.config.width - padding - model.layout.width;
        model.layout.ry = padding;
    } else if (model.layout.ios_Position == 5) {    // 中间对齐
        model.layout.rx = center.x - model.layout.width / 2;
        model.layout.ry = center.y - model.layout.height / 2;
    } else if (model.layout.ios_Position == 7) {    // 左下对齐
        model.layout.rx = padding;
        model.layout.ry = self.config.height - padding - model.layout.height;
    } else if (model.layout.ios_Position == 9) {    // 右下对齐
        model.layout.rx = self.config.width - padding - model.layout.width;
        model.layout.ry = self.config.height - padding - model.layout.height;
    } else {
        DDLogError(@"unknow logo position type");
    }
    
}

@end
