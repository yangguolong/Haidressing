//
//  MRCRouter.m
//  MVVMReactiveCocoa
//
//  Created by leichunfeng on 14/12/27.
//  Copyright (c) 2014年 leichunfeng. All rights reserved.
//

#import "MRCRouter.h"


@interface MRCRouter ()

@property (nonatomic, copy) NSDictionary *viewModelViewMappings; // viewModel到view的映射

@end

@implementation MRCRouter

+ (instancetype)sharedInstance {
    static MRCRouter *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (MRCViewController *)viewControllerForViewModel:(MRCViewModel *)viewModel {
    //    NSString *class = NSStringFromClass(viewModel.class);
    NSString *viewController = self.viewModelViewMappings[NSStringFromClass(viewModel.class)];
    
    NSParameterAssert([NSClassFromString(viewController) isSubclassOfClass:[MRCViewController class]]);
    NSParameterAssert([NSClassFromString(viewController) instancesRespondToSelector:@selector(initWithViewModel:)]);
    
    return [[NSClassFromString(viewController) alloc] initWithViewModel:viewModel];
    
}

- (NSDictionary *)viewModelViewMappings {
    return @{
             @"LoginViewModel": @"LoginViewController",
             @"RegistViewModel":@"RegistViewController",
             @"ForgotPasswordViewModel":@"ForgotPasswordViewController",
             @"UserInfoViewModel":@"UserInfoViewController",
             @"SettingViewModel":@"SettingViewController",
             @"CopyRightViewModel":@"CopyRightViewController",
             @"YZMMeViewModel": @"YZMMeViewController",
             @"YZMRegistViewModel": @"YZMRegistViewCtrl",
             @"YZMTryHairViewModel": @"YZMTryHairViewCtrl",
             @"YZMProfileViewModel": @"YZMProfileViewCtrl",
             @"YZMHomepageViewModel": @"YZMHomepageViewCtrl",
             @"MyTabBarViewModel": @"MyTabBarViewCtrl",
             @"StudioDetailViewModel":@"YZMStudioDetailViewController",
             @"DesignerDetailViewModel":@"YZMDesignerDetailViewController",
             @"ServiceDetailViewModel":@"YZMServiceDetailViewController",
             @"DesignerCompositionViewModel":@"DesignerCompositionViewController",
             @"YZMCommentViewModel":@"YZMCommentViewController",
             @"AliPayDemoViewModel":@"AliPayDemoViewController",
             @"LoginViewModel": @"LoginViewController",                         // 登录
             @"RegistViewModel":@"RegistViewController",                        // 注册
             @"ForgotPasswordViewModel":@"ForgotPasswordViewController",        // 忘记密码
             @"UserInfoViewModel":@"UserInfoViewController",                    // 用户信息
             @"SettingViewModel":@"SettingViewController",                      // 设置
             @"YZMMeViewModel": @"YZMMeViewController",                         // 我的
             @"YZMTryHairViewModel": @"YZMTryHairViewCtrl",                     // 试发
             @"YZMHomepageViewModel": @"YZMHomepageViewCtrl",                   // 首页（已废弃）
             @"MyTabBarViewModel": @"MyTabBarViewCtrl",                         // tabbar
             @"StudioDetailViewModel":@"YZMStudioDetailViewController",         // 门店详情
             @"DesignerDetailViewModel":@"YZMDesignerDetailViewController",     // 发型师详情
             @"ServiceDetailViewModel":@"YZMServiceDetailViewController",       // 服务详情
             @"DesignerCompositionViewModel":@"DesignerCompositionViewController",//发型师作品
             @"YZMCommentViewModel":@"YZMCommentViewController",                // 全部评价
             @"AliPayDemoViewModel":@"AliPayDemoViewController",                //
             @"YZMMyCollectionViewModel":@"YZMMyCollectionViewController",      //
             @"FeedBackViewModel":@"FeedBackViewController",                    // 意见反馈
             @"YZMReserveViewModel": @"YZMReserveViewCtrl",                     // 预约（已废弃）
             @"YZMAppraiseViewModel" :@"YZMAppraiseViewController",             // 去评价
             @"ProductListViewModel": @"YZMProductListViewCtrl",                // 商品列表（已废弃）
             @"YZMFixHairAreaViewModel": @"YZMFixHairAreaViewController",       // 
             @"YZMPaintViewModel": @"YZMPaintViewController",                   //
             @"YZMPSViewModel": @"YZMPSViewController",                         //
             @"YZMTakePhotoViewModel": @"YZMTakePhotoViewController",
             @"YZMShopListViewModel": @"YZMShopListViewCtrl",                   // 门店列表
             @"YZMHairstylistListViewModel": @"YZMHairstylistListViewCtrl",     // 发型师列表
             @"YZMOrderListViewModel": @"YZMOrderListViewCtrl",                 // 我的订单
             @"YZMOrderDetailsViewModel": @"YZMOrderDetailsViewCtrl",           // 订单详情
             @"YZMConfirmOrderViewModel": @"YZMConfirmOrderViewController",     // 确认订单
             @"YZMFeedBackViewModel": @"YZMFeedBackViewController",             //
             @"YZMMessageListViewModel": @"YZMMessageListViewCtrl",             // 消息列表（已废弃）
             @"YZMChooseAreaViewModel" : @"YZMChooseAreaViewController",        // 选择区域
             @"VPImageCropperViewModel":@"VPImageCropperViewController",
             @"YZMSearchShopListViewModel" : @"YZMSearchShopListViewCtrl",      // 搜索门店列表
             };
}

@end
