//
//  BPMixSubtitleView.m
//  BeiPaiVideoEditor
//
//  Created by yehot on 2019/7/23.
//  Copyright © 2019 Xin Hua Zhi Yun. All rights reserved.
//

#import "BPMixSubtitleView.h"

@implementation BPMixSubtitleView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.mType = Mix_Subtitle;
        
        self.detachTime = -1;
        self.attachTime = 0;
        self.shadow = NO;
        
        self.topPadding = 0;
        self.leftPadding = 0;
        self.linePadding = 0;
        self.shadowPaddingX = 0;
        self.shadowPaddingY = 0;
        
        self.subtitleType = BPEditSubtitleType_Normal;
    }
    return self;
}


#pragma mark - <NSCopying>

- (id)copyWithZone:(NSZone *)zone
{
    BPMixSubtitleView *model = [super copyWithZone:zone];

    model.attachTime = self.attachTime;
    model.detachTime = self.detachTime;
    model.titleFont = [self.titleFont copyWithZone:zone];
    model.subFont = [self.subFont copyWithZone:zone];
    model.bgColor = [self.bgColor copy]; 
    model.layout = [self.layout copyWithZone:zone];
    model.shadow = self.shadow;

    model.shadowPaddingY = self.shadowPaddingY;
    model.shadowPaddingX = self.shadowPaddingX;
    model.linePadding = self.linePadding;
    model.leftPadding = self.leftPadding;
    model.topPadding = self.topPadding;
    model.shadowColor = self.shadowColor;
    
    model.subtitleType = self.subtitleType;
    
    return model;
}

@end
