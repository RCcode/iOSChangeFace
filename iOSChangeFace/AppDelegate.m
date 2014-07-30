//
//  AppDelegate.m
//  iOSChangeFace
//
//  Created by gaoluyangrc on 14-7-26.
//  Copyright (c) 2014年 rcplatform. All rights reserved.
//

#import "AppDelegate.h"
#import "MobClick.h"
#import "Flurry.h"
#import "GADBannerView.h"
#import "FTF_RootViewController.h"
#import "SliderViewController.h"
#import "Pic_MenuViewController.h"
#import "LRNavigationController.h"
#import "FTF_Global.h"
@import AdSupport;
#import <arpa/inet.h>

#define AdMobID @"ca-app-pub-3747943735238482/7117549852"
#define UMengKey @"53d607ff56240b5d11055ecd"
#define FlurryAppKey @"Q85WBVSCNNNC284VSQ8K"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    [SliderViewController sharedSliderController].LeftVC=[[Pic_MenuViewController alloc] init];
    
    //向右滑动的距离
    [SliderViewController sharedSliderController].LeftSContentOffset=180;
    //控制器缩放的比例
    [SliderViewController sharedSliderController].LeftSContentScale=0.8;
    
    LRNavigationController *nav=[[LRNavigationController alloc] initWithRootViewController:[SliderViewController sharedSliderController]];
    
    self.window.rootViewController = nav;
    
    [self.window makeKeyAndVisible];
    
//    if (iPhone5())
//    {
//        //广告
//        [self adMobSetting];
//    }
    
    //友盟
    [self umengSetting];
    
    return YES;
}

#pragma mark -
#pragma mark umeng
- (void)umengSetting
{
    [MobClick startWithAppkey:UMengKey reportPolicy:SEND_ON_EXIT channelId:@"App Store"];
    [MobClick updateOnlineConfig];
    
    [Flurry startSession:FlurryAppKey];
    [Flurry setSessionReportsOnCloseEnabled:YES];
}

#pragma mark -
#pragma mark 配置广告条
- (void)adMobSetting
{
    /** AdMob相关 **/
    CGPoint origin = CGPointMake(0, [UIScreen mainScreen].bounds.size.height - kGADAdSizeBanner.size.height);
    GADBannerView *bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner origin:origin];
    bannerView.backgroundColor = [UIColor blackColor];
    [[UIApplication sharedApplication].keyWindow addSubview:bannerView];
    bannerView.adUnitID = AdMobID;
    bannerView.rootViewController = self.window.rootViewController;
    GADRequest *request = [GADRequest request];
    NSString *deviesID = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    request.testDevices = @[deviesID];
    [bannerView loadRequest:request];
    //赋值
    [FTF_Global shareGlobal].bannerView = bannerView;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
