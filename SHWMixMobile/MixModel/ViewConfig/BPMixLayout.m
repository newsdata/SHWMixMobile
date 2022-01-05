//
//  BPMixLayout.m
//  BeiPaiVideoEditor
//
//  Created by yehot on 2019/7/22.
//  Copyright © 2019 Xin Hua Zhi Yun. All rights reserved.
//

#import "BPMixLayout.h"

@implementation BPMixLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        self.rx = 0;
        self.ry = 0;
        self.width = 0;
        self.height = 0;
        self.position = 1;
        self.refract = 100;
        self.ios_Position = 8;
    }
    return self;
}

#pragma mark - <NSCopying>

- (id)copyWithZone:(NSZone *)zone
{
    BPMixLayout *model = [[[self class] allocWithZone:zone] init];
    model.rx = self.rx;
    model.ry = self.ry;
    model.width = self.width;
    model.height = self.height;
    model.position = self.position;
    model.refract = self.refract;
    model.ios_Position = self.ios_Position;
    
    return model;
}

@end
