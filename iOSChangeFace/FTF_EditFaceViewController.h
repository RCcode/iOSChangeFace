//
//  FTF_EditFaceViewController.h
//  iOSChangeFace
//
//  Created by gaoluyangrc on 14-7-28.
//  Copyright (c) 2014年 rcplatform. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTF_EditFaceViewController : UIViewController
{
    UIImage *_libaryImage;
    CGRect _imageRect;
}
@property (strong, nonatomic) UIImage *libaryImage;
@property (assign, nonatomic) CGRect imageRect;
@property (assign, nonatomic) double rorationDegree;

- (IBAction)btnClick:(id)sender;

@end
