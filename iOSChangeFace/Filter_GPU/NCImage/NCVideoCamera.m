

#import "NCFilters.h"
#import "UIImage+SubImage.h"


@interface NCVideoCamera () <NCImageFilterDelegate>
{
    //滤镜处理完成之后的回调
    FilterCompletionBlock _filterCompletionBlock;
}

//@property (nonatomic, copy) FilterCompletionBlock filterCompletionBlock;

@property (nonatomic, strong)NSLock *theLock;

@property (nonatomic, strong) NCImageFilter *filter;
@property (nonatomic, strong) GPUImagePicture *sourcePicture1;
@property (nonatomic, strong) GPUImagePicture *sourcePicture2;
@property (nonatomic, strong) GPUImagePicture *sourcePicture3;
@property (nonatomic, strong) GPUImagePicture *sourcePicture4;
@property (nonatomic, strong) GPUImagePicture *sourcePicture5;

@property (nonatomic, strong) NCImageFilter *internalFilter;
@property (nonatomic, strong) GPUImagePicture *internalSourcePicture1;
@property (nonatomic, strong) GPUImagePicture *internalSourcePicture2;
@property (nonatomic, strong) GPUImagePicture *internalSourcePicture3;
@property (nonatomic, strong) GPUImagePicture *internalSourcePicture4;
@property (nonatomic, strong) GPUImagePicture *internalSourcePicture5;

//@property (strong, readwrite) GPUImageView *gpuImageView_HD;
//@property (strong, readwrite) GPUImageView *gpuImageView;

@property (nonatomic, strong) NCRotationFilter *rotationFilter;
@property (nonatomic, unsafe_unretained) NCFilterType currentFilterType;

@property (nonatomic, strong) GPUImagePicture *stillImageSource;
@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;

@property (nonatomic, strong) GPUImageMovieWriter *movieWriter;
@property (nonatomic, unsafe_unretained, readwrite) BOOL isRecordingMovie;
@property (nonatomic, strong) AVAudioRecorder *soundRecorder;
@property (nonatomic, strong) AVMutableComposition *mutableComposition;
@property (nonatomic, strong) AVAssetExportSession *assetExportSession;

@end

@implementation NCVideoCamera

@synthesize filter;
@synthesize sourcePicture1;
@synthesize sourcePicture2;
@synthesize sourcePicture3;
@synthesize sourcePicture4;
@synthesize sourcePicture5;

@synthesize internalFilter;
@synthesize internalSourcePicture1;
@synthesize internalSourcePicture2;
@synthesize internalSourcePicture3;
@synthesize internalSourcePicture4;
@synthesize internalSourcePicture5;

@synthesize gpuImageView;
@synthesize gpuImageView_HD;
@synthesize rotationFilter;
@synthesize currentFilterType;
@synthesize rawImage;
@synthesize stillImageSource;

@synthesize stillImageOutput;

@synthesize delegate;

@synthesize movieWriter;
@synthesize isRecordingMovie;
@synthesize soundRecorder;
@synthesize mutableComposition;
@synthesize assetExportSession;



