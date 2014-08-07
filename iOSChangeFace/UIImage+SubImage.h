//
//  UIImage+SubImage.h
//  PRJ_Test
//
//  Created by 贺瑞 on 14-4-16.
//  Copyright (c) 2014年 rcplatfrom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (SubImage)


/**
*  截取当前image对象rect区域内的图像
*/
- (UIImage *)subImageWithRect:(CGRect)rect;


/**
 *  指定size，获取新的iamge对象
 */
- (UIImage *)rescaleImageToSize:(CGSize)size;


/**
 *  等比缩放图片
 */
- (UIImage *)rescaleImageToPX:(CGFloat )toPX;


/**
 *  按一定比例进行压缩
 */
+ (NSData *)createThumbImage:(UIImage *)image size:(CGSize )thumbSize percent:(float)percent;


/**
 *  指定大小生成一个平铺的图片
 */
- (UIImage *)getTiledImageWithSize:(CGSize)size;


/**
 *  获取在ScaleAspectFit模式下，image所处imageView的frame
 */
- (CGRect)frameOnScaleAspectFitModeWithViewSize:(CGSize)viewS;


/**
 *  获取在ScaleAspectFill模式下，image展示出来部分的frame
 */
- (CGRect)frameOnScaleAspectFillMode;
@end
