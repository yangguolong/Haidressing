//
//  TabBarViewModel.h
//  MTM
//
//  Created by 杨国龙 on 16/1/28.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "MRCViewModel.h"
#import "YZMHomepageViewModel.h"
#import "YZMTryHairViewModel.h"
#import "YZMMeViewModel.h"
#import "YZMReserveViewModel.h"
#import "YZMShopListViewModel.h"
#import "YZMHairstylistListViewModel.h"
#import "YZMTakePhotoViewModel.h"

@interface MyTabBarViewModel : MRCViewModel

//@property (nonatomic ,strong, readonly) YZMHomepageViewModel *homepageViewModel;
@property (nonatomic ,strong, readonly) YZMShopListViewModel *shopListViewModel;

@property (nonatomic ,strong, readonly) YZMTryHairViewModel *tryHairViewModel;

@property (nonatomic ,strong, readonly) YZMMeViewModel *meViewModel;

@property (nonatomic ,strong, readonly) YZMHairstylistListViewModel * hairstylistViewModel;

@property (nonatomic ,strong, readonly) YZMTakePhotoViewModel * takePhotoViewModel;

@end
