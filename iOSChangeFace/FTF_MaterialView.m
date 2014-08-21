//
//  FTF_MaterialView.m
//  iOSChangeFace
//
//  Created by gaoluyangrc on 14-7-30.
//  Copyright (c) 2014年 rcplatform. All rights reserved.
//

#import "FTF_MaterialView.h"
#import "FTF_MaterialCell.h"
#import "CMethods.h"
#import "UIImage+Zoom.h"
#import "FTF_Global.h"

@implementation FTF_MaterialView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        NSDictionary *dic =@{
    @"2":@[@"animal01",@"animal02",@"animal03",@"animal04",@"animal05",@"animal06",@"animal07",@"animal08"],
    @"0":@[@"crossBones01",@"crossBones02",@"crossBones03",@"crossBones04",@"crossBones05",@"crossBones06",@"crossBones07",@"crossBones08"],
    @"3":@[@"girl01",@"girl02",@"girl03",@"girl04",@"girl05",@"girl06",@"girl07",@"girl08"],
    @"1":@[@"mask01",@"mask02",@"mask03",@"mask04",@"mask05",@"mask06",@"mask07",@"mask08",@"mask09"],
    @"4":@[@"other01",@"other02",@"other03",@"other04",@"other05",@"other06",@"other07",@"other08",@"other09",@"other10",@"other11"]
            };
        
        self.dataDic = dic;
        
        UIImageView *blur = [[UIImageView alloc] initWithFrame:self.bounds];
        blur.userInteractionEnabled = YES;
        UIEdgeInsets ed = {0.0f, 10.0f, 0.0f, 10.0f};
        UIImage *newImage = [pngImagePath(@"bg") resizableImageWithCapInsets:ed resizingMode:UIImageResizingModeTile];
        blur.image = newImage;
        [self addSubview:blur];
    }
    return self;
}

- (void)dealloc
{
    photo_ColletionView = nil;
    self.dataDic = nil;
}

- (void)loadMaterialModels:(NSInteger)tag
{
    modelType = (enum MaterialModelType)tag;
    dataArray = [self.dataDic objectForKey:[NSString stringWithFormat:@"%d",modelType]];
    [self layerCollectionView];
}

- (void)layerCollectionView
{
    if (photo_ColletionView == nil)
    {
        UICollectionViewFlowLayout *layout= [[UICollectionViewFlowLayout alloc]init];
        photo_ColletionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
        photo_ColletionView.backgroundColor = [UIColor clearColor];
        [self addSubview:photo_ColletionView];
        [photo_ColletionView registerClass:[FTF_MaterialCell class]
                forCellWithReuseIdentifier:@"Cell"];
        photo_ColletionView.delegate=self;
        photo_ColletionView.dataSource=self;
    }
    else
    {
        [photo_ColletionView reloadData];
    }
    
}

#pragma mark -
#pragma mark UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    FTF_MaterialCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",[dataArray objectAtIndex:indexPath.row]]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [FTF_Global shareGlobal].isChange = YES;
    [FTF_Global shareGlobal].modelType = modelType;
    if (modelType == AnimalModel)
    {
        [FTF_Global event:[NSString stringWithFormat:@"fodder_animal_%d",(int)indexPath.row + 1] label:@"Fodder"];
    }
    else if (modelType == CrossBonesModel)
    {
        [FTF_Global event:[NSString stringWithFormat:@"fodder_skeleton_%d",(int)indexPath.row + 1] label:@"Fodder"];
    }
    else if (modelType == GirlModel)
    {
        [FTF_Global event:[NSString stringWithFormat:@"fodder_girl_%d",(int)indexPath.row + 1] label:@"Fodder"];
    }
    else if (modelType == MaskModel)
    {
        [FTF_Global event:[NSString stringWithFormat:@"fodder_mask_%d",(int)indexPath.row + 1] label:@"Fodder"];
    }
    else if (modelType == OtherModel)
    {
        [FTF_Global event:[NSString stringWithFormat:@"fodder_more_%d",(int)indexPath.row + 1] label:@"Fodder"];
    }
    NSArray *dataImageArray = [self.dataDic objectForKey:[NSString stringWithFormat:@"%d",modelType]];
    NSString *imageName = [dataImageArray objectAtIndex:indexPath.row];

    [FTF_Global shareGlobal].modelImage = nil;
    [FTF_Global shareGlobal].modelImage = [UIImage zoomImageWithImage:jpgImagePath(imageName)];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeMaterialImage" object:nil];
}

#pragma mark -
#pragma mark UICollectionViewDelegateFlowLayout
//Item size(每个item的大小)
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(160, 160);
}
//Section Inset就是某个section中cell的边界范围。
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
//Line spacing（每行的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
//Inter cell spacing（每行内部cell item的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
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
