#import "GPUImage.h"
#import "NCFilters.h"


@class NCVideoCamera;

typedef void(^FilterCompletionBlock) (UIImage *filterImage);

@protocol NCVideoCameraDelegate <NSObject>

@optional
- (void)videoCameraDidFinishFilter:(UIImage *)image Index:(NSUInteger)index;

@end

@interface NCVideoCamera : GPUImageVideoCamera


/**  addSubView展示即可 */
@property (strong, readonly) GPUImageView *gpuImageView;


@property (strong, readonly) GPUImageView *gpuImageView_HD;
@property (nonatomic, strong) UIImage *rawImage;

@property (nonatomic, unsafe_unretained, readonly) BOOL isRecordingMovie;

@property (nonatomic, weak) id<NCVideoCameraDelegate> delegate;

- (id)initWithSessionPreset:(NSString *)sessionPreset cameraPosition:(AVCaptureDevicePosition)cameraPosition highVideoQuality:(BOOL)isHighQuality WithFrame:(CGRect)frame;


/**
 *  选择不同的滤镜类型
 */
- (void)switchFilter:(NCFilterType)type;


/**
 *  快速实例化对象
 *
 *  @param frame    gpuImageView的frame
 *  @param rawImage 需要进行滤镜处理的image对象
 */
+ (instancetype)videoCameraWithFrame:(CGRect)frame Image:(UIImage *)rawImage;


//批处理
+ (instancetype)videoCamera;
//- (void)setImage:(UIImage *)image WithFilterType:(NCFilterType)filterType CompletionBlock:(FilterCompletionBlock)completion;

//完成之后，代理返回图片
- (void)setImages:(NSArray *)images WithFilterType:(NCFilterType)filterType;
- (void)setImage:(UIImage *)image WithFilterType:(NCFilterType)filterType;

@end
