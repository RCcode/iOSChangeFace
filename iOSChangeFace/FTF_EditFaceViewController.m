//
//  FTF_EditFaceViewController.m
//  iOSChangeFace
//
//  Created by gaoluyangrc on 14-7-28.
//  Copyright (c) 2014年 rcplatform. All rights reserved.
//

#define UIColorFromHexAlpha(hexValue, a) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:a]
#define BtnWidth 64.f
#define BtnHeight 50.f
#define ItoolsBackHeight 104.f

#import "FTF_EditFaceViewController.h"
#import "UIImage+Zoom.h"
#import "CMethods.h"
#import "FTF_Global.h"
#import "FTF_Button.h"
#import "RC_View.h"
#import "MZCroppableView.h"
#import "ACMagnifyingView.h"
#import "FTF_MaterialView.h"
#import "FTF_DirectionView.h"
#import "FTF_MaterialViewController.h"
#import "ME_ShareViewController.h"

@interface FTF_EditFaceViewController ()
{
    UIView *bottomView;//底图
    enum DirectionType directionStyle;
    NSMutableArray *colorArray;
    CAGradientLayer *maskLayer;//模糊层
    UIImageView *libaryImageView;
    UIView *acBackView;//放大镜背景图
    ACMagnifyingView *backView;//放大镜操作图
    UIImageView *backImageView;
    NSArray *dataArray;
    FTF_DirectionView *detailView;//辅工具栏
    UIImageView *fuzzyImage;//模糊图片
    NCVideoCamera *_videoCamera;
    NSArray *directionArray;
    NSArray *fuzzyArray;
    NSArray *modelArray;
    NSMutableArray *filterImageArray;
    CGPoint last_Position;
}
@property (nonatomic ,strong) UISlider *modelSlider;
@property (nonatomic ,strong) UISlider *cropSlider;

@end

@implementation FTF_EditFaceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        directionArray = @[@"edit_normal",@"edit_left",@"edit_up",@"edit_right",@"edit_down",@"edit_big",@"edit_small",@"edit_ronateleft",@"edit_ronateright"];
        fuzzyArray = @[@"beauty_normal",@"beauty_small",@"beauty_middle",@"beauty_big"];
        modelArray = @[@"switch_left",@"switch_right",@"switch_up",@"switch_down"];
        filterImageArray = [NSMutableArray arrayWithCapacity:0];
        last_Position = CGPointMake(160, 160);
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //showLoadingView();
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endCropImage) name:@"EndCropImage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginCropImage) name:@"BeginCropImage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scaleEditImage) name:@"scaleImage" object:nil];
    
    _videoCamera = [NCVideoCamera videoCamera];
    _videoCamera.delegate = self;
    
    UIImageView *blur = [[UIImageView alloc] initWithFrame:self.view.bounds];
    blur.userInteractionEnabled = YES;
    UIEdgeInsets ed = {0.0f, 10.0f, 0.0f, 10.0f};
    UIImage *newImage = [pngImagePath(@"bg") resizableImageWithCapInsets:ed resizingMode:UIImageResizingModeTile];
    blur.image = newImage;
    [self.view addSubview:blur];
    
    [self addNavItem];
    [self layoutSubViews];
    [self addDetailItools];

}

- (void)removeGuideView
{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    UIView *guideView = [window viewWithTag:1001];
    [guideView removeFromSuperview];
    guideView = nil;
}

