//
//  CMethods.h
//  TaxiTest
//
//  Created by Xiaohui Guo  on 13-3-13.
//  Copyright (c) 2013年 FJKJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <stdio.h>
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface CMethods : NSObject

UIWindow * currentWindow();

//window 高度
CGFloat windowHeight();

//statusBar隐藏与否的高
CGFloat heightWithStatusBar();

//view 高度
CGFloat viewHeight(UIViewController *viewController);

//图片路径
UIImage* pngImagePath(NSString *name);
UIImage* jpgImagePath(NSString *name);

//数字转化为字符串
NSString* stringForInteger(int value);

//系统语言环境
NSString* currentLanguage();

BOOL iPhone5();
BOOL iPhone4();

BOOL IOS7_Or_Higher();

//返回随机不重复树
NSMutableArray* randrom(int count,int totalCount);

//十六进制颜色值
UIColor* colorWithHexString(NSString *stringToConvert,float alpha);

//把字典转化为json串
NSData* toJSONData(id theData);

MBProgressHUD * showMBProgressHUD(NSString *content,BOOL showView);
void hideMBProgressHUD();

//转换时间戳
NSString *exchangeTime(NSString *time);

//美工px尺寸，转ios字体size（接近值）
CGFloat fontSizeFromPX(CGFloat pxSize);

//当前应用的版本
NSString *appVersion();

//统一使用它做 应用本地化 操作
NSString *LocalizedString(NSString *translation_key, id none);

void cancleAllRequests();

//获取设备型号
NSString *doDevicePlatform();

CGSize sizeWithContentAndFont(NSString *content,CGSize size,float fontSize);

void logMemoryInfo();

@end
