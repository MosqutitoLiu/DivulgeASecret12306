//
//  DatabaseMacro.h
//  DivulgeASecret12306
//
//  Created by Liu.Yang on 12/27/14.
//  Copyright (c) 2014 Liu.Yang. All rights reserved.
//

#ifndef DivulgeASecret12306_DatabaseMacro_h
#define DivulgeASecret12306_DatabaseMacro_h

/** Database Elements */
#define kDBElementUserID @"uid"
#define kDBElementPassword  @"pw"
#define kDBElementUserName  @"name"
#define kDBElementCardId    @"cardid"
#define kDBElementNickname  @"unkonwid"
#define kDBElementPhone @"phone"
#define kDBElementEmail @"email"

/** Query */
#define kQueryUserInfoSQL   @"SELECT * FROM PERSONINFO WHERE %@ = '%@' COLLATE NOCASE "


#endif
