//
//  BPMixWindow.m
//  BeiPaiVideoEditor
//
//  Created by yehot on 2019/7/22.
//  Copyright © 2019 Xin Hua Zhi Yun. All rights reserved.
//

#import "BPMixWindow.h"
#import "BPMixWindow+Adjust.h"
//#import "NSDictionary+BPJson.h"
#import "MJExtension.h"
#import "BPLogger.h"

@interface BPMixWindow ()

@property (nonatomic, assign, readwrite) BPVideoMaskType videoMaskType;

@end

@implementation BPMixWindow

/// 从 json 工程文件反序列化（ 新增属性时，注意同步添加！！）
- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        NSArray* audios = dict[@"audios"];
        self.audios = [BPMixAudio mj_objectArrayWithKeyValuesArray:audios];
        
        NSDictionary* configDict = dict[@"config"];
        self.config = [BPMixConfig mj_objectWithKeyValues:configDict];
        
        NSDictionary* attDict = dict[@"attaches"];
        self.attaches = [self groupWithGroupDict:attDict];
        
        // BPMixViewGroup 里的 NSMutableArray<__kindof BPMixView *> *views 类型 MJExtension 没法处理，需要手动转换
        // self = [BPMixWindow mj_objectWithKeyValues:dict];
        NSDictionary* videoDict = dict[@"video"];
        self.video = [self groupWithGroupDict:videoDict];
        
        self.videoMaskType = [dict[@"videoMaskType"] integerValue];
    }
    return self;
}

- (instancetype)initWithVidoes:(NSArray<BPMixView *> *)videoArray
                 videoMaskType:(BPVideoMaskType)maskType {
    self = [super init];
    if (self) {
        self.config = [[BPMixConfig alloc] init];
        self.video = [[BPMixViewGroup alloc] init];
        [self.video.views addObjectsFromArray:videoArray];
        
        self.attaches = [[BPMixViewGroup alloc] init];
        self.audios = [NSMutableArray array];
        
        self.startIndex = 0;
        self.endIndex = -1;
        
        self.videoMaskType = maskType;
        
        [self updateVideoMaskType:maskType];
    }
    return self;
}

- (instancetype)initWithVidoes:(NSArray<BPMixView *> *)videoArray {
    return [self initWithVidoes:videoArray videoMaskType:BPVideoMaskType3x4];
}

#pragma mark - public

- (void)updateVideoMaskType:(BPVideoMaskType)type {
    self.videoMaskType = type;
    
    // 记录切换前的画面 宽、高
    CGSize lastSize = CGSizeMake(self.config.width, self.config.height);
    
    switch (type) {
        case BPVideoMaskType1x1: {
            self.config.width = 720;
            self.config.height = 720;
        } break;
            
        case BPVideoMaskType3x4: {
            self.config.width = 544;
            self.config.height = 720;
        } break;
            
        case BPVideoMaskType16x9: {
            self.config.width = 1280;
            self.config.height = 720;
        } break;
            
        default:
            DDLogError(@"----- 未处理的画幅类型");
            break;
    }
    
    for (BPMixView* view in self.video.views) {
        if ([view isKindOfClass:[BPMixMediaView class]]) {
            BPMixMediaView *video = (BPMixMediaView*)view;
            [video.crop updateCropRatioWithType:type];
        }
    }
 
    // 校正 字幕、贴图的位置
    [self bp_adjustAttachLocationWithLastSize:lastSize];
}

- (long)allVideoDuration {
    __block NSTimeInterval duration = 0;
    [self.video.views enumerateObjectsUsingBlock:^(__kindof BPMixView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[BPMixVideoView class]] || [obj isKindOfClass:[BPMixImageView class]]) {
            duration = duration + [obj cutDuration];
        }
    }];
    return duration;
}

- (int)allFragmentCount {
    __block int count = 0;
    [self.video.views enumerateObjectsUsingBlock:^(__kindof BPMixView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[BPMixVideoView class]] || [obj isKindOfClass:[BPMixImageView class]]) {
            count++;
        }
    }];
    return count;
}

- (NSDictionary *)toDict {
    return [self mj_keyValues];
}

#pragma mark - private

// 递归
- (BPMixViewGroup *)groupWithGroupDict:(NSDictionary *)dict {
    BPMixViewGroup* group = [[BPMixViewGroup alloc] init];
    NSArray* array = dict[@"views"];
    group.views = [NSMutableArray arrayWithCapacity:array.count];
    
    for (NSDictionary* dict1 in array) {
        NSString* type = dict1[@"type"];
        if ([type isEqualToString:@"GROUP"]) {
            group = [self groupWithGroupDict:dict1];  // 递归
        } else if ([type isEqualToString:@"VIDEO"]) {
            [group.views addObject:[BPMixVideoView mj_objectWithKeyValues:dict1]];
        } else if ([type isEqualToString:@"PICTURE"]) {
            [group.views addObject:[BPMixImageView mj_objectWithKeyValues:dict1]];
        } else if ([type isEqualToString:@"TRANSITION"]) {
            [group.views addObject:[BPMixTransitionView mj_objectWithKeyValues:dict1]];
        } else if ([type isEqualToString:@"GIF"]) {
            [group.views addObject:[BPMixGifView mj_objectWithKeyValues:dict1]];
        } else if ([type isEqualToString:@"SUBTITLE"]) {
            [group.views addObject:[BPMixSubtitleView mj_objectWithKeyValues:dict1]];
        } else {
            DDLogError(@"mix josn 转 model 解析有误");
        }
    }
    return group;
}

#pragma mark - MJExtension

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"audios" : [BPMixAudio class]
             };
}

/// 忽略以下字段，不做 model 转 json
//+ (NSArray *)mj_ignoredPropertyNames {
//    // 父类里忽略的属性，也需要子类再声明一次
//    return @[@"startIndex", @"endIndex"];
//}

#pragma mark - <NSCopying>

- (id)copyWithZone:(NSZone *)zone
{
    // super 不支持 NSCopying 的，使用 [[[self class] allocWithZone:zone] init];
    // super 支持 NSCopying 的，使用 [super copyWithZone:zone];
    // NSMutableArray ，使用 [[NSMutableArray alloc] initWithArray:self.array copyItems:YES];
    BPMixWindow *model = [[BPMixWindow allocWithZone:zone] init];

    model.config = [self.config copyWithZone:zone];
    model.video = [self.video copyWithZone:zone];
    model.attaches = [self.attaches copyWithZone:zone];
    model.videoMaskType = self.videoMaskType;
    model.startIndex = self.startIndex;
    model.endIndex = self.endIndex;

    model.audios = [[NSMutableArray alloc] initWithArray:self.audios copyItems:YES];
    // 以下都是 错误写法
//    model.audios = [self.audios copyWithZone:zone];
//    for (BPMixAudio *audio in self.audios) {
//        BPMixAudio* cAudio = [audio copyWithZone:zone];
//        [model.audios addObject:cAudio];
//    }

    return model;
}

@end
