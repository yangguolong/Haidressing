//
//  YZMServiceDetailViewController.m
//  Hairdressing
//
//  Created by Guolong Yang on 16/4/15.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "YZMServiceDetailViewController.h"
#import "ServiceDetailViewModel.h"
#import "ServiceDetailCell.h"
#import "ServiceDetail.h"
#import "ServiceCell.h"
#import "PresentView.h"
#import "ServiceCategories.h"
#import "BitmapUtils.h"
#import "YZMSupplyCollectionViewCell.h"
#import "UIView+MJExtension.h"

@interface YZMServiceDetailViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *serviceNameLab;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UILabel *originalPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;//提交订单

@property (weak, nonatomic) IBOutlet UICollectionView *supplyCollevtionView;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property(nonatomic,strong) NSArray *supplys;

@property(nonatomic,strong,readonly)ServiceDetailViewModel *viewModel;

//#######################  NSLayoutConstraint  ###################

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *supplyCollectionViewHeightConstraint;

//#######################  NSLayoutConstraint  ###################


@end

@implementation YZMServiceDetailViewController
@dynamic   viewModel;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.supplyCollevtionView registerNib:[UINib nibWithNibName:@"YZMSupplyCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"YZMSupplyCollectionViewCell"];
    
    UIButton * bt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [bt setImage:[UIImage imageNamed:@"nav_det_back"] forState:UIControlStateNormal];
    UIBarButtonItem * barItem = [[UIBarButtonItem alloc]initWithCustomView:bt];
    self.navigationItem.leftBarButtonItem = barItem;
    [[bt rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self.viewModel.services popViewModelAnimated:YES];
    }];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage createImageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage createImageWithColor:[UIColor clearColor]]];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = NO;

    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];

}

-(void)bindViewModel{
    [super bindViewModel];

   // @weakify(self)
    RAC(self.priceLab,text) = [RACObserve(self.viewModel, price) map:^id(NSNumber *count) {
        return [NSString stringWithFormat:@"¥%@",count];
    }];
    
    RAC(self.descriptionLabel,text) = RACObserve(self.viewModel, serviceDetail);
    
    [[RACObserve(self.viewModel, imagePathStr) filter:^BOOL(id value) {
        return value!= nil;
    }] subscribeNext:^(id x) {
        [BitmapUtils setImageWithImageView:self.headImageView URLString:x];
    }];
    RAC(self.serviceNameLab,text) = RACObserve(self.viewModel, serviceName);

    [RACObserve(self.viewModel, supplys) subscribeNext:^(id x) {
        self.supplys = x;
        [self.supplyCollevtionView reloadData];
    }];
    
    self.submitBtn.rac_command = self.viewModel.confirmOrderCommand;
    [RACObserve(self.supplyCollevtionView, contentSize) subscribeNext:^(id x) {
        self.supplyCollectionViewHeightConstraint.constant = self.supplyCollevtionView.contentSize.height;
    }];
    RAC(self.originalPriceLabel,attributedText) = RACObserve(self.viewModel, standPrice);
    
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.supplys.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    YZMSupplyCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YZMSupplyCollectionViewCell" forIndexPath:indexPath];
    [cell updateWithSupplyModel:[self.supplys objectAtIndex:indexPath.row]];
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((collectionView.mj_w - 60) / 3, 40);
}
@end
