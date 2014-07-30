//
//  UIImage+Zoom.h
//  ChangeSlowly
//
//  Created by gaoluyangrc on 14-7-24.
//  Copyright (c) 2014年 rcplatformhk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Zoom)

//压缩图片
+ (UIImage *)zoomImageWithImage:(UIImage *)image;
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;
+ (UIImage *)zoomImage:(UIImage *)image toSize:(CGSize)size;

@end
