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
#import "AMBlurView.h"
#import "FTF_Button.h"

@interface FTF_MaterialViewController ()

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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"相册" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //配置ScrollerView
    self.modelScrollerView.contentSize = CGSizeMake(320 * 5, 0);
    self.modelScrollerView.contentOffset = CGPointMake(0, 0);
    [self.modelScrollerView setShowsHorizontalScrollIndicator:NO];
    [self.modelScrollerView setShowsVerticalScrollIndicator:NO];
    self.modelScrollerView.pagingEnabled = YES;
    self.modelScrollerView.delegate = self;
    
    AMBlurView *amb = [[AMBlurView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 164, 320, 50)];
    amb.blurTintColor = colorWithHexString(@"#202225", 0.9f);
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
        btn.tag = i + 10;
        [btn addTarget:self action:@selector(modelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [amb addSubview:btn];
        
        i++;
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeMaterialImage) name:@"changeMaterialImage" object:nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)modelBtnClick:(FTF_Button *)btn
{
    [self.modelScrollerView setContentOffset:CGPointMake(320 * btn.tag, 0) animated:YES];
}

- (void)rightItemClick:(UIBarButtonItem *)item
{
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
    }
    
    [self selectCamenaType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void)selectCamenaType:(NSInteger)sourceType
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.allowsEditing = NO;
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.delegate = self;
    imagePickerController.sourceType = sourceType;
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        //设置相机支持的类型，拍照和录像
        imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];
    }
    
    [self.view.window.rootViewController presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    __block UIImage *headImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if (headImage != nil)
    {
        headImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    else
    {
        NSURL *path = [info objectForKey:UIImagePickerControllerReferenceURL];
        
        [self loadImageFromAssertByUrl:path completion:^(UIImage * img)
         {
             headImage = img;
         }];
        
    }
    
    [FTF_Global shareGlobal].isFromLibary = YES;
    [FTF_Global shareGlobal].modelImage = [UIImage zoomImageWithImage:headImage];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [self.delegate changeModelImage];
        [self.navigationController popViewControllerAnimated:NO];
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
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
    // Dispose of any resources that can be recreated.
}

- (void)changeMaterialImage
{
    [FTF_Global shareGlobal].isFromLibary = NO;
    [self.delegate changeModelImage];
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
    
    self.modelSegment.selectedSegmentIndex = page;
}

- (IBAction)modelSegmentValueChanged:(id)sender
{
    UISegmentedControl *segment = (UISegmentedControl *)sender;
    [self.modelScrollerView setContentOffset:CGPointMake(320 * segment.selectedSegmentIndex, 0) animated:YES];
}

@end
