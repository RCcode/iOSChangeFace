//
//  MZCroppableView.m
//  MZCroppableView
//
//  Created by macbook on 30/10/2013.
//  Copyright (c) 2013 macbook. All rights reserved.
//

#import "MZCroppableView.h"
#import "UIBezierPath-Points.h"

@implementation MZCroppableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (id)initWithImageView:(UIImageView *)imageView
{
    self = [super initWithFrame:imageView.frame];
    if (self)
    {
        self.lineWidth = 2.0f;
        [self setBackgroundColor:[UIColor clearColor]];
        [self setClipsToBounds:YES];
        [self setUserInteractionEnabled:YES];
        self.croppingPath = [[UIBezierPath alloc] init];
        CGFloat lineDash[] = {8,2};
        [self.croppingPath setLineDash:lineDash count:2 phase:1];
        [self.croppingPath setLineWidth:self.lineWidth];
        self.lineColor = [UIColor redColor];
    }
    
    return self;
}

#pragma mark - My Methods -
+ (CGRect)scaleRespectAspectFromRect1:(CGRect)rect1 toRect2:(CGRect)rect2
{
    CGSize scaledSize = rect2.size;
    
    float scaleFactor = 1.0;
    
    CGFloat widthFactor  = rect2.size.width / rect1.size.width;
    CGFloat heightFactor = rect2.size.height / rect1.size.width;
    
    if (widthFactor < heightFactor)
        scaleFactor = widthFactor;
    else
        scaleFactor = heightFactor;
    
    scaledSize.height = rect1.size.height *scaleFactor;
    scaledSize.width  = rect1.size.width  *scaleFactor;
    
    float y = (rect2.size.height - scaledSize.height)/2;
    
    return CGRectMake(0, y, scaledSize.width, scaledSize.height);
}

+ (CGPoint)convertCGPoint:(CGPoint)point1 fromRect1:(CGSize)rect1 toRect2:(CGSize)rect2
{
    point1.y = rect1.height - point1.y;
    CGPoint result = CGPointMake((point1.x*rect2.width)/rect1.width, (point1.y*rect2.height)/rect1.height);
    return result;
}

+ (CGPoint)convertPoint:(CGPoint)point1 fromRect1:(CGSize)rect1 toRect2:(CGSize)rect2
{
    CGPoint result = CGPointMake((point1.x*rect2.width)/rect1.width, (point1.y*rect2.height)/rect1.height);
    return result;
}

- (void)drawRect:(CGRect)rect
{
    [self.lineColor setStroke];
    [self.croppingPath strokeWithBlendMode:kCGBlendModeNormal alpha:1.0f];
}

- (UIImage *)deleteBackgroundOfImage:(UIImageView *)imageView
{
    NSMutableArray *points = [self.croppingPath points];
    //插入默认的四个点
    //默认起点
    [points insertObject:[NSValue valueWithCGPoint:CGPointMake(-self.frame.origin.x, -self.frame.origin.y)] atIndex:0];
    if (points.count >= 2)
    {
        CGPoint point = [(NSValue *)[points objectAtIndex:1] CGPointValue];
        point.x = point.x;
        point.y = -self.frame.origin.y;
        [points insertObject:[NSValue valueWithCGPoint:point] atIndex:1];
    }
    
    CGPoint point = [(NSValue *)[points objectAtIndex:points.count - 1] CGPointValue];
    point.x = point.x;
    point.y = -self.frame.origin.y + 320;
    [points addObject:[NSValue valueWithCGPoint:point]];
    //默认终点
    [points addObject:[NSValue valueWithCGPoint:CGPointMake(-self.frame.origin.x, -self.frame.origin.y + 320)]];
    
    if (points.count <= 5)
    {
        return nil;
    }
    
    CGRect rect = CGRectZero;
    rect.size = imageView.image.size;
    
    UIBezierPath *aPath;

    UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0.0);
    {
        [[UIColor whiteColor] setFill];
        UIRectFill(rect);
        [[UIColor blackColor] setFill];
        
        aPath = [UIBezierPath bezierPath];
        
        CGPoint p1 = [MZCroppableView convertCGPoint:[[points objectAtIndex:0] CGPointValue] fromRect1:imageView.frame.size toRect2:imageView.image.size];
        [aPath moveToPoint:CGPointMake(p1.x, p1.y)];
        
        for (uint i=1; i<points.count; i++)
        {
            CGPoint p = [MZCroppableView convertCGPoint:[[points objectAtIndex:i] CGPointValue] fromRect1:imageView.frame.size toRect2:imageView.image.size];
            [aPath addLineToPoint:CGPointMake(p.x, p.y)];
        }
        [aPath closePath];
        [aPath fill];
    }
    
    UIImage *mask = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    
    {
        CGContextClipToMask(UIGraphicsGetCurrentContext(), rect, mask.CGImage);
        [imageView.image drawAtPoint:CGPointZero];
    }
    
    UIImage *maskedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return maskedImage;
}

#pragma mark - Touch Methods -
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BeginCropImage" object:nil];
    UITouch *mytouch=[[touches allObjects] objectAtIndex:0];
    [self.croppingPath moveToPoint:[mytouch locationInView:self]];
    [self.nextResponder touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *mytouch=[[touches allObjects] objectAtIndex:0];
    [self.croppingPath addLineToPoint:[mytouch locationInView:self]];
    [self setNeedsDisplay];
    [self.nextResponder touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EndCropImage" object:nil];
    [self.croppingPath removeAllPoints];
    [self setNeedsDisplay];
    [self.nextResponder touchesEnded:touches withEvent:event];
}

@end