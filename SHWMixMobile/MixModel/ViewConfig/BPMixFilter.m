//
//  BPMixFilter.m
//  BeiPaiVideoEditor
//
//  Created by yehot on 2019/7/22.
//  Copyright © 2019 Xin Hua Zhi Yun. All rights reserved.
//

#import "BPMixFilter.h"

@implementation BPMixFilter

#pragma mark - publick

+ (BPMixFilterType)filterTypeWithName:(NSString *)name {
    BPMixFilterType type = BPMixFilterType_None;
    if ([name isEqualToString:kFilterName_Beautify]) {
        type = BPMixFilterType_Beautify;
    } else if ([name isEqualToString:kFilterName_ZoomIn]) {
        type = BPMixFilterType_ZoomIn;
    } else if ([name isEqualToString:kFilterName_ZoomOut]) {
        type = BPMixFilterType_ZoomOut;
    } else if ([name isEqualToString:kFilterName_ZoomLeft]) {
        type = BPMixFilterType_ZoomLeft;
    } else if ([name isEqualToString:kFilterName_ZoomRight]) {
        type = BPMixFilterType_ZoomRight;
    } else if ([name isEqualToString:kFilterName_ZoomUp]) {
        type = BPMixFilterType_ZoomUp;
    } else if ([name isEqualToString:kFilterName_ZoomDown]) {
        type = BPMixFilterType_ZoomDown;
    }
    
    return type;
}

+ (NSString *)glslNameWithType:(BPMixFilterType)type {
    NSString *str;
    switch (type) {
        case BPMixFilterType_Beautify:
        {
            str = kFilterName_Beautify;
        } break;

        case BPMixFilterType_ZoomIn:
        {
            str = kFilterName_ZoomIn;
        } break;
            
        case BPMixFilterType_ZoomOut:
        {
            str = kFilterName_ZoomOut;
        } break;
            
        case BPMixFilterType_ZoomLeft:
        {
            str = kFilterName_ZoomLeft;
        } break;
            
        case BPMixFilterType_ZoomRight:
        {
            str = kFilterName_ZoomRight;
        } break;
            
        case BPMixFilterType_ZoomUp:
        {
            str = kFilterName_ZoomUp;
        } break;
            
        case BPMixFilterType_ZoomDown:
        {
            str = kFilterName_ZoomDown;
        } break;
            
        default:
            break;
    }
    
    return str;
}

- (BOOL)isKindOfBeautifyFaceFilter {
    if ([self.name isEqualToString:kFilterName_Beautify]) {
        return YES;
    }
    return NO;
}

- (BOOL)isKindOfZoomEffectFilter {
    if ([self.name isEqualToString:kFilterName_ZoomIn]      ||
        [self.name isEqualToString:kFilterName_ZoomOut]     ||
        [self.name isEqualToString:kFilterName_ZoomLeft]    ||
        [self.name isEqualToString:kFilterName_ZoomRight]   ||
        [self.name isEqualToString:kFilterName_ZoomUp]      ||
        [self.name isEqualToString:kFilterName_ZoomDown] )
    {
        return YES;
    }
    return NO;
}

#pragma mark - <NSCopying>

- (id)copyWithZone:(NSZone *)zone
{
    BPMixFilter *model = [[[self class] allocWithZone:zone] init];

    model.name = [self.name copy];
    model.optionStr = [self.optionStr copy];
    
    return model;
}

@end
