//
//  MRCViewModelServices.h
//  MVVMReactiveCocoa
//
//  Created by leichunfeng on 14/12/27.
//  Copyright (c) 2014年 leichunfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MRCNavigationProtocol.h"
#import "TryHairService.h"
#import "LoginService.h"
#import "RegistService.h"
#import "ProfileService.h"
#import "SettingService.h"
#import "StudioService.h"
#import "YZMHairService.h"
#import "YZMOrderService.h"
//#import "MRCAppStoreService.h"

@protocol MRCViewModelServices <NSObject, MRCNavigationProtocol>//MRCNavigationProtocol

@required

///// A reference to OCTClient instance.
//@property (nonatomic, strong) OCTClient *client;

@property (nonatomic, strong, readonly) id<LoginService> loginServices;
@property (nonatomic, strong, readonly) id<RegistService> registService;
@property (nonatomic, strong, readonly) id<SettingService> settingService;
@property (nonatomic, strong, readonly) id<TryHairService> tryHairService;
@property (nonatomic, strong, readonly) id<ProfileService> profileService;
@property (nonatomic, strong, readonly) id<StudioService> studioService;
@property (nonatomic, strong, readonly) id<YZMHairService> hairService;
@property (nonatomic, strong, readonly) id<YZMOrderService> orderService;
//@property (nonatomic, strong, readonly) id<ShopService> shopSservice;
//@property (nonatomic, strong, readonly) id<MRCAppStoreService> appStoreService;

@end

