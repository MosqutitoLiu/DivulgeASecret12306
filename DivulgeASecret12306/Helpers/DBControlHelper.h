//
//  DBControlHelper.h
//  DivulgeASecret12306
//
//  Created by Liu.Yang on 12/27/14.
//  Copyright (c) 2014 Liu.Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FMDB.h"

typedef NS_ENUM(NSUInteger, DBControlQueryType) {
    DBControlQueryTypeUnknow,
    DBControlQueryTypePhone,
    DBControlQueryTypeCardId,
    DBControlQueryTypeEmail,
};

@class UserInfo;

@interface DBControlHelper : NSObject

@property (nonatomic, strong) FMDatabaseQueue *dbQueue;

+ (instancetype)sharedInstance;

/** 返回查询结果 */
- (UserInfo *)getUserInfoWithQueryString:(NSString *)queryString
                               queryType:(DBControlQueryType)queryType;

@end
