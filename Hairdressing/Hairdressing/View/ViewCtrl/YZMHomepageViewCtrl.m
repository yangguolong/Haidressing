//
//  YZMHomepageViewCtrl.m
//  Hairdressing
//
//  life cycle，然后是Delegate方法实现，然后是event response，然后才是getters and setters。
//
//  Created by 杨国龙 on 16/3/4.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "YZMHomepageViewCtrl.h"
#import "YZMAreaBarButton.h"
#import "YZMHomepageHeaderView.h"
#import "YZMHairstyleCollectionViewCell.h"
#import "YZMHairCategoryCollectionViewCell.h"
#import "YZMHotHairStyleHeaderView.h"
#import "YZMProductListViewCtrl.h"
#import "YZMShopCollectionViewCell.h"
#import "YZMReserveViewCtrl.h"
#import "YZMReserveViewModel.h"

#define kShopCellPadding            21
#define kCategoryCellPadding        12
#define kHairStyleCellPadding       20

#define kShopColumn                 1
#define kCategoryColumn             2
#define kHairStyleColumn            2

typedef enum {
    YZMHomepageViewCtrlSectionSlider = 0,
    YZMHomepageViewCtrlSectionShop,
    YZMHomepageViewCtrlSectionCategory,
    YZMHomepageViewCtrlSectionHairStyle,
    
}YZMHomepageViewCtrlSection;



@interface YZMHomepageViewCtrl ()

//@property (nonatomic, strong) UISegmentedControl *segmentedControl;

@property (nonatomic, strong) YZMAreaBarButton *areaBarButton;

@property (nonatomic, strong) NSMutableArray *sliderData;

@end

@implementation YZMHomepageViewCtrl

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // 1.初始化导航栏
    [self initNav];
    
    // 2.register class
    [self registerClass];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)registerClass
{
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"YZMHomepageHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[YZMHomepageHeaderView indentifier]];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"YZMHotHairStyleHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[YZMHotHairStyleHeaderView indentifier]];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"YZMHairstyleCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:[YZMHairstyleCollectionViewCell indentifier]];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"YZMHairCategoryCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:[YZMHairCategoryCollectionViewCell indentifier]];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([YZMShopCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:[YZMShopCollectionViewCell indentifer]];
    
}

- (void)initNav
{
    self.navigationItem.title = @"首页";
    self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc] initWithCustomView:self.areaBarButton];
    
    
}

#pragma mark -  UICollectionDelegate

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView * reusableView = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        
        if (indexPath.section == YZMHomepageViewCtrlSectionSlider ) {
            YZMHomepageHeaderView * headView =[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[YZMHomepageHeaderView indentifier] forIndexPath:indexPath];
            headView.sliderView.newses = self.sliderData;
            
            return headView;
        }
        
        if (indexPath.section == YZMHomepageViewCtrlSectionShop ) {
            
            YZMHotHairStyleHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[YZMHotHairStyleHeaderView indentifier] forIndexPath:indexPath];
            [headerView setTitle:@"热门门店"];
            
            return headerView;
            
        } else if (indexPath.section == YZMHomepageViewCtrlSectionCategory ) {
            
            YZMHotHairStyleHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[YZMHotHairStyleHeaderView indentifier] forIndexPath:indexPath];
                [headerView setTitle:@"热门发型师"];
            
            return headerView;
            
        } else if (indexPath.section == YZMHomepageViewCtrlSectionHairStyle ) {
            
            YZMHotHairStyleHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[YZMHotHairStyleHeaderView indentifier] forIndexPath:indexPath];
                [headerView setTitle:@"热门发型"];
            
            return headerView;
            
        }
        
    }
    return reusableView;
}
#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 4;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
   
    if (section == YZMHomepageViewCtrlSectionShop) {
        
        return 4;
    } else if (section == YZMHomepageViewCtrlSectionCategory) {
        
        return 4;
    } else if (section == YZMHomepageViewCtrlSectionHairStyle ) {
        
        return 10;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == YZMHomepageViewCtrlSectionShop) {
        
        YZMShopCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[YZMShopCollectionViewCell indentifer] forIndexPath:indexPath];
        return cell;
        
    } else if (indexPath.section == YZMHomepageViewCtrlSectionCategory) {
        
        YZMHairCategoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[YZMHairCategoryCollectionViewCell indentifier] forIndexPath:indexPath];
        return cell;
        
    } else if (indexPath.section == YZMHomepageViewCtrlSectionHairStyle) {
        
        YZMHairstyleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[YZMHairstyleCollectionViewCell indentifier] forIndexPath:indexPath];
        return cell;
        
    }
    
    return nil;
}


