//
//  LHCrashTool.h
//  UncaughtException
//
//  Created by lijian on 16/10/19.
//  Copyright © 2016年 lijian. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LJM_Dic_Not_Valid(dic) ((!dic) || (![dic isKindOfClass:[NSDictionary class]]) || ([dic count] <= 0))

#define LJM_Str_Protect(str) ((str) && (![str isKindOfClass:[NSNull class]]) ? (str) : (@""))


/*
 获取 应用程序的名称
 */
NSString * getAppName();


/*
 获取代码的构架
 */
NSString * getCodeArch();


/*
 获取应用程序的加载地址
 */
NSString * getImageLoadAddress();
