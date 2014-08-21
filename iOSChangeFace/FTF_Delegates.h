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

- (void)changeModelImage:(UIImage *)image;

@end

@protocol DirectionDelegate <NSObject>

- (void)directionBtnClick:(NSUInteger)tag;
@optional
- (void)directionSlider:(UISlider *)slider;

@end

@protocol SliderVolumeSlideDelegate <NSObject>

- (void)slideChange:(UISlider *)slider;

@end

@protocol WebRequestDelegate <NSObject>

- (void)didReceivedData:(NSDictionary *)dic withTag:(NSInteger)tag;
@optional
- (void)requestFailed:(NSInteger)tag;

@end

@protocol MoreAppDelegate <NSObject>

- (void)jumpAppStore:(NSString *)appid;

@end
