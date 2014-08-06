//
//  FTF_DirectionView.m
//  iOSChangeFace
//
//  Created by gaoluyangrc on 14-8-5.
//  Copyright (c) 2014年 rcplatform. All rights reserved.
//

#import "FTF_DirectionView.h"
#import "AMBlurView.h"
#import "FTF_Button.h"
#import "CMethods.h"
#import "FTF_VolumeSlide.h"

#define Btn_Width 30.f
#define Btn_Height 30.f
#define Btn_Distance 26.f

@implementation FTF_DirectionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (void)loadDirectionItools
{
    for (UIView *subView in [self subviews])
    {
        [subView removeFromSuperview];
    }
    
    UIImageView *blur = [[UIImageView alloc] initWithFrame:self.bounds];
    blur.userInteractionEnabled = YES;
    UIEdgeInsets ed = {0.0f, 10.0f, 0.0f, 10.0f};
    // 指定为拉伸模式，伸缩后重新赋值
    UIImage *newImage = [pngImagePath(@"bg") resizableImageWithCapInsets:ed resizingMode:UIImageResizingModeTile];
    blur.image = newImage;

    //恢复原始
    FTF_Button *resetBtn = [[FTF_Button alloc]initWithFrame:CGRectMake(Btn_Distance, 37, Btn_Width, Btn_Height)];
    resetBtn.toolImageView.frame = CGRectMake(0, 0, Btn_Width, Btn_Height);
    resetBtn.toolImageView.image = pngImagePath(@"btn_reset_normal");
    [resetBtn setNormelName:@"btn_reset_normal"];
    [resetBtn setSelectName:@"btn_reset_pressed"];
    resetBtn.tag = 0;
    [resetBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [blur addSubview:resetBtn];
    
    //上下左右
    NSArray *array = @[@[@"btn_left_normal",@"btn_up_normal",@"btn_right_normal",@"btn_down_normal"],
                       @[@"btn_left_pressed",@"btn_up_pressed",@"btn_right_pressed",@"btn_down_pressed"]];
    
    for (int i = 0; i < 4; i++)
    {
        FTF_Button *btn = [[FTF_Button alloc]initWithFrame:CGRectMake(89, 37, Btn_Width, Btn_Height)];
        if (i == 1)
        {
            [btn setFrame:CGRectMake(122, 6, Btn_Width, Btn_Height)];
        }
        else if (i == 2)
        {
            [btn setFrame:CGRectMake(155, 37, Btn_Width, Btn_Height)];
        }
        else if (i == 3)
        {
            [btn setFrame:CGRectMake(122, 68, Btn_Width, Btn_Height)];
        }
        btn.tag = i + 1;
        btn.toolImageView.frame = CGRectMake(0, 0, Btn_Width, Btn_Height);
        btn.toolImageView.image = pngImagePath([array[0] objectAtIndex:i]);
        [btn setNormelName:[array[0] objectAtIndex:i]];
        [btn setSelectName:[array[1] objectAtIndex:i]];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [blur addSubview:btn];
 
    }
    
    NSArray *dataArray = @[@[@"btn_big_normal",@"btn_small_normal",@"btn_ronate01_normal",@"btn_ronate02_normal"],
                           @[@"btn_big_pressed",@"btn_small_pressed",@"btn_ronate01_pressed",@"btn_ronate02_pressed"]];
    
    //放大缩小和旋转
    int i = 0;
    while (i < 4) {
        
        FTF_Button *btn = [[FTF_Button alloc]initWithFrame:CGRectMake(215 + 52 * (i%2), 13 + (Btn_Width + 22) * (i/2), Btn_Width, Btn_Height)];
        btn.toolImageView.frame = CGRectMake(0, 0, Btn_Width, Btn_Height);
        btn.toolImageView.image = pngImagePath([dataArray[0] objectAtIndex:i]);
        [btn setNormelName:[dataArray[0] objectAtIndex:i]];
        [btn setSelectName:[dataArray[1] objectAtIndex:i]];
        btn.tag = i + 5;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [blur addSubview:btn];
        
        i++;
    }
    
    [self addSubview:blur];
}

- (void)loadModelStyleItools
{
    for (UIView *subView in [self subviews])
    {
        [subView removeFromSuperview];
    }
    
    UIImageView *blur = [[UIImageView alloc] initWithFrame:self.bounds];
    blur.userInteractionEnabled = YES;
    UIEdgeInsets ed = {0.0f, 10.0f, 0.0f, 10.0f};
    //指定为拉伸模式，伸缩后重新赋值
    UIImage *newImage = [pngImagePath(@"bg") resizableImageWithCapInsets:ed resizingMode:UIImageResizingModeTile];
    blur.image = newImage;
    
    //脸部样式
    NSArray *array = @[@[@"switch_icon_left_normal",@"switch_icon_right_normal",@"switch_icon_up_normal",@"switch_icon_down_normal"],
                       @[@"switch_icon_left_pressed",@"switch_icon_right_pressed",@"switch_icon_up_pressed",@"switch_icon_down_pressed"]];
    
    int i = 0;
    while (i < 4) {
        
        FTF_Button *btn = [[FTF_Button alloc]initWithFrame:CGRectMake(37 + 72 * i, 15, Btn_Width, Btn_Height)];
        btn.toolImageView.frame = CGRectMake(0, 0, Btn_Width, Btn_Height);
        btn.toolImageView.image = pngImagePath([array[0] objectAtIndex:i]);
        [btn setNormelName:[array[0] objectAtIndex:i]];
        [btn setSelectName:[array[1] objectAtIndex:i]];
        btn.tag = i + 10;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [blur addSubview:btn];
        
        if (i == 0)
        {
            [btn changeBtnImage];
        }
        
        i++;
    }
    
    //分割线
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 52, 300, 1)];
    lineView.backgroundColor = colorWithHexString(@"#666666", 1.0f);
    [blur addSubview:lineView];
    
    UISlider *slider = [[UISlider alloc]initWithFrame:CGRectMake(17.5f, 64, 285, 30)];
    [slider setMaximumTrackTintColor:colorWithHexString(@"#999999", 1.0f)];
    [slider setMinimumTrackTintColor:colorWithHexString(@"#D9AF20", 1.0f)];
    [slider setThumbImage:pngImagePath(@"switch_btn_line_normal") forState:UIControlStateNormal];
    [slider setThumbImage:pngImagePath(@"switch_btn_line_pressed") forState:UIControlStateHighlighted];
    slider.value = .5f;
    slider.tag = 0;
    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [blur addSubview:slider];
    
    [self addSubview:blur];
}

