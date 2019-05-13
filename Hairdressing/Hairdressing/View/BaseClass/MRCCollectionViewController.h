//
//  MRCCollectionViewController.h
//  MTM
//
//  Created by 李昌庆 on 16/2/1.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "MRCViewController.h"
#import <UIScrollView+EmptyDataSet.h>
@interface MRCCollectionViewController : MRCViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>

@property (nonatomic, weak, readonly) UICollectionView * collectionView;

@property (nonatomic, assign, readonly) UIEdgeInsets contentInset;


-(void)reloadData;
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;
- (void)configureCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object;

@end
