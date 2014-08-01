//
//  FTF_EditFaceViewController.m
//  iOSChangeFace
//
//  Created by gaoluyangrc on 14-7-28.
//  Copyright (c) 2014年 rcplatform. All rights reserved.
//

enum DirectionType
{
    leftToRight = 0,
    rightToLeft,
    topToBottom,
    bottomToTop,
};

#define UIColorFromHexAlpha(hexValue, a) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:a]

#import "FTF_EditFaceViewController.h"
#import "UIImage+Zoom.h"
#import "CMethods.h"
#import "FTF_Global.h"
#import "MZCroppableView.h"
#import "ACMagnifyingView.h"
#import "ACMagnifyingGlass.h"
#import "FTF_MaterialViewController.h"

@interface FTF_EditFaceViewController ()
{
    UIView *bottomView;
    enum DirectionType directionStyle;
    NSMutableArray *colorArray;
    CAGradientLayer *maskLayer;
    UIImageView *libaryImageView;
    ACMagnifyingView *backView;
    ACMagnifyingGlass *mag;
    UIImageView *backImageView;
}
@property (weak, nonatomic) IBOutlet UISlider *positionSlider;
@property (weak, nonatomic) IBOutlet UISlider *fuzzySlider;

- (IBAction)sliderValueChanged:(id)sender;
@end

@implementation FTF_EditFaceViewController

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
    bottomView = nil;
    colorArray = nil;
    maskLayer = nil;
    _libaryImage = nil;
    libaryImageView = nil;
    backView = nil;
    mag = nil;
    backImageView = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"素材" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endCropImage) name:@"EndCropImage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginCropImage) name:@"BeginCropImage" object:nil];
    
    colorArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < 24; i++)
    {
        if (i < 11) {
            [colorArray addObject:(id)[UIColorFromHexAlpha(0xffffff, 1) CGColor]];
        }
        else
        {
            [colorArray addObject:(id)[UIColorFromHexAlpha(0xffffff, 0) CGColor]];
        }
    }
    
    directionStyle = leftToRight;
    //模糊图层
    maskLayer = [CAGradientLayer layer];
    //背景view
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, 320, 320)];
    [self.view addSubview:bottomView];
    
    //默认底图
    backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    backImageView.image = [UIImage zoomImageWithImage:[UIImage imageNamed:@"crossBones01.jpg"]];
    [bottomView addSubview:backImageView];
    
    //放大镜
    backView = [[ACMagnifyingView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    //放大操作显示框
    mag = [[ACMagnifyingGlass alloc] initWithFrame:CGRectMake(0, 0, 90, 90)];
    mag.scale = 1.5;
    backView.magnifyingGlass = mag;
    backView.layer.masksToBounds = YES;
    [bottomView addSubview:backView];
    
    //从相册中选取的图片
    libaryImageView = [[UIImageView alloc]initWithFrame:_imageRect];
    libaryImageView.layer.shouldRasterize = YES;
    libaryImageView.userInteractionEnabled = YES;
    
    [self adjustViews:_libaryImage withFrame:_imageRect];
}

- (void)rightItemClick:(UIBarButtonItem *)item
{
    FTF_MaterialViewController *materialController = [[FTF_MaterialViewController alloc] initWithNibName:@"FTF_MaterialViewController" bundle:nil];
    materialController.delegate = self;
    [self.navigationController pushViewController:materialController animated:YES];
}

- (void)adjustViews:(UIImage *)image withFrame:(CGRect)rect
{

    libaryImageView.image = [UIImage zoomImageWithImage:_libaryImage];
    [backView loadCropImageView:libaryImageView];
    
    //模糊图层
    maskLayer.frame = CGRectMake(0, 0, 640, 640);
    
    if (directionStyle == leftToRight)
    {
        maskLayer.startPoint = CGPointMake(0, 0.5);
        maskLayer.endPoint = CGPointMake(1, 0.5);
        maskLayer.position = CGPointMake(180, 160);
        mag.center = CGPointMake(275, 45);
    }
    else if (directionStyle == rightToLeft)
    {
        maskLayer.startPoint = CGPointMake(1, 0.5);
        maskLayer.endPoint = CGPointMake(0, 0.5);
        maskLayer.position = CGPointMake(140, 160);
        mag.center = CGPointMake(45, 45);
    }
    else if (directionStyle ==  topToBottom)
    {
        maskLayer.startPoint = CGPointMake(0.5, 0);
        maskLayer.endPoint = CGPointMake(0.5, 1);
        maskLayer.position = CGPointMake(160, 180);
        mag.center = CGPointMake(45, 275);
    }
    else if (directionStyle == bottomToTop)
    {
        maskLayer.startPoint = CGPointMake(0.5, 1);
        maskLayer.endPoint = CGPointMake(0.5, 0);
        maskLayer.position = CGPointMake(160, 140);
        mag.center = CGPointMake(275, 45);
    }
    
    maskLayer.colors = colorArray;
    [backView.layer setMask:maskLayer];
}

- (IBAction)btnClick:(id)sender
{

    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 0 || btn.tag == 1 || btn.tag == 2 || btn.tag == 3)
    {
        directionStyle = (enum DirectionType)btn.tag;
        
        self.fuzzySlider.value = 0;
        self.positionSlider.value = 0.5f;
        
        [colorArray removeAllObjects];
        for (int i = 0; i < 24; i++)
        {
            if (directionStyle == leftToRight || directionStyle == topToBottom)
            {
                if (i < 11) {
                    [colorArray addObject:(id)[UIColorFromHexAlpha(0xffffff, 1) CGColor]];
                }
                else
                {
                    [colorArray addObject:(id)[UIColorFromHexAlpha(0xffffff, 0) CGColor]];
                }
            }
            else if (directionStyle == rightToLeft || directionStyle == bottomToTop)
            {
                if (i < 11) {
                    [colorArray addObject:(id)[UIColorFromHexAlpha(0xffffff, 1) CGColor]];
                }
                else
                {
                    [colorArray addObject:(id)[UIColorFromHexAlpha(0xffffff, 0) CGColor]];
                }
            }
        }

        [self adjustViews:_libaryImage withFrame:_imageRect];
    }
    else if (btn.tag == 4)
    {
        [backView setMZViewUserInteractionEnabled];
        [backView setMZImageView];
    }
    else if (btn.tag == 5)
    {
        [backView setMZViewNotUserInteractionEnabled];
    }

}

