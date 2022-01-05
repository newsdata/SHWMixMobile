//
//  BPFileUtil.m
//  BeiPaiVideoEditor
//
//  Created by yehot on 2019/7/18.
//  Copyright © 2019 Xin Hua Zhi Yun. All rights reserved.
//

#import "BPFileUtil.h"

@implementation BPFileUtil

#pragma mark - public

+ (BOOL)createFolderIfNotExistAtPath:(NSString *)path folderName:(NSString *)name {
    NSString *folderPath = [path stringByAppendingString:[NSString stringWithFormat:@"/%@", name]];
    NSFileManager * manager = [NSFileManager defaultManager];
    
    BOOL isFolder;
    BOOL isFolderExist = [manager fileExistsAtPath:folderPath isDirectory:&isFolder];
    if (isFolderExist && isFolder) {    // 已存在该目录
        return YES;
    }
    
    NSError *error = nil;
    BOOL success = [manager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:&error];
    if (error) {
        return NO;
    }
    return success;
}

// 判断文件(夹)是否存在
+ (BOOL)isFileExistsAtPath:(NSString *)fileFullPath {
    if (!fileFullPath.length) {
        return NO;
    }
    NSFileManager *file_manager = [NSFileManager defaultManager];
    return [file_manager fileExistsAtPath:fileFullPath];
}

+ (BOOL)removeFileAtPath:(NSString *)filePath {
    NSFileManager* fileManager=[NSFileManager defaultManager];
    BOOL success = [fileManager removeItemAtPath:filePath error:nil];
    return success;
}

+ (NSString *)sandboxDocumentsPath {
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
}

+ (NSString *)sandboxPath {
    return NSHomeDirectory();
}

#pragma mark - 移动文件(夹)


+ (NSString *)directoryAtPath:(NSString *)path {
    return [path stringByDeletingLastPathComponent];
}

+ (BOOL)createDirectoryAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL isSuccess = [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:error];
    return isSuccess;
}

+ (BOOL)removeItemAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    return [[NSFileManager defaultManager] removeItemAtPath:path error:error];
}

+ (BOOL)moveItemAtPath:(NSString *)path toPath:(NSString *)toPath overwrite:(BOOL)overwrite error:(NSError *__autoreleasing *)error {
    // 先要保证源文件路径存在，不然抛出异常
    if (![self isFileExistsAtPath:path]) {
        [NSException raise:@"非法的源文件路径" format:@"源文件路径%@不存在，请检查源文件路径", path];
        return NO;
    }
    //获得目标文件的上级目录
    NSString *toDirPath = [self directoryAtPath:toPath];
    if (![self isFileExistsAtPath:toDirPath]) {
        // 创建移动路径
        if (![self createDirectoryAtPath:toDirPath error:error]) {
            return NO;
        }
    }
    // 判断目标路径文件是否存在
    if ([self isFileExistsAtPath:toPath]) {
        //如果覆盖，删除目标路径文件
        if (overwrite) {
            //删掉目标路径文件
            [self removeItemAtPath:toPath error:error];
        }else {
            //删掉被移动文件
            [self removeItemAtPath:path error:error];
            return YES;
        }
    }
    
    // 移动文件，当要移动到的文件路径文件存在，会移动失败
    BOOL isSuccess = [[NSFileManager defaultManager] moveItemAtPath:path toPath:toPath error:error];
    return isSuccess;
}

@end
