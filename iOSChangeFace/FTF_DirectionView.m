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

#define Btn_Width 30.f
#define Btn_Height 30.f
#define Btn_Distance 20.f

@implementation FTF_DirectionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self layerSubviews];
    }
    return self;
}

- (void)layerSubviews
{
    UIView *blur = [[UIView alloc] initWithFrame:self.bounds];
    blur.backgroundColor = colorWithHexString(@"#363636", 1.0);

    //恢复原始
    FTF_Button *resetBtn = [[FTF_Button alloc]initWithFrame:CGRectMake(Btn_Distance, 37, Btn_Width, Btn_Height)];
    resetBtn.toolImageView.frame = CGRectMake(0, 0, Btn_Width, Btn_Height);
    resetBtn.toolImageView.image = pngImagePath(@"Reset_nor");
    [resetBtn setNormelName:@"Reset_nor"];
    [resetBtn setSelectName:@"Reset_sel"];
    resetBtn.tag = 0;
    [resetBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [blur addSubview:resetBtn];
    
    //上下左右
    NSArray *array = @[@[@"left_nor",@"up_nor",@"right_nor",@"down_nor"],
                       @[@"left_sel",@"up_sel",@"right_sel",@"down_sel"]];
    
    for (int i = 0; i < 4; i++)
    {
        FTF_Button *btn = [[FTF_Button alloc]initWithFrame:CGRectMake(80, 37, Btn_Width, Btn_Height)];
        if (i == 1)
        {
            [btn setFrame:CGRectMake(112, 5, Btn_Width, Btn_Height)];
        }
        else if (i == 2)
        {
            [btn setFrame:CGRectMake(144, 37, Btn_Width, Btn_Height)];
        }
        else if (i == 3)
        {
            [btn setFrame:CGRectMake(112, 69, Btn_Width, Btn_Height)];
        }
        btn.tag = i + 1;
        btn.toolImageView.frame = CGRectMake(0, 0, Btn_Width, Btn_Height);
        btn.toolImageView.image = pngImagePath([array[0] objectAtIndex:i]);
        [btn setNormelName:[array[0] objectAtIndex:i]];
        [btn setSelectName:[array[1] objectAtIndex:i]];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [blur addSubview:btn];
        
    }
    
    NSArray *dataArray = @[@[@"big_nor",@"small_nor",@"ronate01_nor",@"ronate02_nor"],
                           @[@"big_sel",@"small_sel",@"ronate01_sel",@"ronate02_sel"]];
    
    //放大缩小和旋转
    int i = 0;
    while (i < 4) {
        
        FTF_Button *btn = [[FTF_Button alloc]initWithFrame:CGRectMake(216 + 54 * (i%2), 10 + (Btn_Width + 24) * (i/2), Btn_Width, Btn_Height)];
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

- (void)btnClick:(FTF_Button *)btn
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeImage" object:nil];
    [btn changeBtnImage];
    [btn performSelector:@selector(btnHaveClicked) withObject:nil afterDelay:.15f];
    [self.delegate directionBtnClick:btn.tag];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
