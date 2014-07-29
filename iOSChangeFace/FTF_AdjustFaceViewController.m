//
//  FTF_AdjustFaceViewController.m
//  iOSChangeFace
//
//  Created by gaoluyangrc on 14-7-26.
//  Copyright (c) 2014年 rcplatform. All rights reserved.
//

#import "FTF_AdjustFaceViewController.h"
#import "UIImage+Zoom.h"
#import "CMethods.h"
#import "FTF_EditFaceViewController.h"


@interface FTF_AdjustFaceViewController ()
{
    float lastScale;
    double recordedRotation;
    UIImageView *libaryImageView;
}
@end

@implementation FTF_AdjustFaceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    libaryImageView = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)loadAdjustViews:(UIImage *)image
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, 320, 320)];
    backView.layer.masksToBounds = YES;
    [self.view addSubview:backView];
    
    //相册里选取的图片
    if (image.size.width > image.size.height)
    {
        libaryImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, image.size.height * (320.f/1080.f))];
    }
    else
    {
        libaryImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width * (320.f/1080.f), 320)];
    }
    libaryImageView.center = CGPointMake(160, 160);
    libaryImageView.userInteractionEnabled = YES;
    libaryImageView.image = [UIImage zoomImageWithImage:image];
    [self addGestureRecognizerToView:libaryImageView];
    [backView addSubview:libaryImageView];
    
    //脸图
    UIImageView *faceModelImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    faceModelImageView.image = [UIImage zoomImageWithImage:pngImagePath(@"focus")];
    [backView addSubview:faceModelImageView];
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
    translation = [recognizer translationInView:self.view];
    panView.center = CGPointMake(panView.center.x + translation.x, panView.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
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
    
    CGAffineTransform newTransform = CGAffineTransformScale(imageView.transform, scale, scale);
    [imageView setTransform:newTransform];
    
    lastScale = [recognizer scale];
}

- (void)rotateView:(UIRotationGestureRecognizer *)recognizer
{
    float rotation = recordedRotation - recognizer.rotation;
    libaryImageView.transform = CGAffineTransformMakeRotation(-rotation);
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        recordedRotation = rotation;
    }
}

- (void)rightItemClick:(UIBarButtonItem *)item
{
    FTF_EditFaceViewController *editFace = [[FTF_EditFaceViewController alloc] initWithNibName:@"FTF_EditFaceViewController" bundle:nil];
    editFace.libaryImage = libaryImageView.image;
    libaryImageView.transform = CGAffineTransformMakeRotation(0);
    editFace.imageRect = libaryImageView.frame;
    libaryImageView.transform = CGAffineTransformMakeRotation(-recordedRotation);
    editFace.rorationDegree = -recordedRotation;
    [self.navigationController pushViewController:editFace animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
