//
//  DBControlHelper.m
//  DivulgeASecret12306
//
//  Created by Liu.Yang on 12/27/14.
//  Copyright (c) 2014 Liu.Yang. All rights reserved.
//

#import "DBControlHelper.h"

#import "UserInfo.h"
#import "AppMacro.h"

@implementation DBControlHelper

+ (instancetype)sharedInstance
{
    static DBControlHelper *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"info12306"
                                                           ofType:@"db"];
        _dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    }
    return self;
}

- (UserInfo *)getUserInfoWithQueryString:(NSString *)queryString
                               queryType:(DBControlQueryType)queryType
{
    UserInfo *userInfo = [[UserInfo alloc] init];
    NSString *qTString = kDBElementUserID;
    switch (queryType) {
        case DBControlQueryTypePhone:
        {
            qTString = kDBElementPhone;
        }
            break;
        case DBControlQueryTypeCardId:
        {
            qTString = kDBElementCardId;
        }
            break;
        case DBControlQueryTypeEmail:
        {
            qTString = kDBElementUserID;
        }
            break;
            
        default:
            break;
    }
    NSLog(@"%@",queryString);
    NSString *sqlString = [NSString stringWithFormat:kQueryUserInfoSQL, qTString, queryString];
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db open];
        
        FMResultSet *rs = [db executeQuery:sqlString];
        while (rs.next) {
            userInfo.uid = [rs stringForColumn:kDBElementUserID];
            userInfo.pw = [rs stringForColumn:kDBElementPassword];
            userInfo.name = [rs stringForColumn:kDBElementUserName];
            userInfo.cardid = [rs stringForColumn:kDBElementCardId];
            userInfo.unkonwid = [rs stringForColumn:kDBElementNickname];
            userInfo.phoneNumber = [rs stringForColumn:kDBElementPhone];
            userInfo.email = [rs stringForColumn:kDBElementEmail];
        }
        [db close];
    }];
    
    return userInfo;
}

@end
