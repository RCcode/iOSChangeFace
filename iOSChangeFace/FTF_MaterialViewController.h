//
//  FTF_MaterialViewController.h
//  iOSChangeFace
//
//  Created by gaoluyangrc on 14-7-30.
//  Copyright (c) 2014年 rcplatform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTF_Delegates.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "NCVideoCamera.h"

@interface FTF_MaterialViewController : UIViewController <UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,NCVideoCameraDelegate>
{
    NCVideoCamera *_videoCamera;
}
@property (weak, nonatomic) IBOutlet UIScrollView *modelScrollerView;
@property (assign ,nonatomic) id <ChangeModelDelegate> delegate;

@end
