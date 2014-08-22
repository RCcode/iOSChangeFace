//
//  FTF_MaterialViewController.m
//  iOSChangeFace
//
//  Created by gaoluyangrc on 14-7-30.
//  Copyright (c) 2014年 rcplatform. All rights reserved.
//

#import "FTF_MaterialViewController.h"
#import "FTF_MaterialView.h"
#import "CMethods.h"
#import "UIImage+Zoom.h"
#import "FTF_Global.h"
#import "FTF_Button.h"

@interface FTF_MaterialViewController ()
{
    UIView *amb;
}
@end

@implementation FTF_MaterialViewController

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
    amb = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _videoCamera = [NCVideoCamera videoCamera];
    _videoCamera.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeMaterialImage) name:@"changeMaterialImage" object:nil];

    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"guideIsFirst"] == nil)
    {
        //引导动画
        UIWindow *window = [[UIApplication sharedApplication].delegate window];
        UIView *guideView = [[UIView alloc]initWithFrame:window.bounds];
        guideView.tag = 1002;
        guideView.backgroundColor = colorWithHexString(@"#202225", 0.6);
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handelTap)];
        [tapGes setNumberOfTapsRequired:1];//点击次数
        [guideView addGestureRecognizer:tapGes];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(252, 50, 45, 45)];
        imageView.image = [UIImage imageNamed:@"jiantou"];
        [guideView addSubview:imageView];
        
        [window addSubview:guideView];
        
        UILabel *shotLabel = [[UILabel alloc]init];
        shotLabel.numberOfLines = 0;
        shotLabel.tag = 1003;
        shotLabel.lineBreakMode = NSLineBreakByWordWrapping;
        CGSize size = sizeWithContentAndFont(LocalizedString(@"UseYourself", @""), CGSizeMake(160, 100), 16);
        shotLabel.frame = CGRectMake(0, 0, size.width, size.height);
        shotLabel.center = CGPointMake(230 - size.width/2, 96);
        shotLabel.text = LocalizedString(@"UseYourself", @"");
        shotLabel.textColor = [UIColor whiteColor];
        shotLabel.font = [UIFont systemFontOfSize:14.f];
        [window addSubview:shotLabel];
        
        [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:@"guideIsFirst"];
    }
    
    //返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 129, 44);
    [backBtn setImage:pngImagePath(@"btn_back_normal") forState:UIControlStateNormal];
    [backBtn setImage:pngImagePath(@"btn_back_pressed") forState:UIControlStateHighlighted];
    backBtn.imageView.contentMode = UIViewContentModeCenter;
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -32, 0, 0);
    backBtn.tag = 0;
    [backBtn addTarget:self action:@selector(navItemClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *librayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    librayBtn.frame = CGRectMake(0, 0, 44, 44);
    [librayBtn setImage:pngImagePath(@"icon_pic_normal") forState:UIControlStateNormal];
    [librayBtn setImage:pngImagePath(@"icon_pic_pressed") forState:UIControlStateHighlighted];
    librayBtn.tag = 1;
    [librayBtn addTarget:self action:@selector(navItemClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *librayItem = [[UIBarButtonItem alloc] initWithCustomView:librayBtn];
    
    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSeperator.width = -16;
    
    UIButton *cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cameraBtn.frame = CGRectMake(0, 0, 44, 44);
    [cameraBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0,0, -16)];
    [cameraBtn setImage:pngImagePath(@"btn_ig_normal") forState:UIControlStateNormal];
    [cameraBtn setImage:pngImagePath(@"btn_ig_pressed") forState:UIControlStateHighlighted];
    cameraBtn.tag = 2;
    [cameraBtn addTarget:self action:@selector(navItemClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cameraItem = [[UIBarButtonItem alloc] initWithCustomView:cameraBtn];
    
    [self.navigationItem setRightBarButtonItems:@[negativeSeperator,librayItem,cameraItem]];
    
    //配置ScrollerView
    if (iPhone4())
    {
        CGRect rect = self.modelScrollerView.frame;
        rect.size.height -= 38;
        self.modelScrollerView.frame = rect;
    }
    self.modelScrollerView.contentSize = CGSizeMake(320 * 5, 0);
    self.modelScrollerView.contentOffset = CGPointMake(0, 0);
    [self.modelScrollerView setShowsHorizontalScrollIndicator:NO];
    [self.modelScrollerView setShowsVerticalScrollIndicator:NO];
    self.modelScrollerView.pagingEnabled = YES;
    self.modelScrollerView.delegate = self;
    
    amb = [[UIView alloc] initWithFrame:CGRectMake(0, windowHeight() - (iPhone5()?144:94), 320, 50)];
    amb.backgroundColor = colorWithHexString(@"#202225", 1.f);
    [self.view addSubview:amb];
    
    NSArray *dataArray = @[@[@"icon_skull_normal",@"icon_mask_normal",@"icon_animal_normal",@"icon_women_normal",@"icon_other_normal"],
                           @[@"icon_skull_pressed",@"icon_mask_pressed",@"icon_animal_pressed",@"icon_women_pressed",@"icon_other_pressed"]];
    
    int i = 0;
    while (i < 5) {
        FTF_MaterialView *materialView = [[FTF_MaterialView alloc] initWithFrame:CGRectMake(i * 320, 0, 320, self.modelScrollerView.bounds.size.height)];
        materialView.tag = 10 + i;
        [self.modelScrollerView addSubview:materialView];
        
        FTF_Button *btn = [[FTF_Button alloc]initWithFrame:CGRectMake(30 + 57 * i, 10, 30, 30)];
        btn.toolImageView.frame = CGRectMake(0, 0, 30, 30);
        btn.toolImageView.image = pngImagePath([dataArray[0] objectAtIndex:i]);
        [btn setNormelName:[dataArray[0] objectAtIndex:i]];
        [btn setSelectName:[dataArray[1] objectAtIndex:i]];
        btn.tag = i;
        [btn addTarget:self action:@selector(modelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [amb addSubview:btn];
        
        if (i == (int)[FTF_Global shareGlobal].modelType)
        {
            [btn changeBtnImage];
        }
        
        i++;
    }
    
    [self.modelScrollerView setContentOffset:CGPointMake(320 * (int)[FTF_Global shareGlobal].modelType, 0) animated:NO];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
    FTF_MaterialView *materialView = (FTF_MaterialView *)[self.modelScrollerView viewWithTag:10 + (int)[FTF_Global shareGlobal].modelType];
    [materialView loadMaterialModels:(int)[FTF_Global shareGlobal].modelType];

}

#pragma mark -
#pragma mark 导航按钮点击事件
- (void)navItemClick:(FTF_Button *)btn
{
    switch (btn.tag) {
        case 0:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case 1:
        {
            [FTF_Global event:@"Fodder" label:@"fodder_gallery"];
            //判断相册功能是否被人为禁止
            ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
            if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LocalizedString(@"library_not_availabel", @"")
                                                                message:LocalizedString(@"user_library_step", @"")
                                                               delegate:nil
                                                      cancelButtonTitle:LocalizedString(@"ok", @"")
                                                      otherButtonTitles:nil];
                [alert show];
                return;
            }
            
            [self selectCamenaType:UIImagePickerControllerSourceTypePhotoLibrary];
        }
            break;
        case 2:
        {
            [FTF_Global event:@"Fodder" label:@"fodder_camera"];
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LocalizedString(@"camena_not_availabel", @"")
                                                                message:LocalizedString(@"user_camera_step", @"")
                                                               delegate:nil
                                                      cancelButtonTitle:LocalizedString(@"ok", @"")
                                                      otherButtonTitles:nil];
                [alert show];
            }
            [self selectCamenaType:UIImagePickerControllerSourceTypeCamera];
        }
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark 切换图形类型
- (void)modelBtnClick:(FTF_Button *)btn
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
    [self.modelScrollerView setContentOffset:CGPointMake(320 * btn.tag, 0) animated:YES];
    
    FTF_MaterialView *materialView = (FTF_MaterialView *)[self.modelScrollerView viewWithTag:10 + btn.tag];
    [materialView loadMaterialModels:btn.tag];
    
}

- (void)handelTap
{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    UIView *guideView = [window viewWithTag:1002];
    [guideView removeFromSuperview];
    guideView = nil;
    UIView *label = [window viewWithTag:1003];
    [label removeFromSuperview];
    label = nil;
}

#pragma mark -
#pragma makr 相册选取,相机拍照
- (void)selectCamenaType:(NSInteger)sourceType
{
    [FTF_Global shareGlobal].bannerView.hidden = YES;
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.allowsEditing = YES;
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.delegate = self;
    imagePickerController.sourceType = (UIImagePickerControllerSourceType)sourceType;
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        imagePickerController.allowsEditing = NO;
        imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        //设置相机支持的类型，拍照和录像
        imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];
        
        CGRect f = imagePickerController.view.bounds;
        f.size.height -= imagePickerController.navigationBar.bounds.size.height;
        UIGraphicsBeginImageContext(f.size);
        if (iPhone5())
        {
            [[UIColor colorWithWhite:0 alpha:.7] set];
            UIRectFillUsingBlendMode(CGRectMake(0, 0, f.size.width, 124.0), kCGBlendModeNormal);
            UIRectFillUsingBlendMode(CGRectMake(0, 444, f.size.width, 52), kCGBlendModeNormal);
        }
        else
        {
            CGFloat barHeight = (f.size.height - f.size.width) / 2;
            UIGraphicsBeginImageContext(f.size);
            [[UIColor colorWithWhite:0 alpha:.7] set];
            UIRectFillUsingBlendMode(CGRectMake(0, 0, f.size.width, barHeight), kCGBlendModeNormal);
            UIRectFillUsingBlendMode(CGRectMake(0, f.size.height - barHeight, f.size.width, barHeight - 28), kCGBlendModeNormal);
        }
        UIImage *overlayImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        UIImageView *overlayIV = [[UIImageView alloc] initWithFrame:f];
        overlayIV.image = overlayImage;
        overlayIV.alpha = 0.7f;
        [imagePickerController setCameraOverlayView:overlayIV];
    }
    
    [self.view.window.rootViewController presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [FTF_Global shareGlobal].bannerView.hidden = NO;
    [FTF_Global shareGlobal].modelType = OtherModel;
    
    NSURL *path = [info objectForKey:UIImagePickerControllerReferenceURL];
    
    [self loadImageFromAssertByUrl:path completion:^(UIImage * img) {
        
        if(img == nil)
        {
            img = info[UIImagePickerControllerOriginalImage];
        }
        
        //压缩处理
        img = [UIImage zoomImageWithImage:img];
        
        CGSize imageSize = img.size;
        CGFloat width = imageSize.width;
        CGFloat height = imageSize.height;
        if (width != height) {
            CGFloat newDimension = MIN(width, height);
            CGFloat widthOffset = (width - newDimension) / 2;
            CGFloat heightOffset = (height - newDimension) / 2;
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(newDimension, newDimension), NO, 0.);
            [img drawAtPoint:CGPointMake(-widthOffset, -heightOffset)
                         blendMode:kCGBlendModeCopy
                             alpha:1.];
            img = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
        
        [FTF_Global shareGlobal].modelImage = img;
        
        [picker dismissViewControllerAnimated:YES completion:^{
            //改界面
            picker.delegate = nil;
            [self.delegate changeModelImage:[FTF_Global shareGlobal].modelImage];
            [self.navigationController popViewControllerAnimated:NO];
        }];
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        [FTF_Global shareGlobal].bannerView.hidden = NO;
        picker.delegate = nil;
    }];
}

//有的图片在Ipad的情况下
- (void)loadImageFromAssertByUrl:(NSURL *)url completion:(void (^)(UIImage *))completion{
    
    __block UIImage* img;
    
    ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
    
    [assetLibrary assetForURL:url resultBlock:^(ALAsset *asset)
     {
         ALAssetRepresentation *rep = [asset defaultRepresentation];
         Byte *buffer = (Byte*)malloc((unsigned long)rep.size);
         NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:(unsigned int)rep.size error:nil];
         NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
         img = [UIImage imageWithData:data];
         completion(img);
         
         NSLog(@"img ::: %@", img);
     } failureBlock:^(NSError *err) {
         NSLog(@"Error: %@",[err localizedDescription]);
     }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)changeMaterialImage
{
    if ([FTF_Global shareGlobal].filterType == NC_NORMAL_FILTER)
    {
        [self.delegate changeModelImage:[FTF_Global shareGlobal].modelImage];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        
        MBProgressHUD *mb = showMBProgressHUD(nil, YES);
        mb.userInteractionEnabled = YES;
        
        @autoreleasepool {
            [_videoCamera setImages:@[[FTF_Global shareGlobal].modelImage] WithFilterType:[FTF_Global shareGlobal].filterType];
        }
    }
}

#pragma mark -
#pragma mark 滚动停止事件
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 得到每页宽度
    CGFloat pageWidth = scrollView.frame.size.width;
    // 根据当前的x坐标和页宽度计算出当前页数
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    for (UIView *subView in [amb subviews])
    {
        if ([subView isKindOfClass:[FTF_Button class]]) {
            FTF_Button *btn = (FTF_Button *)subView;
            if (btn.tag == page)
            {
                [btn changeBtnImage];
            }
            else
            {
                [btn btnHaveClicked];
            }
        }
    }
    
    FTF_MaterialView *materialView = (FTF_MaterialView *)[self.modelScrollerView viewWithTag:10 + page];
    [materialView loadMaterialModels:page];
    
}

#pragma mark -
#pragma mark - NCVideoCameraDelegate
- (void)videoCameraDidFinishFilter:(UIImage *)image Index:(NSUInteger)index
{
    [self.delegate changeModelImage:image];
    [self.navigationController popViewControllerAnimated:YES];
    
    hideMBProgressHUD();
}

@end
