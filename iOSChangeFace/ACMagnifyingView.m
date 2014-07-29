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


- (id)initWithFrame:(CGRect)frame {
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
    
    self.imageView = imgView;
    [self addGestureRecognizerToView:self.imageView];
    self.image = imgView.image;
    [self addSubview:self.imageView];
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
    [pan addTarget:self action:@selector(panView:)];
    [view addGestureRecognizer:pan];
    
    UIPinchGestureRecognizer *pin = [[UIPinchGestureRecognizer alloc] init];
    [pin addTarget:self action:@selector(pinView:)];
    [view addGestureRecognizer:pin];
    
    UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateView:)];
    [view addGestureRecognizer:rotationGesture];
}

- (void)panView:(UIPanGestureRecognizer *)recognizer
{
    UIView *panView = recognizer.view;
    CGPoint translation;
    translation = [recognizer translationInView:self];
    panView.center = CGPointMake(panView.center.x + translation.x, panView.center.y + translation.y);
    cropView.center = CGPointMake(cropView.center.x + translation.x, cropView.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self];
}

- (void)pinView:(UIPinchGestureRecognizer *)recognizer
{
    UIView *imageView = recognizer.view;
    CGFloat scale = 1.0 - (lastScale - [recognizer scale]);
    
    if ([recognizer state] == UIGestureRecognizerStateEnded)
    {
        lastScale = 1.0;
        return;
    }
    
    CGAffineTransform imageViewTransform = CGAffineTransformScale(imageView.transform, scale, scale);
    [imageView setTransform:imageViewTransform];
    cropView.frame = imageView.frame;
    
    lastScale = [recognizer scale];
}

- (void)rotateView:(UIRotationGestureRecognizer *)recognizer
{
    float rotation = recordedRotation - recognizer.rotation;//recordedRotation自己定义的double类型变量
    _imageView.transform = CGAffineTransformMakeRotation(-rotation); //self 是view
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        recordedRotation = rotation; //获取了 当前旋转的弧度值
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
