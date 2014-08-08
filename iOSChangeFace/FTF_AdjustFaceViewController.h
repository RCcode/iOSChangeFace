//
//  FTF_AdjustFaceViewController.h
//  iOSChangeFace
//
//  Created by gaoluyangrc on 14-7-26.
//  Copyright (c) 2014年 rcplatform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTF_Delegates.h"

@interface FTF_AdjustFaceViewController : UIViewController <DirectionDelegate,UIGestureRecognizerDelegate>

- (void)loadAdjustViews:(UIImage *)image;

@end
