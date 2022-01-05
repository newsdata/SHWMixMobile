//
//  BPLogFileManager.m
//  JianBei
//
//  Created by yehot on 2019/11/6.
//  Copyright © 2019 Xin Hua Zhi Yun. All rights reserved.
//

#import "BPLogFileManager.h"

static NSString* kLogFilePrefix = @"bp_";

@implementation BPLogFileManager

//if you change newLogFileName , then  change isLogFile method also accordingly
- (NSString *)newLogFileName {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd_HH-mm-ss"];
    NSString *formattedDate = [dateFormatter stringFromDate:[NSDate date]];

    return [NSString stringWithFormat:@"%@%@.log", kLogFilePrefix, formattedDate];
}

- (BOOL)isLogFile:(NSString *)fileName {
    BOOL hasProperPrefix = [fileName hasPrefix:kLogFilePrefix];
    BOOL hasProperSuffix = [fileName hasSuffix:@".log"];

    return (hasProperPrefix && hasProperSuffix);
}

@end
