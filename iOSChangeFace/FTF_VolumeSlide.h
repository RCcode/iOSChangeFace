//
//  ZVolumeSlide.h
//  AppTestSlide
//
//  Created by ZStart on 13-8-16.
//  Copyright (c) 2013年 ZStart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTF_Delegates.h"

@interface FTF_VolumeSlide : UIView
{
    CGFloat     width;
    CGFloat     height;
}
@property (assign, nonatomic) id <SliderVolumeSlideDelegate> delegate;
@property (strong, nonatomic) UISlider  *slideView;
@property (strong, nonatomic) UIView    *processView;

- (void)setSlideValue:(CGFloat) value;
- (void)slideValueChanged;
- (id)initWithFrame:(CGRect)frame;
@end
