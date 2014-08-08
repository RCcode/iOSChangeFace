//
//  ACMagnifyingView.m
//  MagnifyingGlass
//
//  Created by Arnaud Coomans on 30/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ACMagnifyingView.h"
#import "ACMagnifyingGlass.h"
#import "MZCroppableView.h"
#import "FTF_Global.h"

static CGFloat const kACMagnifyingViewDefaultShowDelay = 0.5;

@interface ACMagnifyingView ()
@property (nonatomic, retain) NSTimer *touchTimer;
- (void)addMagnifyingGlassAtPoint:(CGPoint)point;
- (void)removeMagnifyingGlass;
- (void)updateMagnifyingGlassAtPoint:(CGPoint)point;
@end


@implementation ACMagnifyingView

@synthesize magnifyingGlass, magnifyingGlassShowDelay;
@synthesize touchTimer;


- (id)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame]) {
		self.magnifyingGlassShowDelay = kACMagnifyingViewDefaultShowDelay;
    }
	return self;
}


- (void)loadCropImageView:(UIImageView *)imgView
{
    for (UIView *view in [self subviews])
    {
        [view removeFromSuperview];
    }
    //选取的图片
    self.imageView = imgView;
    [self addGestureRecognizerToView:self.imageView];
    self.image = imgView.image;
    [self addSubview:self.imageView];
    CGAffineTransform currentTransform = self.imageView.transform;
    CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform, [FTF_Global shareGlobal].rorationDegree);
    [self.imageView setTransform:newTransform];
    //抠图操作视图
    cropView = [[MZCroppableView alloc]initWithImageView:self.imageView];
    cropView.userInteractionEnabled = NO;
    self.magnifyingGlass.hidden = YES;
    [self addSubview:cropView];
}

#pragma mark - touch events
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	self.touchTimer = [NSTimer scheduledTimerWithTimeInterval:magnifyingGlassShowDelay
													   target:self
													 selector:@selector(addMagnifyingGlassTimer:)
													 userInfo:[NSValue valueWithCGPoint:[touch locationInView:self]]
													  repeats:NO];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	[self updateMagnifyingGlassAtPoint:[touch locationInView:self]];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[self.touchTimer invalidate];
	self.touchTimer = nil;
	[self removeMagnifyingGlass];
}

- (void)setMZViewUserInteractionEnabled
{
    self.magnifyingGlass.hidden = NO;
    cropView.userInteractionEnabled = YES;
}

- (void)setMZViewNotUserInteractionEnabled
{
    self.magnifyingGlass.hidden = YES;
    cropView.userInteractionEnabled = NO;
    _imageView.image = _image;
}

- (void)setMZImageView
{
    _imageView.image = _image;
}

- (void)addGestureRecognizerToView:(UIView *)view
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] init];
    pan.delegate = self;
    [pan addTarget:self action:@selector(panView:changePoint:)];
    [view addGestureRecognizer:pan];
    
    UIPinchGestureRecognizer *pin = [[UIPinchGestureRecognizer alloc] init];
    pin.delegate = self;
    [pin addTarget:self action:@selector(pinView:changeScale:)];
    [view addGestureRecognizer:pin];
    
    UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateView:changeRotate:)];
    rotationGesture.delegate = self;
    [view addGestureRecognizer:rotationGesture];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)moveBtnClick:(NSInteger)tag
{
    if (tag == 0)
    {
        self.imageView.transform = CGAffineTransformMakeRotation(0);
        if ([FTF_Global shareGlobal].compressionImage.size.width > [FTF_Global shareGlobal].compressionImage.size.height)
        {
            self.imageView.frame = CGRectMake(0, 0, 320, [FTF_Global shareGlobal].compressionImage.size.height * (320.f/1080.f));
        }
        else
        {
            self.imageView.frame = CGRectMake(0, 0, [FTF_Global shareGlobal].compressionImage.size.width * (320.f/1080.f), 320);
        }
        self.imageView.center = CGPointMake(160, 160);
        self.imageView.image = [FTF_Global shareGlobal].compressionImage;
    }
    else if (tag == 5 || tag == 6)
    {
        for (UIPinchGestureRecognizer *recognizer in self.imageView.gestureRecognizers)
        {
            if ([recognizer isKindOfClass:[UIPinchGestureRecognizer class]])
            {
                UIPinchGestureRecognizer *pin = (UIPinchGestureRecognizer *)recognizer;
                float scale = 1 + (tag == 5 ? 0.06 : -0.06);
                isTiny = YES;
                [self pinView:pin changeScale:scale];
            }
        }
    }
    else if (tag == 7 || tag == 8)
    {
        for (UIRotationGestureRecognizer *recognizer in self.imageView.gestureRecognizers)
        {
            if ([recognizer isKindOfClass:[UIRotationGestureRecognizer class]])
            {
                UIRotationGestureRecognizer *rotation = (UIRotationGestureRecognizer *)recognizer;
                float scale = tag == 7 ? -0.01 : 0.01;
                isTiny = YES;
                [self rotateView:rotation changeRotate:scale];
            }
        }
    }
    else
    {
        for (UIGestureRecognizer *recognizer in self.imageView.gestureRecognizers)
        {
            if ([recognizer isKindOfClass:[UIPanGestureRecognizer class]])
            {
                UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)recognizer;
                
                CGPoint point;
                if (tag == 2 || tag == 4)
                {
                    point = CGPointMake(0, tag == 2 ? -5 : 5);
                }
                else
                {
                    point = CGPointMake(tag == 1 ? -5 : 5, 0);
                }
                isTiny = YES;
                [self panView:pan changePoint:point];
            }
        }
    }
}

