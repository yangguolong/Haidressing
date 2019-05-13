//
//  YZMReserveViewCtrl.m
//  Hairdressing
//
//  Created by 杨国龙 on 16/3/4.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "YZMReserveViewCtrl.h"
#import "YZMReserveViewModel.h"
#import "YZMHairstylistListViewCtrl.h"
#import "YZMShopListViewCtrl.h"

@interface YZMReserveViewCtrl ()

@property (nonatomic, strong, readonly) YZMReserveViewModel *viewModel;

@end


@implementation YZMReserveViewCtrl

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    YZMHairstylistListViewCtrl *styleListsViewCtrl = [[YZMHairstylistListViewCtrl alloc] initWithViewModel:self.viewModel.viewModels[0]];
    styleListsViewCtrl.segmentedControlItem = @"发型师";
    
    YZMShopListViewCtrl *shopListViewCtrl = [[YZMShopListViewCtrl alloc] initWithViewModel:self.viewModel.viewModels[1]];
    shopListViewCtrl.segmentedControlItem = @"门店";
    
    self.viewControllers = @[styleListsViewCtrl, shopListViewCtrl];

        self.navigationItem.titleView = self.segmentedControl;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
