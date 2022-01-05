//
//  BPVideoFileHandler.m
//  BeiPaiVideoEditor
//
//  Created by yehot on 2019/7/18.
//  Copyright © 2019 Xin Hua Zhi Yun. All rights reserved.
//

#import "BPVideoFileHandler.h"
#import "BPFileUtil.h"

static NSString *const kVideoFileFolderName = @"bp_media";

@implementation BPVideoFileHandler

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self excludedFromBackupVidoeDirectory];
    });
}

+ (NSString *)videoFileRelativePathWithName:(NSString *)name {
    NSString *documnetsPath = @"Documents";
    documnetsPath = [documnetsPath stringByAppendingString:[NSString stringWithFormat:@"/%@/%@", kVideoFileFolderName, name]];
    return documnetsPath;
}

+ (NSString *)videoFileDirectory {
    [self createVideoFolderIfNotExist];
    NSString *documnetsPath = [BPFileUtil sandboxDocumentsPath];
    NSString *folderPath = [documnetsPath stringByAppendingString:[NSString stringWithFormat:@"/%@", kVideoFileFolderName]];
    return folderPath;
}

+ (NSString *)videoFilePathWithName:(NSString *)name {
    NSString *folderPath = [self videoFileDirectory];
    NSString *filePath = [folderPath stringByAppendingString:[NSString stringWithFormat:@"/%@", name]];
    return filePath;
}

+ (NSString *)editorDraftFilePathWithName:(NSString *)name {
    return [self videoFilePathWithName:name];
}
#pragma mark - private

/// 禁止视频目录备份到 iCloud
+ (void)excludedFromBackupVidoeDirectory {
    @try {
        NSString *videoPath = [self videoFileDirectory];
        NSURL *videoPathUrl = [NSURL fileURLWithPath:videoPath isDirectory:YES];
        // 不许备份到iCloud
        [videoPathUrl setResourceValue:[NSNumber numberWithBool:YES]
                                forKey:NSURLIsExcludedFromBackupKey
                                 error:nil];
    } @catch (NSException *exception) {

    }
}

/// 创建 存放所有录制的视频 文件 的目录
+ (BOOL)createVideoFolderIfNotExist {
    NSString *documnetsPath = [BPFileUtil sandboxDocumentsPath];
    return [BPFileUtil createFolderIfNotExistAtPath:documnetsPath folderName:kVideoFileFolderName];
}

@end
