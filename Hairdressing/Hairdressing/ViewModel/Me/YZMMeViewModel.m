//
//  YZMMeViewModel.m
//  Hairdressing
//
//  Created by 杨国龙 on 16/3/4.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "YZMMeViewModel.h"
#import "SettingViewModel.h"
#import "LoginViewModel.h"
#import "MBProgressHUD.h"
#import "AFHTTPSessionManager.h"
#import "MRCViewModelServices.h"
#import "ProductListViewModel.h"
#import "StudioDetailViewModel.h"
#import "DesignerDetailViewModel.h"
#import "ServiceDetailViewModel.h"
#import "UserInfoViewModel.h"
#import "YZMMyCollectionViewModel.h"
#import "AliPayDemoViewModel.h"
#import "FeedBackViewModel.h"
#import "VPImageCropperViewModel.h"
#import "YZMOrderListViewModel.h"
@interface YZMMeViewModel()
@property(nonatomic,strong,readwrite)RACCommand *orderInfoCommand;//订单情况查询
@property(nonatomic,strong,readwrite)RACCommand *imageUploadCommand;
@property(nonatomic,strong,readwrite)RACCommand *goToSettingCommand;
@property(nonatomic,strong,readwrite)RACCommand *cropImageCommand;
@property(nonatomic,strong,readwrite)RACCommand *userInfoGetCommand;//重新获取用户的信息
@end


@implementation YZMMeViewModel

- (void)initialize {
    [super initialize];
    self.title = @"我的";
    if ([[NSUserDefaults standardUserDefaults]boolForKey:ISLOGIN]) {
        self.user = [User dataInit];
        self.imageURLString = self.user.portraitImageDir;
        self.name = self.user.name;
    }
    @weakify(self)
    void (^doNext)(NSDictionary *) = ^(NSDictionary *responeData) {
        @strongify(self)
        if (![responeData isKindOfClass:[NSNull class]]) {
            self.imageURLString = responeData[@"head_img"];
            self.user.portraitImageDir = self.imageURLString;
            [self.user saveOrUpdate];
        }
        
    };
    self.imageUploadCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(UIImage *image) {        
        return [[self.services.settingService uploadHeadImageWithToken:[[NSUserDefaults standardUserDefaults] objectForKey:USER_TOKEN] HeadImage:image andAction:@"setMyAvatar"] doNext:doNext];
    }];
    
    self.orderInfoCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(UIImage *image) {
        return [self.services.studioService confirmAllOrderInfoWithToken:[[NSUserDefaults standardUserDefaults] objectForKey:USER_TOKEN]];
    }];
    
    self.didSelectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSIndexPath *indexPath) {
        @strongify(self)

            if (indexPath.section == 1 && indexPath.row == 0) {
                
            }
            else if (indexPath.section == 1 && indexPath.row == 1) {
                SettingViewModel *settingViewModel = [[SettingViewModel alloc] initWithServices:self.services params:nil];
                [self.services pushViewModel:settingViewModel animated:YES];
            }
            else if(indexPath.section == 1 && indexPath.row ==2){
                if (![[NSUserDefaults standardUserDefaults]boolForKey:ISLOGIN]){
                    //如果用户未登录，则跳转到登录页面
                    LoginViewModel *loginViewModel = [[LoginViewModel alloc] initWithServices:self.services params:nil];
                    [self.services presentViewModel:loginViewModel animated:YES completion:nil];
                    
                }
                else{
                    FeedBackViewModel *feedBackViewModel = [[FeedBackViewModel alloc]initWithServices:self.services params:nil];
                    [self.services pushViewModel:feedBackViewModel animated:YES ];
                }

            }
        return [RACSignal empty];
    }];
    self.goToSettingCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id x) {
        @strongify(self)
        if (![[NSUserDefaults standardUserDefaults]boolForKey:ISLOGIN]){
            //如果用户未登录，则跳转到登录页面
            LoginViewModel *loginViewModel = [[LoginViewModel alloc] initWithServices:self.services params:nil];
            [self.services presentViewModel:loginViewModel animated:YES completion:nil];
            
        }
        else{
            UserInfoViewModel *userViewModel = [[UserInfoViewModel alloc]initWithServices:self.services params:nil];
            [self.services pushViewModel:userViewModel animated:YES];
        }
        return [RACSignal empty];
    }];
    
    self.cropImageCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIImage *image) {
        @strongify(self)
        VPImageCropperViewModel *vpViewModel = [[VPImageCropperViewModel alloc]initWithServices:self.services params:nil];
        vpViewModel.originalImage = image;
        [self.services pushViewModel:vpViewModel animated:YES];
        return [RACSignal empty];
    }] ;
    self.userInfoGetCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIImage *image) {
        @strongify(self)
        return [[[self.services.settingService getUserInfoWithToken:[[NSUserDefaults standardUserDefaults] objectForKey:USER_TOKEN]]
                 doNext:^(NSArray *result) {
                     //  self.dataSource = result;
                 }]
                map:^id(NSDictionary *value) {
                    @strongify(self)
                    if ([[NSUserDefaults standardUserDefaults]boolForKey:ISLOGIN])
                    {
                        self.user = [User dataInit];
                    }
                    if (![value[@"nickname"] isKindOfClass:[NSNull class]]) {
                        self.user.name = value[@"nickname"];
                    }
                    
                    
                    if (![value[@"birthday"] isKindOfClass:[NSNull class]]) {
                        NSString *birthStr =[Utility getDateByTimestamp:[value[@"birthday"] longLongValue] type:0];
                        self.user.birthday =birthStr;
                    }
                    if (![value[@"sex"] isKindOfClass:[NSNull class]]) {
                        if ([value[@"sex"] intValue]==1)
                        {
                            self.user.sex = @"男";
                        }
                        else
                            self.user.sex = @"女";
                    }
                    if (![value[@"head_img"] isKindOfClass:[NSNull class]]) {
                        self.user.portraitImageDir = value[@"head_img"];
                    }
                    [self.user saveOrUpdate];
                    self.imageURLString =self.user.portraitImageDir;
                    self.name = self.user.name;
                    return [RACSignal empty];
                }];
    }] ;
    
}


- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page {
    @weakify(self)
    if (![[NSUserDefaults standardUserDefaults]boolForKey:ISLOGIN])
    {
       return  [RACSignal empty];
    }
    return [[[self.services.settingService getUserInfoWithToken:[[NSUserDefaults standardUserDefaults] objectForKey:USER_TOKEN]]
             doNext:^(NSArray *result) {
                 //  self.dataSource = result;
             }]
            map:^id(NSDictionary *value) {
                @strongify(self)
                if (![value[@"nickname"] isKindOfClass:[NSNull class]]) {
                    self.user.name = value[@"nickname"];
                }
                if (![value[@"birthday"] isKindOfClass:[NSNull class]]) {
                    NSString *birthStr =[Utility getDateByTimestamp:[value[@"birthday"] longLongValue] type:0];
                    self.user.birthday =birthStr;
                }
                if (![value[@"sex"] isKindOfClass:[NSNull class]]) {
                    if ([value[@"sex"] intValue]==1)
                    {
                        self.user.sex = @"男";
                    }
                    else
                        self.user.sex = @"女";
                }
                if (![value[@"head_img"] isKindOfClass:[NSNull class]]) {
                    self.user.portraitImageDir = value[@"head_img"];   
                }
                [self.user saveOrUpdate];
                self.imageURLString =self.user.portraitImageDir;
                self.name = self.user.name;
                return [RACSignal empty];
            }];
}



@end
