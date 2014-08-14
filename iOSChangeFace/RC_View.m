//
//  RC_View;.m
//  BezierPathDemo
//
//  Created by gaoluyangrc on 14-8-12.
//  Copyright (c) 2014年 rcplatform. All rights reserved.
//

#import "RC_View.h"
#import "FTF_EditFaceViewController.h"

@implementation RC_View

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 44, 320, 320)];
        backImageView.image = [UIImage imageNamed:@"xuxian.png"];
        [self addSubview:backImageView];
        
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(164, 44, 40, 40)];
        imageView.center = CGPointMake(164, 44);
        imageView.image = [UIImage imageNamed:@"dot.png"];
        [self addSubview:imageView];
        
        UIImageView *handImageView = [[UIImageView alloc]initWithFrame:CGRectMake(-5, 13, 100, 130)];
        handImageView.image = [UIImage imageNamed:@"hand.png"];
        [imageView addSubview:handImageView];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    
    UIBezierPath *path=[UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(164, 44)];
    [path addCurveToPoint:CGPointMake(164, 364) controlPoint1:CGPointMake(0, 24) controlPoint2:CGPointMake(0, 364)];
    [path closePath];
    
    CGPathRef ref = path.CGPath;
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = ref;
    animation.duration = 5.f;
    animation.delegate = self;
    [imageView.layer addAnimation:animation forKey:@"position"];
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self.editFace performSelector:@selector(removeGuideView) withObject:nil afterDelay:1.f];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
