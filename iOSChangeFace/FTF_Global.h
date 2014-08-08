//
//  FTF_Global.h
//  iOSChangeFace
//
//  Created by gaoluyangrc on 14-7-26.
//  Copyright (c) 2014年 rcplatform. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LRNavigationController;

@interface FTF_Global : NSObject

@property (nonatomic ,strong) UIImage *originalImage; //原始图片
@property (nonatomic ,strong) UIImage *compressionImage; //压缩后的图片
@property (nonatomic ,strong) NSString *modelImageName;//模板
@property (nonatomic ,strong) UIImage *bigImage;
@property (nonatomic ,strong) UIImage *modelImage;
@property (nonatomic ,assign) BOOL isFromLibary;
@property (nonatomic ,weak) LRNavigationController *nav;
@property (assign, nonatomic) double rorationDegree;
@property (nonatomic ,strong) NSMutableArray *appsArray;
@property (nonatomic ,assign) BOOL isOn;
@property (nonatomic ,assign) BOOL isChange;


//广告条
@property (nonatomic, strong) UIView *bannerView;

+ (instancetype)shareGlobal;
+ (void)event:(NSString *)eventID label:(NSString *)label;

@end
