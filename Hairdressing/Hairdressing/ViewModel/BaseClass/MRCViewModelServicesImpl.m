//
//  MRCViewModelServicesImpl.m
//  MVVMReactiveCocoa
//
//  Created by leichunfeng on 14/12/27.
//  Copyright (c) 2014年 leichunfeng. All rights reserved.
//

#import "MRCViewModelServicesImpl.h"
#import "LoginServiceImpl.h"
#import "RegistServiceImpl.h"
#import "SettingServiceImpl.h"
//#import "HomepageServiceImpl.h"
#import "ProfileServiceImpl.h"
//#import "ShopServiceImpl.h"
#import "TryHairServiceImpl.h"
#import "StudioServiceImpl.h"
#import "YZMHairServiceImpl.h"
#import "YZMOrderServiceImpl.h"
@implementation MRCViewModelServicesImpl

//@synthesize client = _client;
@synthesize loginServices = _loginServices;
@synthesize registService = _registService;
@synthesize settingService = _settingService;
@synthesize tryHairService = _tryHairService;
@synthesize profileService = _profileService;
@synthesize studioService = _studioService;
@synthesize hairService   = _hairService;
@synthesize orderService = _orderService;
//@synthesize shopSservice = _shopSservice;
- (instancetype)init {
    self = [super init];
    if (self) {
        _loginServices = [[LoginServiceImpl alloc] init];
        _registService = [[RegistServiceImpl alloc] init];
        _settingService = [[SettingServiceImpl alloc]init];
        _tryHairService = [[TryHairServiceImpl alloc] init];
        _profileService = [[ProfileServiceImpl alloc] init];
        _studioService = [[StudioServiceImpl alloc]init];
        _hairService   =  [[YZMHairServiceImpl alloc] init];
        _orderService = [[YZMOrderServiceImpl alloc] init];
//        _shopSservice = [[ShopServiceImpl alloc]init];
    }
    return self;
}

- (void)pushViewModel:(MRCViewModel *)viewModel animated:(BOOL)animated {}

- (void)popViewModelAnimated:(BOOL)animated {}

- (void)popToRootViewModelAnimated:(BOOL)animated {}

- (void)presentViewModel:(MRCViewModel *)viewModel animated:(BOOL)animated completion:(VoidBlock)completion {}

- (void)dismissViewModelAnimated:(BOOL)animated completion:(VoidBlock)completion {}

- (void)resetRootViewModel:(MRCViewModel *)viewModel {}

@end
