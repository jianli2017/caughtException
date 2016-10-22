//
//  LJCaughtException.h
//  UncaughtException
//
//  Created by lijian on 16/10/19.
//  Copyright © 2016年 lijian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LJCaughtException : NSObject

/// 设置异常处理函数
+ (void)setDefaultHandler;

/// 获取异常处理函数
+ (NSUncaughtExceptionHandler *)getHandler;

///异常处理
+ (void)processException:(NSException *)exception;


@end
