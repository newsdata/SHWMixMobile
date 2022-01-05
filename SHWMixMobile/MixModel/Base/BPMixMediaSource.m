//
//  BPMixMediaSource.m
//  JianBei
//
//  Created by yehot on 2019/10/31.
//  Copyright © 2019 Xin Hua Zhi Yun. All rights reserved.
//

#import "BPMixMediaSource.h"
#import "BPLogger.h"

@interface BPMixMediaSource ()

@property (nonatomic, assign, readwrite) BPMixMediaSourceType source;
@property (nonatomic, copy, readwrite) NSString *fileRelativePath;

@end

@implementation BPMixMediaSource

- (instancetype)initWithSandboxPath:(NSString *)path {
    return [self initWithType:BPMixMediaSourceType_SandBox path:path];
}

- (instancetype)initWithBundleFile:(NSString *)fileName {
    return [self initWithType:BPMixMediaSourceType_Bundel path:fileName];
}

- (instancetype)initWithAlbumPath:(NSString *)albumPath {
    return [self initWithType:BPMixMediaSourceType_Album path:albumPath];
}

- (instancetype)initWithType:(BPMixMediaSourceType)type path:(NSString *)path {
    self = [super init];
    if (self) {
        self.fileRelativePath = path;
        if ([path containsString:@"//Documents"]) {
            DDLogError(@"---------BPMixMediaSourceType path error");
        }
        self.source = type;
    }
    return self;
}

- (NSString *)absoluteFilePath {
    NSString* path;
    switch (self.source) {
        case BPMixMediaSourceType_Album:
        {
            path = self.fileRelativePath;
        } break;
            
        case BPMixMediaSourceType_SandBox:
        {
            NSString* appPath = [self sandboxPath];
            path = [appPath stringByAppendingString:[NSString stringWithFormat:@"/%@", self.fileRelativePath]];
        } break;
            
        case BPMixMediaSourceType_Bundel:
        {
            path = [[NSBundle mainBundle] pathForResource:self.fileRelativePath ofType:nil];
        } break;
            
        default:
            break;
    }
    return path;
}

- (NSString *)sandboxPath {
    return NSHomeDirectory();
}

#pragma mark <NSCopying>

- (id)copyWithZone:(NSZone *)zone
{
    BPMixMediaSource *model = [[[self class] allocWithZone:zone] init];
    model.source = self.source;
    model.fileRelativePath = self.fileRelativePath;
    return model;
}

@end

