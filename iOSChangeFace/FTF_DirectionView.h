//
//  FTF_DirectionView.h
//  iOSChangeFace
//
//  Created by gaoluyangrc on 14-8-5.
//  Copyright (c) 2014年 rcplatform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTF_Delegates.h"
#import "FTF_VolumeSlide.h"

@interface FTF_DirectionView : UIView <SliderVolumeSlideDelegate>
{
    FTF_VolumeSlide *volumeSlide;
    UISlider *lindeSlider;
}
@property (nonatomic ,assign) id <DirectionDelegate> delegate;
@property (nonatomic ,assign) enum DirectionType direction_Type;
@property (nonatomic ,assign) enum ModelType model_Type;
@property (nonatomic ,assign) NCFilterType filter_Type;

- (void)loadDirectionItools;
- (void)loadModelStyleItools;
- (void)loadCropItools;
- (void)loadFilerItools;

- (void)setVolumeSlideValue:(float)value;

@end
