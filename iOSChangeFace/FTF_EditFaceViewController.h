//
//  FTF_EditFaceViewController.h
//  iOSChangeFace
//
//  Created by gaoluyangrc on 14-7-28.
//  Copyright (c) 2014年 rcplatform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTF_Delegates.h"
#import "NCVideoCamera.h"

@interface FTF_EditFaceViewController : UIViewController <ChangeModelDelegate,DirectionDelegate,NCVideoCameraDelegate,UIAlertViewDelegate>
{
    UIImage *_libaryImage;
    CGRect _imageRect;
    UIImageView *backImageView;
    BOOL isFiltering;
    NSInteger toolTag;
}
@property (strong, nonatomic) UIImage *libaryImage;
@property (assign, nonatomic) CGRect imageRect;

- (void)removeGuideView;

@end
