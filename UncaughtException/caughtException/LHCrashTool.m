//
//  LHCrashTool.m
//  UncaughtException
//
//  Created by lijian on 16/10/19.
//  Copyright © 2016年 lijian. All rights reserved.
//

#import "LHCrashTool.h"
#include <mach-o/dyld.h>
#include <mach-o/loader.h>


/*
 获取 应用程序的名称
 */
NSString * getAppName()
{
    ///获取应用程序的名称
    NSDictionary *dicInfo =   [[NSBundle mainBundle] infoDictionary];
    if (LJM_Dic_Not_Valid(dicInfo))
    {
        return nil;
    }
    NSString *strAppName = dicInfo[@"CFBundleName"];
    return strAppName;
}
/*
 获取应用程序的加载地址
 */
NSString * getImageLoadAddress()
{
    NSString *strLoadAddress =nil;
    
    
    NSString * strAppName = getAppName();
    if (!strAppName)
    {
        return strLoadAddress;
    }
    
    ///获取应用程序的load address
    uint32_t count = _dyld_image_count();
    for(uint32_t iImg = 0; iImg < count; iImg++)
    {
        const char* szName = _dyld_get_image_name(iImg);
        if (strstr(szName, strAppName.UTF8String) != NULL)
        {
            const struct mach_header* header = _dyld_get_image_header(iImg);
            strLoadAddress = [NSString stringWithFormat:@"0x%lX",(uintptr_t)header];
            break;
        }
    }
    return strLoadAddress;
}



/*
 获取代码的构架
 */
NSString * getCodeArch()
{
    NSString *strSystemArch =nil;
    
    
    ///获取应用程序的名称
    NSDictionary *dicInfo =   [[NSBundle mainBundle] infoDictionary];
    if (LJM_Dic_Not_Valid(dicInfo))
    {
        return strSystemArch;
    }
    NSString *strAppName = dicInfo[@"CFBundleName"];
    if (!strAppName)
    {
        return strSystemArch;
    }
    
    ///获取  cpu 的大小版本号
    uint32_t count = _dyld_image_count();
    cpu_type_t cpuType = -1;
    cpu_type_t cpuSubType =-1;
    
    for(uint32_t iImg = 0; iImg < count; iImg++)
    {
        const char* szName = _dyld_get_image_name(iImg);
        if (strstr(szName, strAppName.UTF8String) != NULL)
        {
            const struct mach_header* machHeader = _dyld_get_image_header(iImg);
            cpuType = machHeader->cputype;
            cpuSubType = machHeader->cpusubtype;
            break;
        }
    }
    
    if(cpuType < 0 ||  cpuSubType <0)
    {
        return  strSystemArch;
    }
    
    
    ///转化cpu 版本
    switch(cpuType)
    {
        case CPU_TYPE_ARM:
        {
            strSystemArch = @"arm";
            switch (cpuSubType)
            {
                case CPU_SUBTYPE_ARM_V6:
                    strSystemArch = @"armv6";
                    break;
                case CPU_SUBTYPE_ARM_V7:
                    strSystemArch = @"armv7";
                    break;
                case CPU_SUBTYPE_ARM_V7F:
                    strSystemArch = @"armv7f";
                    break;
                case CPU_SUBTYPE_ARM_V7K:
                    strSystemArch = @"armv7k";
                    break;
#ifdef CPU_SUBTYPE_ARM_V7S
                case CPU_SUBTYPE_ARM_V7S:
                    strSystemArch = @"armv7s";
                    break;
#endif
            }
            break;
        }
#ifdef CPU_TYPE_ARM64
        case CPU_TYPE_ARM64:
            strSystemArch = @"arm64";
            break;
#endif
        case CPU_TYPE_X86:
            strSystemArch = @"i386";
            break;
        case CPU_TYPE_X86_64:
            strSystemArch = @"x86_64";
            break;
    }
    return strSystemArch;
}


