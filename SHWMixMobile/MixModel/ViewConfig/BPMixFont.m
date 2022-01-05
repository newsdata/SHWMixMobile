//
//  BPMixFont.m
//  BeiPaiVideoEditor
//
//  Created by yehot on 2019/7/22.
//  Copyright © 2019 Xin Hua Zhi Yun. All rights reserved.
//

#import "BPMixFont.h"

@implementation BPMixFont


#pragma mark - <NSCopying>

- (id)copyWithZone:(NSZone *)zone
{
    BPMixFont *model = [[[self class] allocWithZone:zone] init];

    model.text = [self.text copy];
    model.font = [self.font copy];
    model.fontSize = self.fontSize;
    model.fontColor = [self.fontColor copy];
    model.strokeAlpha = self.strokeAlpha;
    model.strokeWidth = self.strokeWidth;
    
    return model;
}


#pragma mark - MJExtension

/// 忽略以下字段，不做 model 转 json
+ (NSArray *)mj_ignoredPropertyNames {
    return @[@"fontName",@"fontWidth",@"fontHeight"];
}

@end