#pragma mark - Switch Filter
- (void)switchToNewFilter {
    
    self.internalFilter.delegate = self;

    if (self.stillImageSource == nil) {
        [self.rotationFilter removeTarget:self.filter];
        self.filter = self.internalFilter;
        [self.rotationFilter addTarget:self.filter];
    } else {
        [self.stillImageSource removeTarget:self.filter];
        self.filter = self.internalFilter;
        [self.stillImageSource addTarget:self.filter];
    }

    switch (currentFilterType) {
            
           case NC_F19_FILTER:
            case NC_F20_FILTER:
            case NC_F21_FILTER:
            case NC_F22_FILTER:
            case NC_F23_FILTER:
            case NC_F24_FILTER:
            case NC_F25_FILTER:
            case NC_F26_FILTER:
            case NC_F27_FILTER:
            case NC_F28_FILTER:
            case NC_F29_FILTER:
            
        case NC_F18_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            self.sourcePicture2 = self.internalSourcePicture2;
            self.sourcePicture3 = self.internalSourcePicture3;
            
            [self.sourcePicture1 addTarget:self.filter];
            [self.sourcePicture2 addTarget:self.filter];
            [self.sourcePicture3 addTarget:self.filter];
            
            break;
        }
            
            
        case NC_F1_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            self.sourcePicture2 = self.internalSourcePicture2;
            self.sourcePicture3 = self.internalSourcePicture3;

            [self.sourcePicture1 addTarget:self.filter];
            [self.sourcePicture2 addTarget:self.filter];
            [self.sourcePicture3 addTarget:self.filter];

            break;
        }
            
        case NC_F2_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            self.sourcePicture2 = self.internalSourcePicture2;
            self.sourcePicture3 = self.internalSourcePicture3;
            
            [self.sourcePicture1 addTarget:self.filter];
            [self.sourcePicture2 addTarget:self.filter];
            [self.sourcePicture3 addTarget:self.filter];
            
            break;
        }
            
        case NC_F3_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            self.sourcePicture2 = self.internalSourcePicture2;
            self.sourcePicture3 = self.internalSourcePicture3;
            
            [self.sourcePicture1 addTarget:self.filter];
            [self.sourcePicture2 addTarget:self.filter];
            [self.sourcePicture3 addTarget:self.filter];
            
            break;
        }
            
        case NC_F4_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            self.sourcePicture2 = self.internalSourcePicture2;
            
            [self.sourcePicture1 addTarget:self.filter];
            [self.sourcePicture2 addTarget:self.filter];
            
            break;
        }
            
            
        case NC_F5_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            self.sourcePicture2 = self.internalSourcePicture2;
            self.sourcePicture3 = self.internalSourcePicture3;
            
            [self.sourcePicture1 addTarget:self.filter];
            [self.sourcePicture2 addTarget:self.filter];
            [self.sourcePicture3 addTarget:self.filter];
            
            break;
        }
            
        case NC_F6_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            self.sourcePicture2 = self.internalSourcePicture2;
            
            [self.sourcePicture1 addTarget:self.filter];
            [self.sourcePicture2 addTarget:self.filter];
            
            break;
        }
            
        case NC_F7_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            self.sourcePicture2 = self.internalSourcePicture2;
            self.sourcePicture3 = self.internalSourcePicture3;
            self.sourcePicture4 = self.internalSourcePicture4;
            self.sourcePicture5 = self.internalSourcePicture5;
            
            [self.sourcePicture1 addTarget:self.filter];
            [self.sourcePicture2 addTarget:self.filter];
            [self.sourcePicture3 addTarget:self.filter];
            [self.sourcePicture4 addTarget:self.filter];
            [self.sourcePicture5 addTarget:self.filter];
            
            break;
        }
            
        case NC_F8_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            self.sourcePicture2 = self.internalSourcePicture2;
            self.sourcePicture3 = self.internalSourcePicture3;
            self.sourcePicture4 = self.internalSourcePicture4;
            self.sourcePicture5 = self.internalSourcePicture5;
            
            [self.sourcePicture1 addTarget:self.filter];
            [self.sourcePicture2 addTarget:self.filter];
            [self.sourcePicture3 addTarget:self.filter];
            [self.sourcePicture4 addTarget:self.filter];
            [self.sourcePicture5 addTarget:self.filter];
            
            break;
        }
            
        case NC_F9_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            self.sourcePicture2 = self.internalSourcePicture2;
            self.sourcePicture3 = self.internalSourcePicture3;
            self.sourcePicture4 = self.internalSourcePicture4;
            self.sourcePicture5 = self.internalSourcePicture5;
            
            [self.sourcePicture1 addTarget:self.filter];
            [self.sourcePicture2 addTarget:self.filter];
            [self.sourcePicture3 addTarget:self.filter];
            [self.sourcePicture4 addTarget:self.filter];
            [self.sourcePicture5 addTarget:self.filter];
            
            break;
        }
            
        case NC_F10_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            self.sourcePicture2 = self.internalSourcePicture2;
            self.sourcePicture3 = self.internalSourcePicture3;
            self.sourcePicture4 = self.internalSourcePicture4;
            self.sourcePicture5 = self.internalSourcePicture5;
            
            [self.sourcePicture1 addTarget:self.filter];
            [self.sourcePicture2 addTarget:self.filter];
            [self.sourcePicture3 addTarget:self.filter];
            [self.sourcePicture4 addTarget:self.filter];
            [self.sourcePicture5 addTarget:self.filter];
            
            break;
        }
            
        case NC_F11_FILTER: {
            
            self.sourcePicture1 = self.internalSourcePicture1;
            
            [self.sourcePicture1 addTarget:self.filter];

            break;
        }
            
        case NC_F12_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            self.sourcePicture2 = self.internalSourcePicture2;
        
            [self.sourcePicture1 addTarget:self.filter];
            [self.sourcePicture2 addTarget:self.filter];

            break;
        }
            
        case NC_F13_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            self.sourcePicture2 = self.internalSourcePicture2;
            self.sourcePicture3 = self.internalSourcePicture3;
            self.sourcePicture4 = self.internalSourcePicture4;
            self.sourcePicture5 = self.internalSourcePicture5;
            
            [self.sourcePicture1 addTarget:self.filter];
            [self.sourcePicture2 addTarget:self.filter];
            [self.sourcePicture3 addTarget:self.filter];
            [self.sourcePicture4 addTarget:self.filter];
            [self.sourcePicture5 addTarget:self.filter];
            
            break;
        }
            
        case NC_F14_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            self.sourcePicture2 = self.internalSourcePicture2;

            [self.sourcePicture1 addTarget:self.filter];
            [self.sourcePicture2 addTarget:self.filter];
 
            break;
        }
            
        case NC_F15_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            
            [self.sourcePicture1 addTarget:self.filter];
            
            break;
        }
            
        case NC_F16_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            self.sourcePicture2 = self.internalSourcePicture2;
            
            [self.sourcePicture1 addTarget:self.filter];
            [self.sourcePicture2 addTarget:self.filter];
            
            break;
        }
            
        case NC_F17_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            
            [self.sourcePicture1 addTarget:self.filter];
            
            break;
        }
            
        case NC_NORMAL_FILTER: {
            break;
        }
            
        default: {
            break;
        }
    }

    if (self.stillImageSource != nil) {
        self.gpuImageView_HD.hidden = NO;
        [self.filter addTarget:self.gpuImageView_HD];
        [self.stillImageSource processImage];

    } else {
        [self.filter addTarget:self.gpuImageView];

    }
}