#pragma mark -
#pragma mark 移动
- (void)panView:(UIPanGestureRecognizer *)recognizer changePoint:(CGPoint)point
{
    UIView *panView = recognizer.view;
    
    CGPoint translation;
    if (isTiny)
    {
        translation = point;
        isTiny = NO;
    }
    else
    {
        translation = [recognizer translationInView:self];
    }
    
    panView.center = CGPointMake(panView.center.x + translation.x, panView.center.y + translation.y);
    cropView.center = CGPointMake(cropView.center.x + translation.x, cropView.center.y + translation.y);
    
    [recognizer setTranslation:CGPointMake(0, 0) inView:self];
}

#pragma mark -
#pragma mark 缩放
- (void)pinView:(UIPinchGestureRecognizer *)recognizer changeScale:(float)tinyScale
{
    UIView *imageView = recognizer.view;
    
    CGFloat scale;
    if (isTiny)
    {
        scale = 1.0 - (lastScale - tinyScale);
        isTiny = NO;
    }
    else
    {
        scale = 1.0 - (lastScale - [recognizer scale]);
    }
    
    if ([recognizer state] == UIGestureRecognizerStateEnded)
    {
        lastScale = 1.0;
        return;
    }
    
    CGAffineTransform newTransform = CGAffineTransformScale(imageView.transform, scale, scale);
    [imageView setTransform:newTransform];
    cropView.frame = imageView.frame;
    
    lastScale = [recognizer scale];
}

#pragma mark -
#pragma mark 旋转
- (void)rotateView:(UIRotationGestureRecognizer *)recognizer changeRotate:(float)tinyScale
{
    
    UIView *imageView = recognizer.view;
    CGFloat rotation;
    
    if (isTiny)
    {
        rotation = tinyScale;
        isTiny = NO;
    }
    else
    {
        rotation = 0.0 - (recordedRotation - [recognizer rotation]);
    }
    
    CGAffineTransform currentTransform = imageView.transform;
    CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform,rotation);
    [imageView setTransform:newTransform];
    
    recordedRotation = [recognizer rotation];
    if([recognizer state] == UIGestureRecognizerStateEnded) {
        recordedRotation = recordedRotation - [recognizer rotation];
    }
}

#pragma mark - private functions

- (void)addMagnifyingGlassTimer:(NSTimer*)timer {
	NSValue *v = timer.userInfo;
	CGPoint point = [v CGPointValue];
	[self addMagnifyingGlassAtPoint:point];
}

#pragma mark - magnifier functions
- (void)addMagnifyingGlassAtPoint:(CGPoint)point {
	
	if (!magnifyingGlass) {
		magnifyingGlass = [[ACMagnifyingGlass alloc] init];
	}
	
	if (!magnifyingGlass.viewToMagnify) {
		magnifyingGlass.viewToMagnify = self;
	}
	
	magnifyingGlass.touchPoint = point;
	[self.superview addSubview:magnifyingGlass];
	[magnifyingGlass setNeedsDisplay];
}

- (void)removeMagnifyingGlass {
	[magnifyingGlass removeFromSuperview];
}

- (void)updateMagnifyingGlassAtPoint:(CGPoint)point {
	magnifyingGlass.touchPoint = point;
	[magnifyingGlass setNeedsDisplay];
}

- (void)beginCropImage
{
    _imageView.image = self.image;
}

- (void)endCropImage
{
    UIImage *croppedImage = [cropView deleteBackgroundOfImage:_imageView];
    if (croppedImage == nil)
    {
        _imageView.image = _image;
    }
    else
    {
        _imageView.image = croppedImage;
    }
    self.magnifyingGlass.hidden = YES;
    cropView.userInteractionEnabled = NO;
}


@end
