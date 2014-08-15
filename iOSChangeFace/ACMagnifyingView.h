//
//  ACMagnifyingView.h
//  MagnifyingGlass
//
//  Created by Arnaud Coomans on 30/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ACMagnifyingGlass;
@class MZCroppableView;

@interface ACMagnifyingView : UIView <UIGestureRecognizerDelegate>
{
    MZCroppableView *cropView;
    float lastScale;
    double recordedRotation;
    BOOL isTiny;
}
@property (nonatomic, strong) ACMagnifyingGlass *magnifyingGlass;
@property (nonatomic, assign) CGFloat magnifyingGlassShowDelay;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *cropImage;

- (void)loadCropImageView:(UIImageView *)imgView;

- (void)beginCropImage;
- (void)endCropImage:(BOOL)isLast;

- (void)setMZViewUserInteractionEnabled;
- (void)setMZViewNotUserInteractionEnabled;
- (void)setMZImageView:(BOOL)isRestore;
- (void)moveBtnClick:(NSInteger)tag;
- (void)changeMagnifyingGlassCenter:(CGPoint)center;

@end
