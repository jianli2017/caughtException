//
//  LJCrashInfoModel.h
//  UncaughtException
//
//  Created by lijian on 16/10/19.
//  Copyright © 2016年 lijian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LJCrashInfoModel : NSObject<NSCoding>

/// 崩溃的原因
@property (copy,nonatomic) NSString *strCrashReason;

///崩溃的名称
@property (copy,nonatomic) NSString *strCrashName;

///崩溃时系统的构建
@property (copy,nonatomic) NSString *strCrashArch;

///系统版本
@property(nonatomic, copy) NSString * strCrashSystemVersion;

///崩溃线程的调用堆栈 类型是 LJCrashBackTraceModel
@property (strong,nonatomic) NSArray *aryCrashBackTrace;

@end


@interface LJCrashBackTraceModel : NSObject<NSCoding>

///崩溃的堆栈地址
@property (copy,nonatomic) NSString *strStackAddress;

/// 崩溃所在镜像的加载地址
@property (copy,nonatomic) NSString *strImageLoadAddress;

///崩溃所在镜像 的名称
@property (copy,nonatomic) NSString *strImageName;


@end
