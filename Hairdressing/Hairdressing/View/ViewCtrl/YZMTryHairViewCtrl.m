//
//  YZMTryHairViewCtrl.m
//  Hairdressing
//
//  Created by 杨国龙 on 16/3/4.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "YZMTryHairViewCtrl.h"
#import "YZMTryCollectionViewCell.h"
#import "YZMTryHairViewModel.h"

@interface YZMTryHairViewCtrl ()

@property (nonatomic,strong,readonly) YZMTryHairViewModel * viewModel;


@end

@implementation YZMTryHairViewCtrl

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([YZMTryCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([YZMTryCollectionViewCell class])];
    
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 40, 25);
    //    [rightBtn setImage:[UIImage imageNamed:@"icon_homepage_leftItem"] forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightBtn setTitle:@"拍照" forState:UIControlStateNormal];
    UIBarButtonItem * leftItem  = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.leftBarButtonItem = leftItem;

    
    rightBtn.rac_command = self.viewModel.leftItemButtonCommand;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 10;// self.viewModel.dataSource.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YZMTryCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([YZMTryCollectionViewCell class]) forIndexPath:indexPath];
    
    
    return cell;
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = CGSizeMake((SCREEN_WIDTH - 30) / 2, ((SCREEN_WIDTH - 30) / 2)* 6 / 5 );
    return size;
}


@end