- (void)addNavItem
{
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
    homeBtn.tag = 0;
    homeBtn.frame = CGRectMake(44, 0, 44, 44);
    [homeBtn setImage:pngImagePath(@"btn_home_normal") forState:UIControlStateNormal];
    [homeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0,0, -16)];
    [homeBtn setImage:pngImagePath(@"btn_home_pressed") forState:UIControlStateHighlighted];
    [homeBtn addTarget:self action:@selector(homeItemClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:homeBtn];
    
    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSeperator.width = -16;
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.tag = 1;
    shareBtn.frame = CGRectMake(0, 0, 44, 44);
    [shareBtn setImage:pngImagePath(@"btn_share_normal") forState:UIControlStateNormal];
    [shareBtn setImage:pngImagePath(@"btn_share_pressed") forState:UIControlStateHighlighted];
    [shareBtn addTarget:self action:@selector(shareItemClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];

    [self.navigationItem setRightBarButtonItems:@[negativeSeperator,shareItem,btnItem]];
    
}

#pragma mark -
#pragma mark 初始化工具栏
- (void)addDetailItools
{

    UIView *toolBarView = [[UIView alloc] initWithFrame:CGRectMake(0, windowHeight() - (iPhone5()?144:94), 320, BtnHeight)];
    toolBarView.backgroundColor = colorWithHexString(@"#202225", 1.0);
    [self.view addSubview:toolBarView];
    
    dataArray = @[@[@"icon_fodder_normal",@"icon_switch_normal",@"icon_adjust_normal",@"icon_beautify_normal",@"icon_filter_normal"],
                  @[@"icon_fodder_pressed",@"icon_switch_pressed",@"icon_adjust_pressed",@"icon_beautify_pressed",@"icon_filter_pressed"]];
    
    int i = 0;
    while (i < 5)
    {
        FTF_Button *btn = [[FTF_Button alloc] initWithFrame:CGRectMake(BtnWidth * i, 0, BtnWidth, BtnHeight)];
        btn.toolImageView.frame = CGRectMake((BtnWidth - 30)/2, 10, 30, 30);
        btn.toolImageView.image = pngImagePath([dataArray[0] objectAtIndex:i]);
        btn.normelName = [dataArray[0] objectAtIndex:i];
        btn.selectName = [dataArray[1] objectAtIndex:i];
        if (i == 1)
        {
            [btn changeBtnImage];
        }
        btn.tag = i;
        [btn addTarget:self action:@selector(toolBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [toolBarView addSubview:btn];
        i++;
    }

    detailView = [[FTF_DirectionView alloc]initWithFrame:CGRectMake(0, windowHeight() - (iPhone5()?248:198), 320, 104)];
    detailView.delegate = self;
    [detailView loadModelStyleItools];
    [self.view addSubview:detailView];
}

#pragma mark -
#pragma mark 初始化视图
- (void)layoutSubViews
{
    colorArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < 240; i++)
    {
        if (i < 120)
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
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    bottomView.layer.masksToBounds = YES;
    [self.view addSubview:bottomView];
    
    //默认底图
    backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    [FTF_Global shareGlobal].modelImage = [UIImage zoomImageWithImage:[UIImage imageNamed:@"crossBones01.jpg"]];
    backImageView.image = [FTF_Global shareGlobal].modelImage;
    [bottomView addSubview:backImageView];;
    
    //放大镜
    acBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    acBackView.layer.masksToBounds = YES;
    backView = [[ACMagnifyingView alloc] initWithFrame:_imageRect];
    backView.transform = CGAffineTransformMakeRotation([FTF_Global shareGlobal].rorationDegree);
    [acBackView addSubview:backView];
    [bottomView addSubview:acBackView];
    
    //从相册中选取的图片
    libaryImageView = [[UIImageView alloc]initWithFrame:backView.bounds];
    libaryImageView.userInteractionEnabled = YES;
    
    [self adjustViews:_libaryImage];
}

- (void)backItemClick:(UIBarButtonItem *)item
{
    if ([FTF_Global shareGlobal].isChange)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:LocalizedString(@"saveOrBack", @"")
                                                       delegate:self
                                              cancelButtonTitle:LocalizedString(@"cancel", @"")
                                              otherButtonTitles:LocalizedString(@"dialog_sure", @""),nil];
        alert.tag = 11;
        [alert show];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)homeItemClick:(UIBarButtonItem *)item
{
    [FTF_Global event:@"Edit" label:@"edit_home"];
    
    if ([FTF_Global shareGlobal].isChange)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:LocalizedString(@"saveOrBack", @"")
                                                       delegate:self
                                              cancelButtonTitle:LocalizedString(@"cancel", @"")
                                              otherButtonTitles:LocalizedString(@"dialog_sure", @""),nil];
        alert.tag = 11;
        [alert show];
    }
    else
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 11 && buttonIndex == 1)
    {
        [FTF_Global shareGlobal].isChange = NO;
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (alertView.tag == 12 && buttonIndex == 1)
    {
        [FTF_Global shareGlobal].isChange = NO;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)shareItemClick:(UIBarButtonItem *)item
{
    [FTF_Global event:@"Edit" label:@"edit_share"];
    ME_ShareViewController *shareController = [[ME_ShareViewController alloc]initWithNibName:@"ME_ShareViewController" bundle:nil];
    [self.navigationController pushViewController:shareController animated:YES];
}

#pragma mark -
#pragma mark 工具栏点击事件
- (void)toolBtnClick:(FTF_Button *)btn
{
    for (UIView *subView in [btn.superview subviews])
    {
        if ([subView isKindOfClass:[FTF_Button class]])
        {
            FTF_Button *button = (FTF_Button *)subView;
            [button btnHaveClicked];
        }
    }
    
    [btn changeBtnImage];
    libaryImageView.userInteractionEnabled = YES;
    [backView setMZViewNotUserInteractionEnabled];
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
        {
            detailView.frame = CGRectMake(0, windowHeight() - (iPhone5()?248:198), 320, 104);
            [detailView loadModelStyleItools];
        }
            break;
        case 2:
            detailView.frame = CGRectMake(0, windowHeight() - (iPhone5()?248:198), 320, 104);
            [detailView loadDirectionItools];
            break;
        case 3:

            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isFirst"] == nil)
            {
                
                //引导动画
                UIWindow *window = [[UIApplication sharedApplication].delegate window];
                RC_View *guideView = [[RC_View alloc]initWithFrame:window.bounds];
                guideView.tag = 1001;
                guideView.editFace = self;
                guideView.backgroundColor = [UIColor clearColor];
                [window addSubview:guideView];
                
                [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:@"isFirst"];
            }
            
            libaryImageView.userInteractionEnabled = NO;
            detailView.frame = CGRectMake(0, windowHeight() - (iPhone5()?248:198), 320, 104);
            [detailView loadCropItools];
            
            [backView setMZViewUserInteractionEnabled];
            [backView setMZImageView:YES];
            
            break;
        case 4:
            detailView.frame = CGRectMake(0, windowHeight() - (iPhone5()?248:198), 320, 104);
            [detailView loadFilerItools];
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark 初始化视图
- (void)adjustViews:(UIImage *)image
{

    libaryImageView.image = _libaryImage;
    [backView loadCropImageView:libaryImageView];
    
    //模糊图层
    maskLayer.frame = CGRectMake(0, 0, 5760, 5760);
    maskLayer.position = CGPointMake(160, 160);
    
    if (directionStyle == leftToRight)
    {
        maskLayer.startPoint = CGPointMake(0, 0.5);
        maskLayer.endPoint = CGPointMake(1, 0.5);
        [backView changeMagnifyingGlassCenter:CGPointMake(275, 45)];
    }
    else if (directionStyle == rightToLeft)
    {
        maskLayer.startPoint = CGPointMake(1, 0.5);
        maskLayer.endPoint = CGPointMake(0, 0.5);
        [backView changeMagnifyingGlassCenter:CGPointMake(45, 45)];
    }
    else if (directionStyle ==  topToBottom)
    {
        maskLayer.startPoint = CGPointMake(0.5, 0);
        maskLayer.endPoint = CGPointMake(0.5, 1);
        [backView changeMagnifyingGlassCenter:CGPointMake(45, 275)];
    }
    else if (directionStyle == bottomToTop)
    {
        maskLayer.startPoint = CGPointMake(0.5, 1);
        maskLayer.endPoint = CGPointMake(0.5, 0);
        [backView changeMagnifyingGlassCenter:CGPointMake(275, 45)];
    }
    
    maskLayer.colors = colorArray;
    [acBackView.layer setMask:maskLayer];
}

#pragma mark -
#pragma mark 切换显示方式
- (void)changeModelBtnClick:(NSInteger)tag
{
    
    directionStyle = (enum DirectionType)tag;
    detailView.direction_Type = (enum DirectionType)tag;
    
    self.modelSlider.value = 0.5f;
    [detailView setVolumeSlideValue:0.2f];
    
    [colorArray removeAllObjects];
    for (int i = 0; i < 240; i++)
    {
        if (directionStyle == leftToRight || directionStyle == topToBottom)
        {
            if (i < 120)
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
            if (i < 120) {
                [colorArray addObject:(id)[UIColorFromHexAlpha(0xffffff, 1) CGColor]];
            }
            else
            {
                [colorArray addObject:(id)[UIColorFromHexAlpha(0xffffff, 0) CGColor]];
            }
        }
        
    }
    
    if ([FTF_Global shareGlobal].isCrop)
    {
        [backView moveBtnClick:0];
    }
    [self adjustViews:_libaryImage];

}

#pragma mark -
#pragma mark 添加模糊图层
- (void)addFuzzyView:(NSInteger)tag
{
    if (tag == 0)
    {
        [FTF_Global shareGlobal].isCrop = NO;
        [backView setMZViewUserInteractionEnabled];
        [backView setMZImageView:NO];
    }
    else
    {
        detailView.model_Type = (enum ModelType)tag;
        if (fuzzyImage == nil)
        {
            fuzzyImage = [[UIImageView alloc] initWithFrame:bottomView.bounds];
            [bottomView addSubview:fuzzyImage];
        }
        fuzzyImage.image = pngImagePath([NSString stringWithFormat:@"shadow%ld",(long)tag]);
    }
}

#pragma mark -
#pragma mark 合成图片
- (void)scaleEditImage
{
    UIImageView *waterView = nil;
    
    if ([FTF_Global shareGlobal].isOn)
    {
        NSArray *imageArray = @[pngImagePath(@"skull"),pngImagePath(@"mask"),pngImagePath(@"animal"),pngImagePath(@"women"),pngImagePath(@"other")];
        
        int model = (int)[FTF_Global shareGlobal].modelType;
        UIImage *waterImage = imageArray[model];
        float width = waterImage.size.width;
        float height = waterImage.size.height;
        float x = 320.f - width;
        float y = 320.f - height;
        
        waterView = [[UIImageView alloc]initWithFrame:CGRectMake(x, y, width, height)];
        waterView.image = imageArray[model];
        [bottomView addSubview:waterView];
    }
    
    CGSize size = bottomView.frame.size;
    CGFloat scale = 3.375f;
    size = CGSizeApplyAffineTransform(size, CGAffineTransformMakeScale(scale, scale));

    UIGraphicsBeginImageContext(size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(context, scale, scale);
    
    [bottomView.layer renderInContext:context];

    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [waterView removeFromSuperview];
    waterView = nil;
    
    //保存
    [FTF_Global shareGlobal].bigImage = viewImage;
    [FTF_Global shareGlobal].isChange = NO;
    
}

#pragma mark -
#pragma mark 滤镜
- (void)filterImage:(NSInteger)tag
{
    
    detailView.filter_Type = (NCFilterType)tag;
    dispatch_queue_t myQueue = dispatch_queue_create("my_filter_queue", nil);
    [NSThread sleepForTimeInterval:0.3];
    
    MBProgressHUD *mb = showMBProgressHUD(nil, YES);
    mb.userInteractionEnabled = YES;
    
    [filterImageArray removeAllObjects];
    
    dispatch_async(myQueue, ^{
        @autoreleasepool {
            [_videoCamera setImages:@[[FTF_Global shareGlobal].compressionImage,[FTF_Global shareGlobal].modelImage] WithFilterType:(NCFilterType)tag];
        }
    });
}

- (void)endCropImage
{
    if (iPhone4())
    {
        detailView.hidden = NO;
    }
    [FTF_Global shareGlobal].isCrop = YES;
    [backView endCropImage:NO];
}

#pragma mark -
#pragma mark 开始划线
- (void)beginCropImage
{
    if (iPhone4())
    {
        detailView.hidden = YES;
    }
    [backView beginCropImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark 调整模糊位置和模糊度
- (void)sliderValueChanged:(UISlider *)slider
{

    switch (slider.tag) {
        case 0:
        {
            if (directionStyle == leftToRight || directionStyle == rightToLeft)
            {
                maskLayer.position = CGPointMake(160 + 320 * (slider.value - 0.5f), 160);
            }
            else if (directionStyle == topToBottom || directionStyle == bottomToTop)
            {
                maskLayer.position = CGPointMake(160, 160 + 320 * (slider.value - 0.5f));
            }
            last_Position = maskLayer.position;
        }
            break;
        case 1:
        {
            float endSize = 640 + 25600 * slider.value;
            maskLayer.frame = CGRectMake(0, 0, endSize, endSize);
            maskLayer.position = last_Position;
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
    backImageView.image = [FTF_Global shareGlobal].modelImage;
    backImageView.center = CGPointMake(160, 160);
}

#pragma mark -
#pragma mark DirectionDelegate
- (void)directionBtnClick:(NSUInteger)tag
{
    [FTF_Global shareGlobal].isChange = YES;
    if (tag < 9)
    {
        [FTF_Global event:directionArray[tag] label:@"Edit"];
        [backView moveBtnClick:tag];
    }
    else if (tag == 10 || tag == 11 || tag == 12 || tag == 13)
    {
        [FTF_Global event:modelArray[tag - 10] label:@"Edit"];
        [self changeModelBtnClick:tag - 10];
    }
    else if (tag == 20 || tag == 21 || tag == 22 || tag == 23)
    {
        [FTF_Global event:fuzzyArray[tag - 20] label:@"Edit"];
        [self addFuzzyView:tag - 20];
    }
    else if (tag >= 100)
    {
        [FTF_Global event:[NSString stringWithFormat:@"filter_%d",(int)tag - 100] label:@"Edit"];
        [self filterImage:tag - 100];
    }
}

- (void)directionSlider:(UISlider *)slider
{
    [FTF_Global shareGlobal].isChange = YES;
    if (slider.tag == 0)
    {
        self.modelSlider = slider;
    }
    else if (slider.tag == 1)
    {
        self.cropSlider = slider;
    }
    [self sliderValueChanged:slider];
}

#pragma mark - NCVideoCameraDelegate
- (void)videoCameraDidFinishFilter:(UIImage *)image Index:(NSUInteger)index
{
    [filterImageArray addObject:image];
    if (index == 1)
    {
        UIImage *customImage = filterImageArray[0];
        self.libaryImage = nil;
        self.libaryImage = customImage;
        backView.image = nil;
        backView.image = customImage;
        backView.cropImage = customImage;
        libaryImageView.image = customImage;
        
        [backView endCropImage:YES];
        
        UIImage *modelImage = filterImageArray[1];
        backImageView.image = nil;
        backImageView.image = modelImage;
    }
    hideMBProgressHUD();
    //stopLoadingView();
}

@end
