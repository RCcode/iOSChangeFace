//
//  FTF_MaterialViewController.h
//  iOSChangeFace
//
//  Created by gaoluyangrc on 14-7-30.
//  Copyright (c) 2014年 rcplatform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTF_Delegates.h"
@import AssetsLibrary;
@import MobileCoreServices;

@interface FTF_MaterialViewController : UIViewController <UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *modelScrollerView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *modelSegment;
@property (assign ,nonatomic) id <ChangeModelDelegate> delegate;

- (IBAction)modelSegmentValueChanged:(id)sender;

@end