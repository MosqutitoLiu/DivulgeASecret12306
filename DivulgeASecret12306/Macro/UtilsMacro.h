//
//  UtilsMacro.h
//  DivulgeASecret12306
//
//  Created by Liu.Yang on 12/27/14.
//  Copyright (c) 2014 Liu.Yang. All rights reserved.
//

#ifndef DivulgeASecret12306_UtilsMacro_h
#define DivulgeASecret12306_UtilsMacro_h

/** System Versioning Preprocessor Macros */
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define RGB(r, g, b) RGBA(r, g, b, 1)
//#define XcodeAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

/** Prompt String */
#define kPromptString @"提示:\n♳本地数据查询,承诺 不记录 不传播您的帐号\n♴不会收集任何隐私 放心使用\n♵QQ、支付宝等涉及资金的帐号,如与泄露帐号使用相同密码,请尽快修改"

/** UserInfo String */
#define kShowUserInfoString @"姓名:%@\n手机号:%@\n邮箱:%@\n身份证号:%@\n\n您的帐号信息已泄露,请立即修改密码!\n如QQ、支付宝、微博等帐号使用相同的密码,请尽快修改!"

#endif
