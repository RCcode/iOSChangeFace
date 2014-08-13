//
//  AppDelegate.h
//  iOSChangeFace
//
//  Created by gaoluyangrc on 14-7-26.
//  Copyright (c) 2014年 rcplatform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTF_Delegates.h"
#import "AFNetworking/AFNetworking/AFHTTPRequestOperationManager.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,WebRequestDelegate>
{
    
}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, copy) NSString *updateUrlStr;
@property (nonatomic, strong) NSString *trackURL;//apple的iTunes地址
@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;

@end
