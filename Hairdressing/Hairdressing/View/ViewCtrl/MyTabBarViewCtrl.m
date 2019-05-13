//
//  TabBarViewController.m
//  MTM
//
//  Created by 杨国龙 on 16/1/28.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "MyTabBarViewCtrl.h"
#import "MyTabBarViewModel.h"
//#import "HomePageViewController.h"
//#import "TryonViewController.h"
//#import "ProfileViewController.h"
#import "MRCNavigationController.h"
#import "YZMHomepageViewCtrl.h"
#import "YZMTryHairViewCtrl.h"
#import "YZMMeViewController.h"
#import "YZMReserveViewCtrl.h"
#import "YZMShopListViewCtrl.h"
#import "YZMHairstylistListViewCtrl.h"
#import "WXTabBarController.h"
#import "YZMTakePhotoViewController.h"

@interface MyTabBarViewCtrl ()<WXTabBarControllerDelegate>

@property (nonatomic, strong) MyTabBarViewModel *viewModel;

@end

@implementation MyTabBarViewCtrl

@dynamic viewModel;

//-(void)viewWillAppear:(BOOL)animated    {
//    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden =NO;
//    self.tabBarController.tabBar.hidden = NO;
//    
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINavigationController *shopNavigationController = ({
        YZMShopListViewCtrl *shopViewCtrl = [[YZMShopListViewCtrl alloc] initWithViewModel:self.viewModel.shopListViewModel];
        UIImage *shopImage = [UIImage imageNamed:@"tab_butik_n"];
        UIImage *shopHLImage =  [UIImage imageNamed:@"tab_butik_s"];
        
        shopViewCtrl.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"门店" image:shopImage selectedImage:shopHLImage];
        
        [[MRCNavigationController alloc] initWithRootViewController:shopViewCtrl];
    });

    UINavigationController *tryHairNavigationController = ({
        YZMTryHairViewCtrl *tryHairViewCtrl = [[YZMTryHairViewCtrl alloc] initWithViewModel:self.viewModel.tryHairViewModel];

        UIImage *tryonImage =  [UIImage imageNamed:@"tab_tryh_n"];
        UIImage *tryonHLImage =  [UIImage imageNamed:@"tab_tryh_s"];

        tryHairViewCtrl.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"试发" image:tryonImage selectedImage:tryonHLImage];

        [[MRCNavigationController alloc] initWithRootViewController:tryHairViewCtrl];
    });
    
    UINavigationController *reserveNavigationController = ({
        YZMHairstylistListViewCtrl *reserveViewCtrl = [[YZMHairstylistListViewCtrl alloc] initWithViewModel:self.viewModel.hairstylistViewModel];

        UIImage *reserveImage = [UIImage imageNamed:@"tab_hair_n"];
        UIImage *reserveHLImage = [UIImage imageNamed:@"tab_hair_s"];
        reserveViewCtrl.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"发型师" image:reserveImage selectedImage:reserveHLImage];

        [[MRCNavigationController alloc] initWithRootViewController:reserveViewCtrl];
    });
    
    UINavigationController *meNavigationController = ({
        YZMMeViewController *meViewCtrl = [[YZMMeViewController alloc] initWithViewModel:self.viewModel.meViewModel];
        
        UIImage *profileImage =  [UIImage imageNamed:@"tab_my_n"];
        UIImage *profileHLImage = [UIImage imageNamed:@"tab_my_s"];
        meViewCtrl.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:profileImage selectedImage:profileHLImage];
        
        [[MRCNavigationController alloc] initWithRootViewController:meViewCtrl];
    });

    self.tabBarController.viewControllers = @[shopNavigationController, reserveNavigationController,  tryHairNavigationController, meNavigationController ];
    [(WXTabBarController *)self.tabBarController setWXdelegate:self];
    
}
-(void)didSelectIndex:(NSInteger)index{
//    YZMTakePhotoViewController * viewCtrl = [[YZMTakePhotoViewController alloc]initWithViewModel:self.viewModel.takePhotoViewModel];
    [self.viewModel.services presentViewModel:self.viewModel.takePhotoViewModel animated:YES completion:nil];
//    [self presentViewController:viewCtrl animated:YES completion:nil];
}

@end
