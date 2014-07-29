//
//  FTF_Global.h
//  iOSChangeFace
//
//  Created by gaoluyangrc on 14-7-26.
//  Copyright (c) 2014年 rcplatform. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTF_Global : NSObject

@property (nonatomic ,strong) UIImage *originalImage; //原始图片
@property (nonatomic ,strong) UIImage *compressionImage; //压缩后的图片

+ (instancetype)shareGlobal;

@end
