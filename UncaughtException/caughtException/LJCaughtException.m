//
//  LJCaughtException.m
//  UncaughtException
//
//  Created by lijian on 16/10/19.
//  Copyright © 2016年 lijian. All rights reserved.
//

#import "LJCaughtException.h"
#import "LJCrashInfoModel.h"
#import "LHCrashTool.h"
///先前注册的处理句柄
NSUncaughtExceptionHandler *preHander;

/// 异常处理函数
void UncaughtExceptionHandler(NSException * exception)
{
    [LJCaughtException  processException:exception];
}


@implementation LJCaughtException


+(NSString *)applicationDocumentsDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

+ (void)setDefaultHandler
{
    preHander = [LJCaughtException getHandler];
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
}

+ (NSUncaughtExceptionHandler *)getHandler
{
    return NSGetUncaughtExceptionHandler();
}

+ (void)processException:(NSException *)exception
{
    ///获取应用程序的名称
    NSString *strAppName = getAppName();
    
    
    /// 异常的堆栈信息
    NSArray *aryCrashBackTrace = [exception callStackSymbols];
    if (!aryCrashBackTrace)
    {
        return;
    }
    NSString * pathBackTrace = [[LJCaughtException applicationDocumentsDirectory] stringByAppendingPathComponent: [LJCaughtException getExceptionFileNameWithPrefix:@"BackTrace"]];
    NSString *strBackTrace = [NSString stringWithFormat:@"%@",aryCrashBackTrace];
    [strBackTrace writeToFile:pathBackTrace atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    /// 出现异常的原因
    NSString *strCrashReason = [exception reason];
    
    /// 异常名称
    NSString *strCrashName = [exception name];
    
    //NSTextCheckingResult
    /// 构建崩溃model
    LJCrashInfoModel *modelCrashInfo = [LJCrashInfoModel new];
    modelCrashInfo.strCrashReason = LJM_Str_Protect(strCrashReason);
    modelCrashInfo.strCrashName = LJM_Str_Protect(strCrashName);
    modelCrashInfo.strCrashArch = LJM_Str_Protect(getCodeArch());
    modelCrashInfo.strCrashSystemVersion = [[UIDevice currentDevice] systemVersion];

    NSMutableArray *maryBackTrace = [NSMutableArray array];
    
    ///崩溃的调用堆栈信息
    for (NSString *strBackTrace in aryCrashBackTrace)
    {
        ///查找崩溃的镜像名称 、 崩溃堆栈地址、 镜像加载地址
        NSError * error;
        NSRegularExpression * regulorStackAddress = [NSRegularExpression regularExpressionWithPattern:@"0x[0-9a-fA-F]{8,16}" options:NSRegularExpressionCaseInsensitive error:&error];
        
        NSRegularExpression * regulorAdd = [NSRegularExpression regularExpressionWithPattern:@"\\+ [0-9]+" options:NSRegularExpressionCaseInsensitive error:&error];
        
        NSRange rangeStackAddress = [regulorStackAddress rangeOfFirstMatchInString:strBackTrace options:NSMatchingReportProgress range:NSMakeRange(0, strBackTrace.length)];
        
        NSRange rangeAdd = [regulorAdd rangeOfFirstMatchInString:strBackTrace options:NSMatchingReportProgress range:NSMakeRange(0, strBackTrace.length)];
        
        if (rangeStackAddress.location == NSNotFound || rangeAdd.location == NSNotFound  )
        {
            continue;
        }
        
        ///镜像名称
        NSRange rangeImageName = NSMakeRange(3, rangeStackAddress.location-3);
        if (rangeImageName.location + rangeImageName.length >strBackTrace.length )
        {
            continue;
        }
        NSString *strImageName = [strBackTrace substringWithRange:rangeImageName];
        strImageName = [strImageName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        ///堆栈地址
        if (rangeStackAddress.location + rangeStackAddress.length > strBackTrace.length)
        {
            continue;
        }
        NSString *strStackAddress = [strBackTrace substringWithRange:rangeStackAddress];
        strStackAddress = [strStackAddress stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        
        ///加载地址
        NSRange rangeLoadAddress = NSMakeRange(rangeStackAddress.location + rangeStackAddress.length +1, rangeAdd.location - rangeStackAddress.location - rangeStackAddress.length -2);
        if (rangeLoadAddress.location + rangeLoadAddress.length>  strBackTrace.length)
        {
            continue;
        }
        NSString *strLoadAddress =[strBackTrace substringWithRange:NSMakeRange(rangeStackAddress.location + rangeStackAddress.length +1, rangeAdd.location - rangeStackAddress.location - rangeStackAddress.length -2)];
        
        
        
        LJCrashBackTraceModel *modelBackTrace = [LJCrashBackTraceModel new];
        modelBackTrace.strImageName = strImageName;
        modelBackTrace.strStackAddress = strStackAddress;
        if ([strLoadAddress isEqualToString:strAppName])
        {
            modelBackTrace.strImageLoadAddress = LJM_Str_Protect(getImageLoadAddress());
        }
        else
        {
            modelBackTrace.strImageLoadAddress = LJM_Str_Protect(strLoadAddress);
        }
        [maryBackTrace addObject:modelBackTrace];
    }
    modelCrashInfo.aryCrashBackTrace  = maryBackTrace ;
    
    
    ///转为json 格式，并保存文件
    ///model 转 字典
    NSMutableDictionary *mdicCrashInfo = [NSMutableDictionary dictionary];
    [mdicCrashInfo setValue:LJM_Str_Protect(modelCrashInfo.strCrashReason) forKey:@"strCrashReason"];
    [mdicCrashInfo setValue:LJM_Str_Protect(modelCrashInfo.strCrashName) forKey:@"strCrashName"];
    
    [mdicCrashInfo setValue:LJM_Str_Protect(modelCrashInfo.strCrashArch) forKey:@"strCrashArch"];

    
    [mdicCrashInfo setValue:LJM_Str_Protect(modelCrashInfo.strCrashSystemVersion) forKey:@"strCrashSystemVersion"];
    
    
    NSMutableArray *maryDecodeBackTrack = [NSMutableArray array];
    for (LJCrashBackTraceModel *modelCrashBackTrack in modelCrashInfo.aryCrashBackTrace)
    {
        NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
        [mdic setValue:LJM_Str_Protect(modelCrashBackTrack.strImageName) forKey:@"strImageName"];
        [mdic setValue:LJM_Str_Protect(modelCrashBackTrack.strStackAddress) forKey:@"strStackAddress"];
        [mdic setValue:LJM_Str_Protect(modelCrashBackTrack.strImageLoadAddress) forKey:@"strImageLoadAddress"];
        [maryDecodeBackTrack addObject:mdic];
    }
    if (maryDecodeBackTrack)
    {
        [mdicCrashInfo setValue:maryDecodeBackTrack forKey:@"aryCrashBackTrace"];
    }

    
  
    NSString * path = [[LJCaughtException applicationDocumentsDirectory] stringByAppendingPathComponent: [LJCaughtException getExceptionFileNameWithPrefix:@"Exception"]];
    NSData *dataCrash = [NSJSONSerialization dataWithJSONObject:mdicCrashInfo options:NSJSONWritingPrettyPrinted error:nil];
    [dataCrash writeToFile:path atomically:YES];
    
    NSLog(@"path = %@",path);
    
    if (NULL != preHander)
    {
        NSSetUncaughtExceptionHandler(preHander);
    }

}

+ (NSString*)getExceptionFileNameWithPrefix:(NSString *) strPrefix
{
    NSDate *localDate = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[localDate timeIntervalSince1970]];
    NSString *fileName = [NSString stringWithFormat:@"%@%@.txt",strPrefix,timeSp];
    return fileName;
}




@end