- (void)forceSwitchToNewFilter:(NCFilterType)type {

    currentFilterType = type;

//    dispatch_async(dispatch_get_main_queue(), ^{
        switch (type) {

            case NC_NORMAL_FILTER: {
                self.internalFilter = [[NCNormalFilter alloc] init];
                break;
            }
                
            case NC_F18_FILTER: {
                self.internalFilter = [[NCF1Filter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCFNEW21"]];
                self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCOverlayMap"]];
                self.internalSourcePicture3 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCF1Map"]];
                
                
                break;
            }
            case NC_F19_FILTER: {
                self.internalFilter = [[NCF1Filter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCFNEW22"]];
                self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCOverlayMap"]];
                self.internalSourcePicture3 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCF1Map"]];
                
                
                break;
            }
            case NC_F20_FILTER: {
                self.internalFilter = [[NCF1Filter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCFNEW23"]];
                self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCOverlayMap"]];
                self.internalSourcePicture3 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCF1Map"]];
                
                
                break;
            }
            case NC_F21_FILTER: {
                self.internalFilter = [[NCF1Filter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCFNEW24"]];
                self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCOverlayMap"]];
                self.internalSourcePicture3 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCF1Map"]];
                
                
                break;
            }
            case NC_F22_FILTER: {
                self.internalFilter = [[NCF1Filter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCFNEW25"]];
                self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCOverlayMap"]];
                self.internalSourcePicture3 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCF1Map"]];
                
                
                break;
            }
            case NC_F23_FILTER: {
                self.internalFilter = [[NCF1Filter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCFNEW26"]];
                self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCOverlayMap"]];
                self.internalSourcePicture3 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCF1Map"]];
                
                
                break;
            }
            case NC_F24_FILTER: {
                self.internalFilter = [[NCF1Filter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCFNEW27"]];
                self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCOverlayMap"]];
                self.internalSourcePicture3 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCF1Map"]];
                
                
                break;
            }
            case NC_F25_FILTER: {
                self.internalFilter = [[NCF1Filter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCFNEW28"]];
                self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCOverlayMap"]];
                self.internalSourcePicture3 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCF1Map"]];
                
                
                break;
            }
            case NC_F26_FILTER: {
                self.internalFilter = [[NCF1Filter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCFNEW29"]];
                self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCOverlayMap"]];
                self.internalSourcePicture3 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCF1Map"]];
                
                
                break;
            }
            case NC_F27_FILTER: {
                self.internalFilter = [[NCF1Filter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCFNEW30"]];
                self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCOverlayMap"]];
                self.internalSourcePicture3 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCF1Map"]];
                
                
                break;
            }
                
            case NC_F28_FILTER: {
                self.internalFilter = [[NCF1Filter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCFNEW31"]];
                self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCOverlayMap"]];
                self.internalSourcePicture3 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCF1Map"]];
                
                
                break;
            }
            case NC_F29_FILTER: {
                self.internalFilter = [[NCF1Filter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCFNEW32"]];
                self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCOverlayMap"]];
                self.internalSourcePicture3 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCF1Map"]];
                
                
                break;
            }

                
            case NC_F1_FILTER: {
                self.internalFilter = [[NCF1Filter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCBlackboard1024"]];
                self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCOverlayMap"]];
                self.internalSourcePicture3 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCF1Map"]];
                
                break;
            }
                
            case NC_F2_FILTER: {
                self.internalFilter = [[NCF2Filter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCBlackboard1024"]];
                self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCOverlayMap"]];
                self.internalSourcePicture3 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCF2Map"]];
                
                break;
            }
                
            case NC_F3_FILTER: {
                self.internalFilter = [[NCF3Filter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCF3Background" ]];
                self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCOverlayMap" ]];
                self.internalSourcePicture3 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCF3Map" ]];
                
                break;
            }
                
            case NC_F4_FILTER: {
                self.internalFilter = [[NCF4Filter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCF4Map" ]];
                self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCVignetteMap" ]];
                
                break;
            }
                
            case NC_F5_FILTER: {
                self.internalFilter = [[NCF5Filter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCF5Vignette" ]];
                self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCOverlayMap" ]];
                self.internalSourcePicture3 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCF5Map" ]];
                
                break;
            }
                
            case NC_F6_FILTER: {
                self.internalFilter = [[NCF6Filter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCF6Map"]];
                self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCVignetteMap"]];
                
                break;
            }
                
            case NC_F7_FILTER: {
                self.internalFilter = [[NCF7Filter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCF7Curves" ]];
                self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCF7OverlayMap" ]];
                self.internalSourcePicture3 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCVignetteMap" ]];
                self.internalSourcePicture4 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCF7Blowout" ]];
                self.internalSourcePicture5 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCF7Map" ]];
                
                break;
            }
                
            case NC_F8_FILTER: {
                self.internalFilter = [[NCF8Filter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCVignetteMap" ]];
                self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCF8Metal" ]];
                self.internalSourcePicture3 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCSoftLight" ]];
                self.internalSourcePicture4 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCF8EdgeBurn" ]];
                self.internalSourcePicture5 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCF8Curves" ]];
                
                break;
            }
                
            case NC_F9_FILTER: {
                self.internalFilter = [[NCF9Filter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCF9Metal" ]];
                self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCF9SoftLight" ]];
                self.internalSourcePicture3 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCF9Curves" ]];
                self.internalSourcePicture4 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCF9OverlayMapWarm" ]];
                self.internalSourcePicture5 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCF9ColorShift" ]];
                
                break;
            }
                
            case NC_F10_FILTER: {
                self.internalFilter = [[NCF10Filter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCF10Process" ]];
                self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCF10Blowout" ]];
                self.internalSourcePicture3 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCF10Contrast" ]];
                self.internalSourcePicture4 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCF10Luma" ]];
                self.internalSourcePicture5 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCF10Screen" ]];
                
                break;
            }
                
            case NC_F11_FILTER: {
                self.internalFilter = [[NCF11Filter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCF11Map" ]];
                
                break;
            }
                
            case NC_F12_FILTER: {
                self.internalFilter = [[NCF12Filter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCF12Map" ]];
                self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCVignetteMap" ]];
                
                break;
            }
                
            case NC_F13_FILTER: {
                self.internalFilter = [[NCF13Filter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCEdgeBurn" ]];
                self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCF13Map" ]];
                self.internalSourcePicture3 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCF13GradientMap" ]];
                self.internalSourcePicture4 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCF13SoftLight" ]];
                self.internalSourcePicture5 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCF13Metal" ]];
                
                break;
            }
                
            case NC_F14_FILTER: {
                self.internalFilter = [[NCF14Filter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCF14Map" ]];
                self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCF14GradientMap" ]];
                
                break;
            }
                
            case NC_F15_FILTER: {
                self.internalFilter = [[NCF15Filter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCF15Map" ]];
                
                break;
            }
                
            case NC_F16_FILTER: {
                self.internalFilter = [[NCF16Filter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCF16map" ]];
                self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCF16blowout" ]];
                
                break;
            }
                
            case NC_F17_FILTER: {
                self.internalFilter = [[NCF17Filter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"NCKelvinMap" ]];
                
                break;
            }
                
            default:
                break;
        }
        
//        [self performSelectorOnMainThread:@selector(switchToNewFilter) withObject:nil waitUntilDone:NO];
    [self switchToNewFilter];
//    [self performSelectorInBackground:@selector(switchToNewFilter) withObject:nil];
//    });
}


- (void)switchFilter:(NCFilterType)type {

    if ((self.rawImage != nil) && (self.stillImageSource == nil)) {

        [self.rotationFilter removeTarget:self.filter];
        self.stillImageSource = [[GPUImagePicture alloc] initWithImage:self.rawImage];
        [self.stillImageSource addTarget:self.filter];
    } else {

        if (currentFilterType == type) {
            return;
        }
    }

    [self forceSwitchToNewFilter:type];
}

- (void)switchFilter:(NCFilterType)type WithCompletionBlock:(FilterCompletionBlock)filterCompletionBlock{
    [self switchFilter:type];
    _filterCompletionBlock = filterCompletionBlock;
}


#pragma mark - init
- (id)initWithSessionPreset:(NSString *)sessionPreset cameraPosition:(AVCaptureDevicePosition)cameraPosition highVideoQuality:(BOOL)isHighQuality WithFrame:(CGRect)frame{
	if (!(self = [super initWithSessionPreset:sessionPreset cameraPosition:cameraPosition]))
    {
		return nil;
    }
    
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
    [self.stillImageOutput setOutputSettings:outputSettings];
    [self.captureSession addOutput:stillImageOutput];
    
    rotationFilter = [[NCRotationFilter alloc] initWithRotation:kGPUImageRotateRight];
    [self addTarget:rotationFilter];
    
    self.filter = [[NCNormalFilter alloc] init];
    self.internalFilter = self.filter;

    [rotationFilter addTarget:filter];
        
    gpuImageView = [[GPUImageView alloc] initWithFrame:frame];
    if (isHighQuality == YES) {
        gpuImageView.layer.contentsScale = 2.0f;
    } else {
        gpuImageView.layer.contentsScale = 1.0f;
    }
    [filter addTarget:gpuImageView];

    gpuImageView_HD = [[GPUImageView alloc] initWithFrame:[gpuImageView bounds]];
    gpuImageView_HD.hidden = YES;
    [gpuImageView addSubview:gpuImageView_HD];
    
    return self;
}

+ (instancetype)videoCameraWithFrame:(CGRect)frame Image:(UIImage *)rawImage{
    NCVideoCamera *instance = [[[self class] alloc] initWithSessionPreset:AVCaptureSessionPresetPhoto cameraPosition:AVCaptureDevicePositionUnspecified highVideoQuality:YES WithFrame:frame];
    
    [instance.stillImageSource removeAllTargets];
    instance.stillImageSource = nil;
    instance.rawImage = rawImage;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [instance switchFilter:NC_NORMAL_FILTER];
    });

    return instance;
}


CGFloat outputWH = 320 * 1.5;

#pragma mark - 批处理相关
+ (instancetype)videoCamera{

    CGRect frame = CGRectMake(0, 0, outputWH, outputWH);
    NCVideoCamera *instance = [[[self class] alloc] initWithSessionPreset:AVCaptureSessionPresetPhoto cameraPosition:AVCaptureDevicePositionUnspecified highVideoQuality:NO WithFrame:frame];
    [instance switchFilter:NC_NORMAL_FILTER];
    instance.theLock = [[NSLock alloc] init];
    return instance;
}

//- (void)setImage:(UIImage *)image WithFilterType:(NCFilterType)filterType CompletionBlock:(FilterCompletionBlock)completion{
//
//    //锁
//    [_theLock lock];
//
//    [stillImageSource removeAllTargets];
//    stillImageSource = nil;
//    self.rawImage = image;
//    
//    self.gpuImageView.frame = (CGRect){CGPointZero, self.rawImage.size};
//    self.gpuImageView_HD.frame = self.gpuImageView.bounds;
//    
//    [self switchFilter:filterType WithCompletionBlock:^(UIImage *filterImage) {
//        
//        completion(filterImage);
//        
//        //解锁
//        [_theLock unlock];
//    }];
//
//}

//#pragma mark - NCImageFilterDelegate
//- (void)imageFilterdidFinishRender:(NCImageFilter *)imageFilter{
//    
//    if(_filterCompletionBlock){
//    
//        //截图
//        UIGraphicsBeginImageContext(gpuImageView.frame.size);
//        UIView *tempView = [[UIView alloc] initWithFrame:self.gpuImageView.frame];
//        [tempView addSubview:self.gpuImageView];
//        
////        NSLog(@"gpuImageView_HD.frame - %@", NSStringFromCGRect(self.gpuImageView_HD.frame));
////        [tempView.layer renderInContext:UIGraphicsGetCurrentContext()];
//        
//        [self.gpuImageView drawViewHierarchyInRect:gpuImageView.frame afterScreenUpdates:YES];
//        UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        
//        CGFloat pix = 1;
//        outputImage = [outputImage subImageWithRect:CGRectMake(0, 0, outputImage.size.width - pix, outputImage.size.height - pix)];
//        
//        //回调
//        _filterCompletionBlock(outputImage);
//        _filterCompletionBlock = nil;
//        
//        //写沙盒测试
////        NSData *imageData = UIImageJPEGRepresentation(outputImage, 0.8);
////        [imageData writeToFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"NoCrop_Share_Image.jpg"] atomically:YES];
//    }
//    
//}



int imagesIndex ;

- (void)setImages:(NSArray *)images WithFilterType:(NCFilterType)filterType{
    imagesIndex = 0;
    
    for (UIImage *image in images) {
        
        //锁
        [_theLock lock];

        if(![image isKindOfClass:[UIImage class]]){

            dispatch_async(dispatch_get_main_queue(), ^{
                if([self.delegate respondsToSelector:@selector(videoCameraDidFinishFilter:Index:)]){
                    [self.delegate videoCameraDidFinishFilter:image Index:imagesIndex++];
                }
            });
            
            [_theLock unlock];
            
            continue;
        }

        
        [stillImageSource removeAllTargets];
        stillImageSource = nil;
        self.rawImage = image;
        
        self.gpuImageView.frame = (CGRect){CGPointZero, self.rawImage.size};
        self.gpuImageView_HD.frame = self.gpuImageView.bounds;
        
        [self switchFilter:filterType];
    }
    
}
#pragma mark - NCImageFilterDelegate
- (void)imageFilterdidFinishRender:(NCImageFilter *)imageFilter{

    dispatch_async(dispatch_get_main_queue(), ^{
    
    //截图
        UIGraphicsBeginImageContext(rawImage.size);
        UIView *tempView = [[UIView alloc] initWithFrame:self.gpuImageView_HD.frame];
        [tempView addSubview:self.gpuImageView_HD];
        [self.gpuImageView_HD drawViewHierarchyInRect:(CGRect){CGPointZero, rawImage.size} afterScreenUpdates:YES];
        UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        //去黑边
        CGFloat pix = 1;
        outputImage = [outputImage subImageWithRect:CGRectMake(0, 0, outputImage.size.width - pix, outputImage.size.height - pix)];
        
        NSData *imageData = UIImageJPEGRepresentation(outputImage, 0.8);
        [imageData writeToFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"NoCrop_Share_Image.jpg"] atomically:YES];
        
        if([self.delegate respondsToSelector:@selector(videoCameraDidFinishFilter:Index:)])
        {
            [self.delegate videoCameraDidFinishFilter:outputImage Index:imagesIndex++];
        }
        
        [_theLock unlock];
        
    });

}

@end