//-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//
//    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
//        MyOrderCollectionReusableHeadView * headView =[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([MyOrderCollectionReusableHeadView class]) forIndexPath:indexPath];
//        [headView configWithModel:[self.viewModel.dataSource[indexPath.section] moneySum]];
//
//        return headView;
//    }else if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
//        MyOrderCollectionReusableFootView * footView =  [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([MyOrderCollectionReusableFootView class]) forIndexPath:indexPath];
//        [footView bindModel:self.viewModel.dataSource[indexPath.section]];
//
//        //        RACCommand * delCommand = [self.viewModel.dataSource[indexPath.section] sectionDeletButtonCommand];
//        //        delCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
//        //
//        //            [[self.viewModel.footViewDelButtonCommand execute:indexPath] subscribeNext:^(id x) {
//        //                if ([x[@"code"] isEqualToString:@"2000"]) {
//        //                    NSLog(@"成功删除 第%@ 组",@(indexPath.section));
//        //
//        //                    [self.viewModel.dataSource removeObjectAtIndex:indexPath.section];
//        //
//        //                    [self.collectionView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
//        //
//        //                    [self.collectionView reloadData];
//        //                }
//        //            }];
//        //
//        //            return [RACSignal empty];
//        //        }];
//        //        footView.deletButton.rac_command = delCommand;
//
//        return footView;
//    }
//    return nil;
//
//}
-(void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
    //    if ([elementKind isEqualToString:UICollectionElementKindSectionFooter]) {
    //        MyOrderCollectionReusableFootView * footView = (MyOrderCollectionReusableFootView *)view;
    //       footView.deletButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
    //
    //           NSLog(@"准备删除 第%@ 组",@(indexPath.section));
    //
    //           [[self.viewModel.footViewDelButtonCommand execute:indexPath] subscribeNext:^(id x) {
    //               if ([x[@"code"] isEqualToString:@"2000"]) {
    //                   NSLog(@"成功删除 第%@ 组",@(indexPath.section));
    //
    //                   [self.viewModel.dataSource removeObjectAtIndex:indexPath.section];
    //
    //                   [self.collectionView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
    //
    //                   [self.collectionView reloadData];
    //               }
    //           }];
    //           return [RACSignal empty];
    //       }];
    //
    //    }
}
-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(UICollectionReusableView *)view forElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
    //    if ([elementKind isEqualToString:UICollectionElementKindSectionFooter]) {
    //        MyOrderCollectionReusableFootView * footView = (MyOrderCollectionReusableFootView *)view;
    //        footView.deletButton.rac_command = nil;
    //    }
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == YZMHomepageViewCtrlSectionShop) {
        
        CGFloat w = (CGRectGetWidth(self.collectionView.frame) - (kShopCellPadding * kShopColumn + kShopCellPadding) ) / kShopColumn;
        CGFloat h = 200;
        return CGSizeMake(w , h);
        
    } else if (indexPath.section == YZMHomepageViewCtrlSectionCategory) {
        
        CGFloat w = (CGRectGetWidth(self.collectionView.frame) - (kCategoryCellPadding * kCategoryColumn + kCategoryCellPadding) ) / kCategoryColumn;
        CGFloat h = 200;
        return CGSizeMake(w , h);
        
    } else if (indexPath.section == YZMHomepageViewCtrlSectionHairStyle ) {
        
        CGFloat w = (CGRectGetWidth(self.collectionView.frame) - (kHairStyleCellPadding * kHairStyleColumn + kHairStyleCellPadding) ) / kHairStyleColumn;
        return CGSizeMake(w , 200);
        
    }
    return CGSizeZero;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    if (section == YZMHomepageViewCtrlSectionSlider ) {
   
        return CGSizeMake(CGRectGetWidth(self.collectionView.frame), [YZMHomepageHeaderView height]);
 
    } else if (section == YZMHomepageViewCtrlSectionShop ) {
        
        return CGSizeMake(CGRectGetWidth(self.collectionView.frame), [YZMHotHairStyleHeaderView height]);
        
    } else if (section == YZMHomepageViewCtrlSectionCategory) {
        
        return CGSizeMake(CGRectGetWidth(self.collectionView.frame), [YZMHotHairStyleHeaderView height]);
        
    } else if (section == YZMHomepageViewCtrlSectionHairStyle) {
        
        return CGSizeMake(CGRectGetWidth(self.collectionView.frame), [YZMHotHairStyleHeaderView height]);
        
    }
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == YZMHomepageViewCtrlSectionCategory ) {
        
        return UIEdgeInsetsMake(kCategoryCellPadding, kCategoryCellPadding, kCategoryCellPadding, kCategoryCellPadding);
        
    } else if (section == YZMHomepageViewCtrlSectionHairStyle ){
        return UIEdgeInsetsMake(0, kCategoryCellPadding, 0, kCategoryCellPadding);
    }
    return UIEdgeInsetsZero;
}

