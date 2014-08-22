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
#import "CMethods.h"

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
	if (self = [super initWithFrame:frame])
    {
		self.magnifyingGlassShowDelay = kACMagnifyingViewDefaultShowDelay;
        lastScale = 1.f;
        acmRect = frame;
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
//    self.cropImageView = [[UIImageView alloc] initWithImage:imgView.image];
//    self.cropImageView.frame = imgView.frame;
    
    self.cropImageView = (UIImageView *)[self duplicate:imgView];
    
    imageViewRect = imgView.frame;
    for (UIGestureRecognizer *gesture in self.imageView.gestureRecognizers)
    {
        [self.imageView removeGestureRecognizer:gesture];
    }
    [self addGestureRecognizerToView:self.imageView];
    _image = nil;
    self.image = imgView.image;
    _cropImage = nil;
    _cropImage = imgView.image;
    [self addSubview:self.imageView];

    //抠图操作视图
    cropView = [[MZCroppableView alloc]initWithImageView:self.imageView];
    cropView.acView = self;
    cropView.userInteractionEnabled = NO;
    self.magnifyingGlass = [[ACMagnifyingGlass alloc] init];
    self.magnifyingGlass.hidden = YES;
    [self addSubview:cropView];
}

- (UIView*)duplicate:(UIView*)view
{
    NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:view];
    return [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
}

#pragma mark - touch events
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [FTF_Global shareGlobal].isChange = YES;
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
    cropView.userInteractionEnabled = YES;
}

- (void)setMZViewNotUserInteractionEnabled
{
    cropView.userInteractionEnabled = NO;
    _imageView.image = _cropImage;
    _cropImageView.image = _cropImage;
}

- (void)setMZImageView:(BOOL)isRestore
{
    if (isRestore)
    {
        _imageView.image = _cropImage;
        _cropImageView.image = _cropImage;
    }
    else
    {
        _imageView.image = _image;
        _cropImageView.image = _image;
        _cropImage = nil;
        _cropImage = _image;
    }
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

#pragma mark -
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark -
#pragma 移动缩放旋转
- (void)moveBtnClick:(NSInteger)tag
{
    if (tag == 0)
    {
        self.transform = CGAffineTransformMakeRotation(0);
        [self setFrame:acmRect];
        [self setTransform:CGAffineTransformMakeRotation([FTF_Global shareGlobal].rorationDegree)];
        [self.imageView setFrame:imageViewRect];
        self.imageView.image = _image;
        _cropImageView.image = _image;
        self.imageView.layer.shouldRasterize = NO;
        _cropImage = nil;
        _cropImage = _image;
        [cropView setFrame:imageViewRect];
        [FTF_Global shareGlobal].isCrop = NO;
    }
    else if (tag == 5 || tag == 6)
    {
        for (UIPinchGestureRecognizer *recognizer in self.imageView.gestureRecognizers)
        {
            if ([recognizer isKindOfClass:[UIPinchGestureRecognizer class]])
            {
                UIPinchGestureRecognizer *pin = (UIPinchGestureRecognizer *)recognizer;
                float scale = 1 + (tag == 5 ? 0.01 : -0.01);
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
                float scale = tag == 7 ? -0.006 : 0.006;
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
                    point = CGPointMake(0, tag == 2 ? -2 : 2);
                }
                else
                {
                    point = CGPointMake(tag == 1 ? -2 : 2, 0);
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
    [FTF_Global shareGlobal].isChange = YES;
    CGPoint translation;
    if (isTiny)
    {
        translation = point;
        isTiny = NO;
    }
    else
    {
        translation = [recognizer translationInView:self.superview];
    }
    self.center = CGPointMake(self.center.x + translation.x, self.center.y + translation.y);
    
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.superview];
}

#pragma mark -
#pragma mark 缩放
- (void)pinView:(UIPinchGestureRecognizer *)recognizer changeScale:(float)tinyScale
{
    [FTF_Global shareGlobal].isChange = YES;
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
    
    CGAffineTransform newTransform = CGAffineTransformScale(self.transform, scale, scale);
    [self setTransform:newTransform];
    
    lastScale = [recognizer scale];
}

#pragma mark -
#pragma mark 旋转
- (void)rotateView:(UIRotationGestureRecognizer *)recognizer changeRotate:(float)tinyScale
{
    _imageView.layer.shouldRasterize = YES;
    
    [FTF_Global shareGlobal].isChange = YES;
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

    CGAffineTransform cropTransform = self.transform;
    CGAffineTransform newCropTransform = CGAffineTransformRotate(cropTransform,rotation);
    [self setTransform:newCropTransform];
    
    recordedRotation = [recognizer rotation];
    if([recognizer state] == UIGestureRecognizerStateEnded)
    {
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
	[self.superview.superview addSubview:magnifyingGlass];
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
    _isCrop == YES ? self.magnifyingGlass.hidden = NO : self.magnifyingGlass.hidden = YES;
    _imageView.image = self.image;
    _cropImageView.image = _image;
}

- (void)endCropImage:(BOOL)isLast
{
    showMBProgressHUD(nil, YES);

    self.magnifyingGlass.hidden = YES;
    UIImage *croppedImage = nil;
    if ([FTF_Global shareGlobal].isCrop)
    {
        if ([[NSRunLoop mainRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate date]])
        {
            croppedImage = [cropView deleteBackgroundOfImage:_cropImageView isLastPath:isLast];
        }
    }
    
    if (croppedImage == nil)
    {
        _imageView.image = _image;
        _cropImageView.image = _image;
        _cropImage = nil;
        _cropImage = _image;
        
    }
    else
    {
        _cropImage = nil;
        _cropImage = croppedImage;
        _imageView.image = croppedImage;
        _cropImageView.image = croppedImage;
        cropView.userInteractionEnabled = NO;
    }
    
    hideMBProgressHUD();
}

- (void)changeMagnifyingGlassCenter:(CGPoint)center
{
    [self.magnifyingGlass setCenter:center];
}

@end
