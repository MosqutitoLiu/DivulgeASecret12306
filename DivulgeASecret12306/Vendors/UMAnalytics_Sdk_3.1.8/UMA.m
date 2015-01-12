//
//  UMA.m
//  DivulgeASecret12306
//
//  Created by Liu.Yang on 12/28/14.
//  Copyright (c) 2014 Liu.Yang. All rights reserved.
//

#import "UMA.h"

#import "MobClick.h"
#import "AppMacro.h"

#ifdef DEBUG

#else

@implementation UMA

+ (void)initial
{
#ifdef DEBUG
    [MobClick setLogEnabled:YES];
#endif
    [MobClick setAppVersion:XcodeAppVersion];
    [MobClick setLogEnabled:NO];
    [MobClick setCrashReportEnabled:YES];
    [MobClick startWithAppkey:UMENG_APPKEY
                 reportPolicy:SEND_INTERVAL
                    channelId:nil];
}

+ (void)beginPage:(NSString *)page
{
    [MobClick beginLogPageView:page];
}

+ (void)endPage:(NSString *)page
{
    [MobClick endLogPageView:page];
}

+ (void)event:(NSString *)eventID
{
    [MobClick event:eventID];
}

+ (void)event:(NSString *)eventID label:(NSString *)label
{
    [MobClick event:eventID
              label:label];
}

@end

#endif