- (void)endCropImage
{
    [backView endCropImage];
}

- (void)beginCropImage
{
    [backView beginCropImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)sliderValueChanged:(id)sender
{
    UISlider *slider = (UISlider *)sender;
    NSString *str = [NSString stringWithFormat:@"%f",slider.value];
    int number;
    if ([str floatValue] == 1.f)
    {
        number = 10;
    }
    else
    {
        number = [[str substringWithRange:NSMakeRange(2, 1)] intValue];
    }
    
    switch (slider.tag) {
        case 0:
        {
            if (directionStyle == leftToRight)
            {
                maskLayer.position = CGPointMake(180 + 280 * (slider.value - 0.5), 160);
            }
            else if (directionStyle == rightToLeft)
            {
                maskLayer.position = CGPointMake(140 + 280 * (slider.value - 0.5), 160);
            }
            else if (directionStyle == topToBottom)
            {
                maskLayer.position = CGPointMake(160, 180 + 280 * (slider.value - 0.5));
            }
            else if (directionStyle == bottomToTop)
            {
                maskLayer.position = CGPointMake(160, 140 + 280 * (slider.value - 0.5));
            }
        }
            break;
        case 1:
        {
            float endSize = 640 + 2560 * slider.value;
            maskLayer.frame = CGRectMake(0, 0, endSize, endSize);
            
            maskLayer.position = CGPointMake((directionStyle == leftToRight ? 180 : 140) + (directionStyle == leftToRight ? (endSize - 640)/24 : -(endSize - 640)/24) , (directionStyle == topToBottom ? 180 : 140) + (directionStyle == topToBottom ? (endSize - 640)/24 : -(endSize - 640)/24));
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -
#pragma mark ChangeModelDelegate
- (void)changeModelImage
{
    if ([FTF_Global shareGlobal].isFromLibary)
    {
        backImageView.image = [FTF_Global shareGlobal].modelImage;
    }
    else
    {
        backImageView.image = [UIImage zoomImageWithImage:jpgImagePath([FTF_Global shareGlobal].modelImageName)];
    }
    backImageView.center = CGPointMake(160, 160);
}

@end
