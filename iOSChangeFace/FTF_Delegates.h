//
//  FTF_Delegates.h
//  iOSChangeFace
//
//  Created by gaoluyangrc on 14-7-29.
//  Copyright (c) 2014年 rcplatform. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ChangeFrameDelegate <NSObject>

- (void)changeMZViewFrame:(CGPoint)point;

@end

@protocol ChangeModelDelegate <NSObject>

- (void)changeModelImage;

@end

@protocol DirectionDelegate <NSObject>

- (void)directionBtnClick:(NSUInteger)tag;
@optional
- (void)sliderValueHaveChanged:(NSUInteger)tag;

@end

@protocol SliderVolumeSlideDelegate <NSObject>

- (void)slideChange:(CGFloat)value;

@end
