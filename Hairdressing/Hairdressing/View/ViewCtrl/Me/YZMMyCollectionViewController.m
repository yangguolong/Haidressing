//
//  YZMMyCollectionViewController.m
//  Hairdressing
//
//  Created by Yangjiaolong on 16/4/14.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "YZMMyCollectionViewController.h"
#import "YZMMyCollectionViewModel.h"
#import "YZMMyCollectionCell.h"
#import "UIView+MJExtension.h"

@interface YZMMyCollectionViewController ()<UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong,readonly) YZMMyCollectionViewModel * viewModel;

@end

@implementation YZMMyCollectionViewController
@dynamic viewModel;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([YZMMyCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([YZMMyCollectionCell class])];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 10;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YZMMyCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([YZMMyCollectionCell class]) forIndexPath:indexPath];
    
    return cell;
    
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((collectionView.mj_w - 30) / 2 , (collectionView.mj_w - 30) / 2 * 1.2);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
