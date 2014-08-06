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
#define BtnWidth 64.f
#define BtnHeight 50.f
#define ItoolsBackHeight 104.f

#import "FTF_EditFaceViewController.h"
#import "UIImage+Zoom.h"
#import "CMethods.h"
#import "FTF_Global.h"
#import "FTF_Button.h"
#import "MZCroppableView.h"
#import "ACMagnifyingView.h"
#import "ACMagnifyingGlass.h"
#import "FTF_MaterialViewController.h"

@interface FTF_EditFaceViewController ()
{
    UIView *bottomView;//底图
    enum DirectionType directionStyle;
    NSMutableArray *colorArray;
    CAGradientLayer *maskLayer;//模糊层
    UIImageView *libaryImageView;
    ACMagnifyingView *backView;//放大镜操作图
    ACMagnifyingGlass *mag;//放大镜显示框
    UIImageView *backImageView;
    NSArray *dataArray;
    
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
    dataArray = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 129, 44);
    [backBtn setImage:pngImagePath(@"btn_back_normal") forState:UIControlStateNormal];
    [backBtn setImage:pngImagePath(@"btn_back_pressed") forState:UIControlStateHighlighted];
    backBtn.imageView.contentMode = UIViewContentModeCenter;
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -32, 0, 0);
    [backBtn addTarget:self action:@selector(backItemClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    homeBtn.frame = CGRectMake(0, 0, 44, 44);
    [homeBtn setImage:pngImagePath(@"btn_home_normal") forState:UIControlStateNormal];
    [homeBtn setImage:pngImagePath(@"btn_home_pressed") forState:UIControlStateHighlighted];
    [homeBtn addTarget:self action:@selector(homeItemClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *homeItem = [[UIBarButtonItem alloc] initWithCustomView:homeBtn];
    
    UIButton *cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cameraBtn.frame = CGRectMake(0, 0, 44, 44);
    [cameraBtn setImage:pngImagePath(@"btn_ig_normal") forState:UIControlStateNormal];
    [cameraBtn setImage:pngImagePath(@"btn_ig_pressed") forState:UIControlStateHighlighted];
    [cameraBtn addTarget:self action:@selector(cameraItemClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cameraItem = [[UIBarButtonItem alloc] initWithCustomView:cameraBtn];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(0, 0, 44, 44);
    [shareBtn setImage:pngImagePath(@"btn_share_normal") forState:UIControlStateNormal];
    [shareBtn setImage:pngImagePath(@"btn_share_pressed") forState:UIControlStateHighlighted];
    [shareBtn addTarget:self action:@selector(shareItemClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    
    NSArray *actionButtonItems = @[shareItem,cameraItem,homeItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endCropImage) name:@"EndCropImage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginCropImage) name:@"BeginCropImage" object:nil];
    
    UIView *toolBarView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 164, 320, BtnHeight)];
    toolBarView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:toolBarView];
    
    dataArray = @[@[@"icon_fodder_normal",@"icon_switch_normal",@"icon_beautify_normal",@"icon_adjust_normal",@"icon_filter_normal"],
                  @[@"icon_fodder_pressed",@"icon_switch_pressed",@"icon_beautify_pressed",@"icon_adjust_pressed",@"icon_filter_pressed"]];
    
    int i = 0;
    while (i < 5)
    {
        FTF_Button *btn = [[FTF_Button alloc] initWithFrame:CGRectMake(BtnWidth * i, 0, BtnWidth, BtnHeight)];
        btn.toolImageView.frame = CGRectMake((BtnWidth - 30)/2, 10, 30, 30);
        btn.toolImageView.image = pngImagePath([dataArray[0] objectAtIndex:i]);
        btn.normelName = [dataArray[0] objectAtIndex:i];
        btn.selectName = [dataArray[1] objectAtIndex:i];
        btn.tag = i;
        [btn addTarget:self action:@selector(toolBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [toolBarView addSubview:btn];
        i++;
    }

    colorArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < 24; i++)
    {
        if (i < 11)
        {
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
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 16, 320, 320)];
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

#pragma mark -
#pragma mark 返回
- (void)backItemClick:(UIBarButtonItem *)item
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark 跳回主页
- (void)homeItemClick:(UIBarButtonItem *)item
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark 打开相册
- (void)cameraItemClick:(UIBarButtonItem *)item
{
    
}

#pragma mark -
#pragma mark 分享
- (void)shareItemClick:(UIBarButtonItem *)item
{
    
}

#pragma mark -
#pragma mark 工具栏
- (void)toolBtnClick:(FTF_Button *)btn
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeImage" object:nil];
    [btn changeBtnImage];
    switch (btn.tag) {
        case 0:
        {
            FTF_MaterialViewController *materialController = [[FTF_MaterialViewController alloc] initWithNibName:@"FTF_MaterialViewController" bundle:nil];
            materialController.delegate = self;
            [self.navigationController pushViewController:materialController animated:YES];
            [btn performSelector:@selector(btnHaveClicked) withObject:nil afterDelay:.15f];

        }
            break;
        case 1:
            
            break;
        case 2:
            
            break;
        case 3:
            
            break;
        case 4:
            
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark 初始化视图
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
                if (i < 11)
                {
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

#pragma mark -
#pragma mark 剪切
- (void)endCropImage
{
    [backView endCropImage];
}

#pragma mark -
#pragma mark 开始划线
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
