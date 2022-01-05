//
//  BPMixConfig.m
//  BeiPaiVideoEditor
//
//  Created by yehot on 2019/7/22.
//  Copyright © 2019 Xin Hua Zhi Yun. All rights reserved.
//

#import "BPMixConfig.h"

@implementation BPMixConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        self.fps = 25;
        self.cutStartTime = 0;
        self.cutEndTime = -1;
    }
    return self;
}

- (CGSize)getSize {
    return CGSizeMake(self.width, self.height);
}

#pragma mark - <NSCopying>

- (id)copyWithZone:(NSZone *)zone
{
    BPMixConfig *model = [[[self class] allocWithZone:zone] init];
    model.fps = self.fps;
    model.width = self.width;
    model.height = self.height;
    model.cutStartTime = self.cutStartTime;
    model.cutEndTime = self.cutEndTime;
    return model;
}

@end
