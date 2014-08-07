//
//  UIImage+Helper.m
//  IOSPhotoCollage
//
//  Created by herui on 6/8/14.
//  Copyright (c) 2014年 rcplatform. All rights reserved.
//

#import "UIImage+Helper.h"

@implementation UIImage (Helper)

+ (UIImage *)imageFromName:(NSString *)imageName{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:nil];
    
    if(path == nil){
        path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@@2x.png", imageName] ofType:nil];
    }

    if(path == nil){
        path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@.png", imageName] ofType:nil];
    }
    
    if(path == nil){
        path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@.jpg", imageName] ofType:nil];
    }
    
    if(path == nil){
        return nil;
    }
    
    
//    NSLog(@"imagePath - %@", path);
    
    return [UIImage imageWithContentsOfFile:path];
}

@end
