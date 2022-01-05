//
//  BPLogger.m
//  BeiPaiVideoEditor
//
//  Created by yehot on 2019/7/11.
//  Copyright © 2019 Xin Hua Zhi Yun. All rights reserved.
//

#import "BPLogger.h"
#import "BPDeviceInfo.h"
#import "BPFileUtil.h"
#import "BPLogFileManager.h"

static NSString* const KDDLogDirName = @"bp_log";

@implementation BPLogger

+ (void)configLoggerService {
    // 输出到控制台
    if (@available(iOS 10.0, *)) {
        [DDLog addLogger:[DDOSLogger sharedInstance] withLevel:DDLogLevelAll];
    } else {
        [DDLog addLogger:[DDTTYLogger sharedInstance] withLevel:DDLogLevelAll];
    }
    
    // Logger to file
    [BPFileUtil createFolderIfNotExistAtPath:[BPFileUtil sandboxDocumentsPath] folderName:KDDLogDirName];
    NSString* logDirPath = [NSString stringWithFormat:@"%@/%@", [BPFileUtil sandboxDocumentsPath], KDDLogDirName];
    BPLogFileManager* fileManager = [[BPLogFileManager alloc] initWithLogsDirectory:logDirPath];
    
    DDFileLogger *fileLogger = [[DDFileLogger alloc] initWithLogFileManager:fileManager];
    fileLogger.rollingFrequency = 60 * 60 * 24; // 每 24 小时切割分新的日志文件
    fileLogger.maximumFileSize = 10 * 1024 * 1024;  // 10MB
    fileLogger.logFileManager.maximumNumberOfLogFiles = 5; // 日志文件个数上限
    [DDLog addLogger:fileLogger withLevel:DDLogLevelInfo];
    
    [self logDeviceInfo];

    DDLogInfo(@"sandbox log file path: %@", [fileLogger.logFileManager logsDirectory]);
}

+ (void)logDeviceInfo {
    UIDevice *device = [[UIDevice alloc] init];
    NSString *name = device.name;                   // 获取设备所有者的名称
    NSString *model = [BPDeviceInfo platformString];                 // 获取设备的型号
    NSString *systemName = device.systemName;       // 获取当前运行的系统
    NSString *systemVersion = device.systemVersion; // 获取当前系统的版本
    

    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"]; // 获取App的版本号
    NSString *appBuildVersion = [infoDic objectForKey:@"CFBundleVersion"]; // 获取App的build版本

    DDLogInfo(@"✅✅ app launch : %@ - %@ - %@ %@ ====  app version: %@  build: %@", name, model, systemName, systemVersion, appVersion, appBuildVersion);
}

@end