//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
//    return CGSizeMake(CGRectGetWidth(self.collectionView.frame), 80);
//
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == YZMHomepageViewCtrlSectionCategory) {
        
        YZMProductListViewCtrl *viewCtrl = [[YZMProductListViewCtrl alloc] initWithNibName:@"YZMProductListViewCtrl" bundle:nil];
        
        [self.navigationController pushViewController:viewCtrl animated:YES];
        
    } else {
        YZMReserveViewModel *reserveViewModel = [[YZMReserveViewModel alloc] initWithServices:self.viewModel.services params:nil];
        [self.viewModel.services pushViewModel:reserveViewModel animated:YES];
    }
}


#pragma mark - getter and setter
//
//- (UISegmentedControl *)segmentedControl
//{
//    if (_segmentedControl == nil) {
//        _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"女士", @"男士"]];
//        _segmentedControl.selectedSegmentIndex = 0;
//        _segmentedControl.tintColor = [UIColor whiteColor];
//        
//        @weakify(self)
//        [[self.segmentedControl
//          rac_newSelectedSegmentIndexChannelWithNilValue:@0]
//         subscribeNext:^(NSNumber *selectedSegmentIndex) {
//             @strongify(self)
//             // 当segmentedControl值改变时调用，切换了男女
//             
//             
//         }];
//    }
//    return _segmentedControl;
//}



- (YZMAreaBarButton *)areaBarButton
{
    if (_areaBarButton == nil) {
        // 左边按钮
        _areaBarButton = [YZMAreaBarButton areaBarButton];
        // 图标
        [_areaBarButton setImage:[UIImage imageWithName:@"nav_arrow_down"] forState:UIControlStateNormal];
        // 文字
        [_areaBarButton setTitle:@"深圳" forState:UIControlStateNormal];
        // 位置和尺寸
        _areaBarButton.frame = CGRectMake(0, 0, 70, 40);
        //        [_titleButton addTarget:self action:@selector(switchTheCity:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _areaBarButton;
}

- (NSMutableArray *)sliderData
{
    if (_sliderData == nil) {
        
        MJNewsModel *model0 = [MJNewsModel modelWithId:@"0" name:@"000" imageUrl:@"test01"];
        MJNewsModel *model1 = [MJNewsModel modelWithId:@"1" name:@"111" imageUrl:@"test01"];
        MJNewsModel *model2 = [MJNewsModel modelWithId:@"2" name:@"222" imageUrl:@"test01"];
        _sliderData = [NSMutableArray arrayWithObjects:model0, model1, model2, nil];
    }
    return _sliderData;
    
}

@end