- (void)loadCropItools
{
    for (UIView *subView in [self subviews])
    {
        [subView removeFromSuperview];
    }
    
    UIImageView *blur = [[UIImageView alloc] initWithFrame:self.bounds];
    blur.userInteractionEnabled = YES;
    UIEdgeInsets ed = {0.0f, 10.0f, 0.0f, 10.0f};
    UIImage *newImage = [pngImagePath(@"bg") resizableImageWithCapInsets:ed resizingMode:UIImageResizingModeTile];
    blur.image = newImage;
    
    //脸部样式
    NSArray *array = @[@[@"icon_reset_normal",@"icon_shadow01_normal",@"icon_shadow02_normal",@"icon_shadow03_normal"],
                       @[@"icon_reset_pressed",@"icon_shadow01_pressed",@"icon_shadow02_pressed",@"icon_shadow03_pressed"]];
    
    int i = 0;
    while (i < 4) {
        
        FTF_Button *btn = [[FTF_Button alloc]initWithFrame:CGRectMake(49 + 65 * i, 15, Btn_Width, Btn_Height)];
        btn.toolImageView.frame = CGRectMake(0, 0, Btn_Width, Btn_Height);
        btn.toolImageView.image = pngImagePath([array[0] objectAtIndex:i]);
        [btn setNormelName:[array[0] objectAtIndex:i]];
        [btn setSelectName:[array[1] objectAtIndex:i]];
        btn.tag = i + 10;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [blur addSubview:btn];
        
        i++;
    }
    
    //分割线
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 52, 300, 1)];
    lineView.backgroundColor = colorWithHexString(@"#666666", 1.0f);
    [blur addSubview:lineView];
    
    //ZVolumeSlide 自定义Slide控件
    FTF_VolumeSlide *volumeSlide = [[FTF_VolumeSlide alloc]initWithFrame:CGRectMake(17.5, 64, 285, 30)];
    volumeSlide.delegate = self;
    [volumeSlide setSlideValue:0.5];
    [blur addSubview:volumeSlide];
    
    [self addSubview:blur];
}

- (void)loadFilerItools
{
    for (UIView *subView in [self subviews])
    {
        [subView removeFromSuperview];
    }
    
    UIImageView *blur = [[UIImageView alloc] initWithFrame:self.bounds];
    blur.userInteractionEnabled = YES;
    UIEdgeInsets ed = {0.0f, 10.0f, 0.0f, 10.0f};
    UIImage *newImage = [pngImagePath(@"bg") resizableImageWithCapInsets:ed resizingMode:UIImageResizingModeTile];
    blur.image = newImage;
    
    UIScrollView *filterScroller = [[UIScrollView alloc]initWithFrame:blur.bounds];
    [filterScroller setContentSize:CGSizeMake(80 * 30, 0)];
    [filterScroller setContentOffset:CGPointMake(0, 0)];
    filterScroller.showsVerticalScrollIndicator = NO;
    filterScroller.backgroundColor = [UIColor clearColor];
    [blur addSubview:filterScroller];
    
    for (int i = 0; i < 30; i++)
    {
        FTF_Button *btn = [[FTF_Button alloc]initWithFrame:CGRectMake(80 * i, 0, 80, 104)];
        btn.toolImageView.frame = CGRectMake(10, 15, 70, 70);
        btn.toolImageView.image = pngImagePath([NSString stringWithFormat:@"IMG_%d",i]);
        [btn setNormelName:[NSString stringWithFormat:@"IMG_%d",i]];
        [btn setSelectName:[NSString stringWithFormat:@"IMG_%d",i]];
        btn.tag = i + 100;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [filterScroller addSubview:btn];
    }
    
    [self addSubview:blur];
}

- (void)btnClick:(FTF_Button *)btn
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeImage" object:nil];
    [btn changeBtnImage];
    [btn performSelector:@selector(btnHaveClicked) withObject:nil afterDelay:.15f];
    [self.delegate directionBtnClick:btn.tag];
}

- (void)sliderValueChanged:(UISlider *)slider
{
    [self.delegate sliderValueHaveChanged:slider.tag];
}

#pragma mark -
#pragma mark ZVolumeSlideDelegate
- (void)slideChange:(CGFloat)value
{
    
}



@end
