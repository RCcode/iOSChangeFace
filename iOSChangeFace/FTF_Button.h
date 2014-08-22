//
//  PRJ_Button.h
//  IOSNoCrop
//
//  Created by rcplatform on 14-4-19.
//  Copyright (c) 2014年 rcplatformhk. All rights reserved.
//


@interface FTF_Button : UIButton

@property (nonatomic ,strong) UIImageView *toolImageView;
@property (nonatomic ,strong) NSString *normelName;
@property (nonatomic ,strong) NSString *selectName;
@property (nonatomic ,strong) UILabel *contentLabel;

- (void)changeBtnImage;
- (void)btnHaveClicked;

@end
