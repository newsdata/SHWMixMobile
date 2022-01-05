//
//  BPMixCrop.m
//  JianBei
//
//  Created by yehot on 2019/10/21.
//  Copyright © 2019 Xin Hua Zhi Yun. All rights reserved.
//

#import "BPMixCrop.h"
#import "BPLogger.h"

@interface BPMixCrop ()

@property (nonatomic, assign, readwrite) int videoWidth;
@property (nonatomic, assign, readwrite) int videoHeight;

@end

@implementation BPMixCrop

- (instancetype)init {
    self = [super init];
    if (self) {
        self.height = -1;
        self.width = -1;
        self.x = 0;
        self.y = 0;
    }
    return self;
}

- (instancetype)initWithVideoOriginSize:(CGSize)size
                               cropArea:(CGRect)frame {
    self = [super init];
    if (self) {
        
        self.videoWidth = size.width;
        self.videoHeight = size.height;
        
        if (frame.size.width > size.width || frame.size.height > size.height) {
            DDLogError(@"---- 裁剪区域大于原视频 size");
        }
        
        self.x = frame.origin.x;
        self.y = frame.origin.y;
        self.width = frame.size.width;
        self.height = frame.size.height;
    }
    return self;
}

- (instancetype)initWithVideoOriginSize:(CGSize)size
                              cropRatio:(BPVideoMaskType)type {
    self = [super init];
    if (self) {
        self.videoWidth = size.width;
        self.videoHeight = size.height;
        
        [self updateCropRatioWithType:type];
    }
    return self;
}

#pragma mark -

- (void)updateCropRatioWithType:(BPVideoMaskType)type {

    int cropRatioWidth = 1;
    int cropRatioHeight = 1;
    
    switch (type) {
        case BPVideoMaskType3x4: {
            cropRatioWidth = 3;
            cropRatioHeight = 4;
        } break;
            
        case BPVideoMaskType1x1: {
            cropRatioWidth = 1;
            cropRatioHeight = 1;
        } break;
            
        case BPVideoMaskType16x9: {
            cropRatioWidth = 16;
            cropRatioHeight = 9;
        } break;
        
        case BPVideoMaskType_Origin: {
            self.width = self.videoWidth;
            self.height = self.videoHeight;
            return;
        } break;

        default:
            DDLogError(@" model.videoMaskType error");
            break;
    }
    
    CGSize size = CGSizeMake(self.videoWidth, self.videoHeight);
    
    float videoScale = (float)size.width/size.height;
    float cropScale = (float)cropRatioWidth/cropRatioHeight;
    int rx = 0, ry = 0, width = 0, height = 0;
    // 如果比例很接近（需要考虑换算不正常的情况），不进行裁剪
    if (ABS(videoScale-cropScale) < 0.05) {
        self.x = 0;
        self.y = 0;
        self.width = size.width;
        self.height = size.height;
    } else {
        
        if (videoScale > cropScale) {
            height = size.height;
            width = (int) (size.height * cropScale);
            rx = (size.width - width) / 2;
        } else {
            width = size.width;
            height = (int) (size.width / cropScale);
            ry = (size.height - height) / 2;
        }
        self.x = rx;
        self.y = ry;
        self.width = width;
        self.height = height;
    }
}

- (void)updateCropRatioWithCropArea:(CGRect)rect {
    self.x = rect.origin.x;
    self.y = rect.origin.y;
    self.width = rect.size.width;
    self.height = rect.size.height;
}

- (CGRect)getCropArea {
    return CGRectMake(self.x, self.y, self.width, self.height);
}

- (CGSize)getOriginSize {
    return CGSizeMake(self.videoWidth, self.videoHeight);
}

#pragma mark - <NSCopying>

- (id)copyWithZone:(NSZone *)zone
{
    BPMixCrop *model = [[[self class] allocWithZone:zone] init];
    
    model.x = self.x;
    model.y = self.y;
    model.width = self.width;
    model.height = self.height;
    
    model.videoWidth = self.videoWidth;
    model.videoHeight = self.videoHeight;

    return model;
}

@end
