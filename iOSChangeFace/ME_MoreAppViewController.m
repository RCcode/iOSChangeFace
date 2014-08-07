//
//  ME_MoreAppViewController.m
//  IOSMirror
//
//  Created by gaoluyangrc on 14-7-14.
//  Copyright (c) 2014年 rcplatformhk. All rights reserved.
//

#import "ME_MoreAppViewController.h"
#import "FTF_DataRequest.h"
#import "CMethods.h"
#import "Me_MoreTableViewCell.h"
#import "RC_AppInfo.h"
#import "FTF_Global.h"
#import "UIImageView+WebCache.h"
#import <StoreKit/StoreKit.h>
#import "ME_SQLMassager.h"

@interface ME_MoreAppViewController () <UITableViewDataSource,UITableViewDelegate,SKStoreProductViewControllerDelegate>
{
    UITableView *appInfoTableView;
    NSTimer *_timer;
}
@end

@implementation ME_MoreAppViewController

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
    appInfoTableView = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"More App";
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    CGFloat itemWH = 44;
    UIButton *navBackItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, itemWH, itemWH)];
    [navBackItem setImage:pngImagePath(@"btn_back_black_normal") forState:UIControlStateNormal];
    [navBackItem setImage:pngImagePath(@"btn_back_black_pressed") forState:UIControlStateHighlighted];
    [navBackItem addTarget:self action:@selector(leftBarButtonItemClick) forControlEvents:UIControlEventTouchUpInside];
    navBackItem.imageView.contentMode = UIViewContentModeCenter;
    navBackItem.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, itemWH * 0.65);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:navBackItem];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:@selector(rightItemClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //判断是否已下载完数据
    if ([FTF_Global shareGlobal].appsArray.count == 0)
    {
        MBProgressHUD *hud = showMBProgressHUD(nil, YES);
        hud.userInteractionEnabled = NO;
        hud.color = [UIColor blackColor];
        
        //查看数据库中是否存在
        if ([[ME_SQLMassager shareStance] getAllData].count == 0)
        {
            //Bundle Id
            NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
            NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
            NSString *currentVersion = [infoDict objectForKey:@"CFBundleVersion"];
            NSString *language = [[NSLocale preferredLanguages] firstObject];
            if ([language isEqualToString:@"zh-Hans"])
            {
                language = @"zh";
            }
            
            NSDictionary *dic = @{@"appId":[NSNumber numberWithInt:moreAppID],@"packageName":bundleIdentifier,@"language":language,@"version":currentVersion,@"platform":[NSNumber numberWithInt:0]};
            FTF_DataRequest *request = [[FTF_DataRequest alloc] initWithDelegate:self];
            [request moreApp:dic withTag:11];
        }
        else
        {
            [FTF_Global shareGlobal].appsArray = [[ME_SQLMassager shareStance] getAllData];
        }
        hideMBProgressHUD();
    }
    
    appInfoTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, iPhone5() ? (self.view.bounds.size.height - 44) : (self.view.bounds.size.height - 84)) style:UITableViewStylePlain];
    [appInfoTableView registerNib:[UINib nibWithNibName:@"Me_MoreTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    appInfoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    appInfoTableView.delegate = self;
    appInfoTableView.dataSource = self;
    [self.view addSubview:appInfoTableView];
        
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(updateState) userInfo:nil repeats:YES];
    [_timer fire];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [_timer invalidate];
    _timer = nil;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [[SDImageCache sharedImageCache] clearMemory];
}

- (void)updateState{
    [appInfoTableView reloadData];
}

- (void)leftBarButtonItemClick
{
    cancleAllRequests();
    hideMBProgressHUD();
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"MoreAPP"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"removeMoreImage" object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)rightItemClick
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[FTF_Global shareGlobal].appsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Me_MoreTableViewCell *cell = (Me_MoreTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.delegate = self;
    
    RC_AppInfo *appInfo = [[FTF_Global shareGlobal].appsArray objectAtIndex:indexPath.row];
    
    CGSize appNameSize = sizeWithContentAndFont(appInfo.appName, CGSizeMake(150, 80), 14);
    if (appNameSize.height < 20.f)
    {
        [cell.titleLabel setFrame:CGRectMake(cell.typeLabel.frame.origin.x, cell.typeLabel.frame.origin.y - appNameSize.height - 6, appNameSize.width, appNameSize.height)];
    }
    else
    {
        [cell.titleLabel setFrame:CGRectMake(cell.titleLabel.frame.origin.x, cell.titleLabel.frame.origin.y - 6, appNameSize.width, appNameSize.height)];
    }
    cell.titleLabel.text = appInfo.appName;
    cell.typeLabel.text = appInfo.appCate;
    [cell.logoImageView sd_setImageWithURL:[NSURL URLWithString:appInfo.iconUrl] placeholderImage:nil];
    cell.commentLabel.text = [NSString stringWithFormat:@"(%d)",appInfo.appComment];
    NSString *title = @"";
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:appInfo.openUrl]])
    {
        title = LocalizedString(@"open", @"");
    }
    else
    {
        if ([appInfo.price isEqualToString:@"0"])
        {
            title = LocalizedString(@"free", @"");
        }
        else
        {
            title = appInfo.price;
        }
    }
    
    CGSize size = sizeWithContentAndFont(title, CGSizeMake(120, 26), 18);
    [cell.installBtn setFrame:CGRectMake(320 - size.width - 20, cell.installBtn.frame.origin.y, size.width, 26)];
    [cell.installBtn setTitle:title forState:UIControlStateNormal];
    
    cell.appInfo = appInfo;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RC_AppInfo *appInfo = [[FTF_Global shareGlobal].appsArray objectAtIndex:indexPath.row];
    if (appInfo.isHave)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appInfo.openUrl]];
    }
    else
    {
        [self jumpAppStore:appInfo.downUrl];
    }
}

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)jumpAppStore:(NSString *)appid
{
    NSString *evaluateString = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",appid];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:evaluateString]];
}

#pragma mark -
#pragma mark WebRequestDelegate
- (void)didReceivedData:(NSDictionary *)dic withTag:(NSInteger)tag
{
    NSArray *infoArray = [dic objectForKey:@"list"];
    NSMutableArray *isDownArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *noDownArray = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *infoDic in infoArray)
    {
        RC_AppInfo *appInfo = [[RC_AppInfo alloc]initWithDictionary:infoDic];
        if (appInfo.isHave)
        {
            [isDownArray addObject:appInfo];
        }
        else
        {
            [noDownArray addObject:appInfo];
        }
    }
    NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:0];
    [dataArray addObjectsFromArray:noDownArray];
    [dataArray addObjectsFromArray:isDownArray];
    [FTF_Global shareGlobal].appsArray = dataArray;
    
    //判断是否有新应用
    if ([FTF_Global shareGlobal].appsArray.count > 0) {
        NSMutableArray *dataArray = [[ME_SQLMassager shareStance] getAllData];
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
        
        for (RC_AppInfo *app in [FTF_Global shareGlobal].appsArray)
        {
            BOOL isHave = NO;
            for (RC_AppInfo *appInfo in dataArray)
            {
                if (app.appId == appInfo.appId)
                {
                    isHave = YES;
                }
            }
            if (!isHave) {
                [array addObject:app];
            }
        }
        
        //插入新数据
        if (array.count > 0)
        {
            [[ME_SQLMassager shareStance] insertAppInfo:array];
        }
    }
    [appInfoTableView reloadData];
    hideMBProgressHUD();
}

- (void)requestFailed:(NSInteger)tag
{
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
