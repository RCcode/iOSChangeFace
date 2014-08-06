//
//  FTF_DirectionView.h
//  iOSChangeFace
//
//  Created by gaoluyangrc on 14-8-5.
//  Copyright (c) 2014年 rcplatform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTF_Delegates.h"

@interface FTF_DirectionView : UIView <SliderVolumeSlideDelegate>

@property (nonatomic ,assign) id <DirectionDelegate> delegate;

- (void)loadDirectionItools;
- (void)loadModelStyleItools;
- (void)loadCropItools;
- (void)loadFilerItools;

@end
