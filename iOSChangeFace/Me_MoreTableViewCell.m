//
//  Me_MoreTableViewCell.m
//  IOSMirror
//
//  Created by gaoluyangrc on 14-6-20.
//  Copyright (c) 2014年 rcplatformhk. All rights reserved.

#import "Me_MoreTableViewCell.h"
#import "CMethods.h"

@implementation Me_MoreTableViewCell

- (void)awakeFromNib
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.logoImageView.layer.cornerRadius = 12.f;
    self.logoImageView.layer.masksToBounds = YES;
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail;
    self.titleLabel.textColor = colorWithHexString(@"#000000", 1.f);
    self.typeLabel.textColor = colorWithHexString(@"#777777", 1.f);
    self.commentLabel.textColor = colorWithHexString(@"#777777", 1.f);
    self.installBtn.layer.borderColor = colorWithHexString(@"#3D7DBF", 1.f).CGColor;
    self.installBtn.layer.borderWidth = 1.f;
    self.installBtn.layer.cornerRadius = 4.f;
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 94.5, 320, .5f)];
    backView.backgroundColor = colorWithHexString(@"#dddddd", 1.f);
    [self.contentView addSubview:backView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
}

- (IBAction)installBtnClick:(id)sender
{
    if (self.appInfo.isHave)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.appInfo.openUrl]];
    }
    else
    {
        [self.delegate jumpAppStore:self.appInfo.downUrl];
    }
}

@end
