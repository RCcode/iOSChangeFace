//
//  FTF_MaterialCell.m
//  iOSChangeFace
//
//  Created by gaoluyangrc on 14-7-30.
//  Copyright (c) 2014年 rcplatform. All rights reserved.
//

#import "FTF_MaterialCell.h"

@implementation FTF_MaterialCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self.contentView setFrame:CGRectMake(0, 0, 160, 160)];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 140, 140)];
        self.imageView = imageView;
        self.imageView.userInteractionEnabled = NO;
        self.layer.borderColor = [UIColor grayColor].CGColor;
        self.layer.borderWidth = .7f;
        
        [self.contentView addSubview:self.imageView];
        
    }
    return self;
}

- (void)dealloc
{
    [self.imageView removeFromSuperview];
    self.imageView = nil;
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
