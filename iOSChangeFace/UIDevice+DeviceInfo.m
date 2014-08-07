//
//  UIDevice+DeviceInfo.m
//  PushDemo
//
//  Created by MAXToooNG on 14-5-6.
//  Copyright (c) 2014年 MAXToooNG. All rights reserved.
//

#import "UIDevice+DeviceInfo.h"

#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
@implementation UIDevice (DeviceInfo)

- (NSString *)platform{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return platform;
}

- (NSString *) platformString{
    NSString *platform = [self platform];
    return platform;
}  


+ (NSString *)currentVersion{
    return [[UIDevice currentDevice] systemVersion];
}

+ (NSString *)currentModel{
    return [[UIDevice currentDevice] model];
}

+ (NSString *)currentModelVersion{
    return [[UIDevice currentDevice] platformString];
}

@end
