//
//  LJCrashInfoModel.m
//  UncaughtException
//
//  Created by lijian on 16/10/19.
//  Copyright © 2016年 lijian. All rights reserved.
//

#import "LJCrashInfoModel.h"

@implementation LJCrashInfoModel

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.strCrashReason forKey:@"strCrashReason"];
    
    [aCoder encodeObject:self.strCrashName forKey:@"strCrashName"];
    
    [aCoder encodeObject:self.strCrashArch forKey:@"strCrashArch"];
    
    [aCoder encodeObject:self.strCrashSystemVersion forKey:@"strCrashSystemVersion"];
    
    [aCoder encodeObject:self.aryCrashBackTrace forKey:@"aryCrashBackTrace"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        self.strCrashReason = [aDecoder decodeObjectForKey:@"strCrashReason"];
        self.strCrashName = [aDecoder decodeObjectForKey:@"strCrashName"];
        self.strCrashArch = [aDecoder decodeObjectForKey:@"strCrashArch"];
        self.strCrashSystemVersion = [aDecoder decodeObjectForKey:@"strCrashSystemVersion"];
        self.aryCrashBackTrace = [aDecoder decodeObjectForKey:@"aryCrashBackTrace"];
    }
    return self;
}


@end


@implementation LJCrashBackTraceModel

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.strStackAddress forKey:@"strStackAddress"];
    [aCoder encodeObject:self.strImageLoadAddress forKey:@"strImageLoadAddress"];
    [aCoder encodeObject:self.strImageName forKey:@"strImageName"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        self.strStackAddress = [aDecoder decodeObjectForKey:@"strStackAddress"];
        self.strImageLoadAddress = [aDecoder decodeObjectForKey:@"strImageLoadAddress"];
        self.strImageName = [aDecoder decodeObjectForKey:@"strImageName"];
    }
    return self;
}


@end

