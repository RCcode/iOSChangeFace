//
//  FTF_RootViewController.h
//  iOSChangeFace
//
//  Created by gaoluyangrc on 14-7-26.
//  Copyright (c) 2014年 rcplatform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "GADInterstitialDelegate.h"

@interface FTF_RootViewController : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate,GADInterstitialDelegate>
{
    
}
@property (weak, nonatomic) IBOutlet UIButton *menuBtn;
@property (weak, nonatomic) IBOutlet UIButton *libaryBtn;
@property (weak, nonatomic) IBOutlet UIButton *camenaBtn;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@end
