//
//  BPMixView.m
//  BeiPaiVideoEditor
//
//  Created by yehot on 2019/7/22.
//  Copyright © 2019 Xin Hua Zhi Yun. All rights reserved.
//

#import "BPMixView.h"
#import "BPMixMediaView.h"
#import "BPLogger.h"

@implementation BPMixView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.mType = Mix_View;
    }
    return self;
}

- (NSString *)type {
    NSString *type = @"";
    switch (self.mType) {
        case Mix_Group:
            type = @"GROUP";
            break;
        case Mix_Video:
            type = @"VIDEO";
            break;
        case Mix_Picture:
            type = @"PICTURE";
            break;
        case Mix_Transition:
            type = @"TRANSITION";
            break;
        case Mix_Gif:
            type = @"GIF";
            break;
        case Mix_Subtitle:
            type = @"SUBTITLE";
            break;
        default:
            DDLogError(@"mix josn 格式有误");
            break;
    }
    return type;
}

- (void)setType:(NSString *)type {
    if ([type isEqualToString:@"GROUP"]) {
        _mType = Mix_Group;
    } else if ([type isEqualToString:@"VIDEO"]) {
        _mType = Mix_Video;
    } else if ([type isEqualToString:@"PICTURE"]) {
        _mType = Mix_Picture;
    } else if ([type isEqualToString:@"TRANSITION"]) {
        _mType = Mix_Transition;
    } else if ([type isEqualToString:@"GIF"]) {
        _mType = Mix_Gif;
    } else if ([type isEqualToString:@"SUBTITLE"]) {
        _mType = Mix_Subtitle;
    } else {
        DDLogError(@"mix josn 格式解析有误");
        _mType = Mix_View;
    }
}

- (BOOL)isMixMediaViewType {
    if ([self isKindOfClass:[BPMixMediaView class]]) {
        return YES;
    }
    return NO;
}

#pragma mark - MJExtension

/// 忽略以下字段，不做 model 转 json
+ (NSArray *)mj_ignoredPropertyNames {
    // 父类里忽略的属性，也需要子类再声明一次
    return @[@"mType"];
}

#pragma mark - <NSCopying>

- (id)copyWithZone:(NSZone *)zone
{
    BPMixView *model = [[[self class] allocWithZone:zone] init];

    model.type = [self.type copy];
    model.mType = self.mType;
    return model;
}

@end
