//
//  PRJ_Button.m
//  IOSNoCrop
//
//  Created by rcplatform on 14-4-19.
//  Copyright (c) 2014年 rcplatformhk. All rights reserved.
//

#import "FTF_Button.h"
#import "CMethods.h"

@implementation FTF_Button

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.toolImageView = [[UIImageView alloc]init];
        [self addSubview:self.toolImageView];
        
        self.contentLabel = [[UILabel alloc] init];
        self.contentLabel.backgroundColor = [UIColor clearColor];
        self.contentLabel.textAlignment = NSTextAlignmentCenter;
        self.contentLabel.font = [UIFont systemFontOfSize:12.f];
        self.contentLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.contentLabel];
        
    }
    return self;
}

- (void)changeBtnImage
{
    self.toolImageView.image = pngImagePath(self.selectName);
    if (self.btnType == 2)
    {
        self.backgroundColor = [UIColor grayColor];
    }
    else
    {
        self.backgroundColor = colorWithHexString(@"#363636", 1.0);
    }
}

- (void)btnHaveClicked
{
    self.toolImageView.image = pngImagePath(self.normelName);
    self.backgroundColor = [UIColor clearColor];
}


@end
