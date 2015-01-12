//
//  UMA.h
//  DivulgeASecret12306
//
//  Created by Liu.Yang on 12/28/14.
//  Copyright (c) 2014 Liu.Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG

#define UMA_INIT()
#define UMA_BEGIN_PAGE(p)
#define UMA_END_PAGE(p)
#define UMA_EVENT(e)
#define UMA_EVENT_WITH_LABEL(e, l)

#else

#define UMA_INIT() [UMA initial]
#define UMA_BEGIN_PAGE(p) [UMA beginPage:p]
#define UMA_END_PAGE(p) [UMA endPage:p]
#define UMA_EVENT(e) [UMA event:e]
#define UMA_EVENT_WITH_LABEL(e, l) [UMA event:e label:l]

#endif

#ifdef DEBUG

#else

@interface UMA : NSObject

/** 初始化 */
+ (void)initial;
/** 页面记时 */
+ (void)beginPage:(NSString *)page;
+ (void)endPage:(NSString *)page;
/** 事件统计 */
+ (void)event:(NSString *)eventID;
+ (void)event:(NSString *)eventID label:(NSString *)label;

@end

#endif
