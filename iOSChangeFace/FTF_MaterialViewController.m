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
    librayBtn.tag = 0;
    [librayBtn addTarget:self action:@selector(navItemClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *librayItem = [[UIBarButtonItem alloc] initWithCustomView:librayBtn];
    
    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSeperator.width = -16;
    
    UIButton *cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cameraBtn.frame = CGRectMake(0, 0, 44, 44);
    [cameraBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0,0, -16)];
    [cameraBtn setImage:pngImagePath(@"btn_ig_normal") forState:UIControlStateNormal];
    [cameraBtn setImage:pngImagePath(@"btn_ig_pressed") forState:UIControlStateHighlighted];
    cameraBtn.tag = 1;
    [cameraBtn addTarget:self action:@selector(navItemClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cameraItem = [[UIBarButtonItem alloc] initWithCustomView:cameraBtn];
    
    [self.navigationItem setRightBarButtonItems:@[negativeSeperator,librayItem,cameraItem]];
    
    //配置ScrollerView
    self.modelScrollerView.contentSize = CGSizeMake(320 * 5, 0);
    self.modelScrollerView.contentOffset = CGPointMake(0, 0);
    [self.modelScrollerView setShowsHorizontalScrollIndicator:NO];
    [self.modelScrollerView setShowsVerticalScrollIndicator:NO];
    self.modelScrollerView.pagingEnabled = YES;
    self.modelScrollerView.delegate = self;
    
    amb = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 164, 320, 50)];
    amb.backgroundColor = colorWithHexString(@"#202225", 1.f);
    [self.view addSubview:amb];
    
    NSArray *dataArray = @[@[@"icon_skull_normal",@"icon_mask_normal",@"icon_animal_normal",@"icon_women_normal",@"icon_other_normal"],
                           @[@"icon_skull_pressed",@"icon_mask_pressed",@"icon_animal_pressed",@"icon_women_pressed",@"icon_other_pressed"]];
    
    int i = 0;
    while (i < 5) {
        FTF_MaterialView *materialView = [[FTF_MaterialView alloc] initWithFrame:CGRectMake(i * 320, 0, 320, self.modelScrollerView.bounds.size.height)];
        [materialView loadMaterialModels:i];
        [self.modelScrollerView addSubview:materialView];
        
        FTF_Button *btn = [[FTF_Button alloc]initWithFrame:CGRectMake(30 + 57 * i, 10, 30, 30)];
        btn.toolImageView.frame = CGRectMake(0, 0, 30, 30);
        btn.toolImageView.image = pngImagePath([dataArray[0] objectAtIndex:i]);
        [btn setNormelName:[dataArray[0] objectAtIndex:i]];
        [btn setSelectName:[dataArray[1] objectAtIndex:i]];
        btn.tag = i;
        [btn addTarget:self action:@selector(modelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [amb addSubview:btn];
        
        if (i == 0)
        {
            [btn changeBtnImage];
        }
        
        i++;
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeMaterialImage) name:@"changeMaterialImage" object:nil];
    
}

#pragma mark -
#pragma mark 导航按钮点击事件
- (void)navItemClick:(FTF_Button *)btn
{
    switch (btn.tag) {
        case 0:
            [FTF_Global shareGlobal].bannerView.hidden = YES;
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
    imagePickerController.sourceType = sourceType;
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        //设置相机支持的类型，拍照和录像
        imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];
    }
    
    [self.view.window.rootViewController presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [FTF_Global shareGlobal].bannerView.hidden = NO;
    [FTF_Global shareGlobal].modelType = OtherModel;
    __block UIImage *headImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if (headImage != nil)
    {
        headImage = [info objectForKey:UIImagePickerControllerEditedImage];
    }
    else
    {
#warning 测试iPad效果
        NSURL *path = [info objectForKey:UIImagePickerControllerReferenceURL];
        
        [self loadImageFromAssertByUrl:path completion:^(UIImage * img)
         {
             headImage = img;
         }];
        
    }
    
    [FTF_Global shareGlobal].modelImage = nil;
    [FTF_Global shareGlobal].modelImage = [UIImage zoomImageWithImage:headImage];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [self.delegate changeModelImage];
        [self.navigationController popViewControllerAnimated:NO];
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
    [self.delegate changeModelImage];
    [FTF_Global shareGlobal].bannerView.hidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
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
}

@end
