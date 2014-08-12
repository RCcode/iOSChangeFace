//
//  RC_View;.h
//  BezierPathDemo
//
//  Created by gaoluyangrc on 14-8-12.
//  Copyright (c) 2014年 rcplatform. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FTF_EditFaceViewController;

@interface RC_View : UIView <UIApplicationDelegate>
{
    UIImageView *imageView;
}

@property (nonatomic ,weak) FTF_EditFaceViewController *editFace;

@end
