//
//  FTF_RootViewController.m
//  iOSChangeFace
//
//  Created by gaoluyangrc on 14-7-26.
//  Copyright (c) 2014年 rcplatform. All rights reserved.
//

#import "FTF_RootViewController.h"
#import "UIImage+Zoom.h"
#import "CMethods.h"
#import "FTF_Global.h"
#import "FTF_AdjustFaceViewController.h"
#import "LRNavigationController.h"
#import "SliderViewController.h"
#import "ME_MoreAppViewController.h"
#define AdMobID @"ca-app-pub-3747943735238482/5713575053"

@interface FTF_RootViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *bg_ImageView;
- (IBAction)openLibaryClick:(id)sender;
- (IBAction)openCamanaClick:(id)sender;
- (IBAction)moreApp:(id)sender;
- (IBAction)more:(id)sender;

@end

@implementation FTF_RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)openLibaryClick:(id)sender
{
    [FTF_Global event:@"Home" label:@"home_gallery"];
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
    [FTF_Global shareGlobal].bannerView.hidden = YES;
    [self selectCamenaType:UIImagePickerControllerSourceTypePhotoLibrary];
    
}

- (void)selectCamenaType:(NSInteger)sourceType
{
    [FTF_Global shareGlobal].bannerView.hidden = YES;
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.allowsEditing = NO;
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

- (IBAction)openCamanaClick:(id)sender
{
    [FTF_Global event:@"Home" label:@"home_camera"];
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LocalizedString(@"camena_not_availabel", @"")
                                                        message:LocalizedString(@"user_camera_step", @"")
                                                       delegate:nil
                                              cancelButtonTitle:LocalizedString(@"ok", @"")
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    [self selectCamenaType:UIImagePickerControllerSourceTypeCamera];

}

- (IBAction)moreApp:(id)sender
{
    [FTF_Global event:@"Home" label:@"moreApp"];
    ME_MoreAppViewController *moreApp = [[ME_MoreAppViewController alloc]initWithNibName:@"ME_MoreAppViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:moreApp];
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)more:(id)sender
{
    [[SliderViewController sharedSliderController] showLeftViewController];
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [FTF_Global shareGlobal].bannerView.hidden = NO;
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
    
    [FTF_Global shareGlobal].originalImage = headImage;

    [FTF_Global shareGlobal].compressionImage = [UIImage zoomImageWithImage:headImage];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        FTF_AdjustFaceViewController *adjustFaceController = [[FTF_AdjustFaceViewController alloc]initWithNibName:@"FTF_AdjustFaceViewController" bundle:nil];
        [adjustFaceController loadAdjustViews:[FTF_Global shareGlobal].compressionImage];
        [FTF_Global shareGlobal].nav.navigationBarHidden = NO;
        [[FTF_Global shareGlobal].nav pushViewControllerWithLRAnimated:adjustFaceController];
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        picker.delegate = nil;
        [FTF_Global shareGlobal].bannerView.hidden = NO;
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

@end
