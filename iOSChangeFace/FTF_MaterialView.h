//
//  FTF_MaterialView.h
//  iOSChangeFace
//
//  Created by gaoluyangrc on 14-7-30.
//  Copyright (c) 2014年 rcplatform. All rights reserved.
//

enum MaterialModelType{
    CrossBonesModel = 0,
    MaskModel,
    AnimalModel,
    GirlModel,
    OtherModel,
};

#import <UIKit/UIKit.h>

@interface FTF_MaterialView : UIView <UICollectionViewDelegate,UICollectionViewDataSource>
{
    UICollectionView *photo_ColletionView;
    enum MaterialModelType modelType;
}
@property (strong ,nonatomic) NSDictionary *dataDic;

- (void)loadMaterialModels:(NSInteger)tag;

@end
