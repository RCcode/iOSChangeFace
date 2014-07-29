//
//  UIImage+Zoom.m
//  ChangeSlowly
//
//  Created by gaoluyangrc on 14-7-24.
//  Copyright (c) 2014年 rcplatformhk. All rights reserved.
//

#import "UIImage+Zoom.h"
#define BigValue 1080.f

@implementation UIImage (Zoom)

+ (UIImage *)zoomImageWithImage:(UIImage *)image
{
    static UIImage *newImage;
    if (image.size.width > BigValue || image.size.height > BigValue)
    {
        if (image.size.width >=  image.size.height)
        {
            float scale = image.size.width/BigValue;
            float height = image.size.height/scale;
            newImage = [image imageByScalingToSize:CGSizeMake(BigValue, height)];
        }
        else
        {
            float scale = image.size.height/BigValue;
            float width = image.size.width/scale;
            newImage = [image imageByScalingToSize:CGSizeMake(width, BigValue)];
        }
    }
    else
    {
        if (image.size.width >=  image.size.height)
        {
            float scale = BigValue/image.size.width;
            float height = image.size.height*scale;
            newImage = [image imageByScalingToSize:CGSizeMake(BigValue, height)];
        }
        else
        {
            float scale = BigValue/image.size.height;
            float width = image.size.width*scale;
            newImage = [image imageByScalingToSize:CGSizeMake(width, BigValue)];
        }
    }
    
    return newImage;
}

- (UIImage *)imageByScalingToSize:(CGSize)targetSize{
    
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil) NSLog(@"could not scale image");
    
    
    return newImage ;
}

@end
