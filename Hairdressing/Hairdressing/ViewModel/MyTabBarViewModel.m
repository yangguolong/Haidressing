//
//  TabBarViewModel.m
//  MTM
//
//  Created by 杨国龙 on 16/1/28.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "MyTabBarViewModel.h"

@interface MyTabBarViewModel ()

//@property (nonatomic ,strong, readwrite) YZMHomepageViewModel *homepageViewModel;

@property (nonatomic ,strong, readwrite) YZMShopListViewModel *shopListViewModel;

@property (nonatomic ,strong, readwrite) YZMTryHairViewModel *tryHairViewModel;

@property (nonatomic ,strong, readwrite) YZMMeViewModel *meViewModel;

@property (nonatomic ,strong, readwrite) YZMHairstylistListViewModel *hairstylistViewModel;

@property (nonatomic ,strong, readwrite) YZMTakePhotoViewModel *takePhotoViewModel;

@end

@implementation MyTabBarViewModel

- (void)initialize
{
    [super initialize];
    
//    self.homepageViewModel = [[YZMHomepageViewModel alloc] initWithServices:self.services params:nil];
    self.shopListViewModel = [[YZMShopListViewModel alloc] initWithServices:self.services params:nil];
    self.tryHairViewModel = [[YZMTryHairViewModel alloc] initWithServices:self.services params:nil];
    self.meViewModel = [[YZMMeViewModel alloc] initWithServices:self.services params:nil];
    self.hairstylistViewModel = [[YZMHairstylistListViewModel alloc] initWithServices:self.services params:nil];
    self.takePhotoViewModel = [[YZMTakePhotoViewModel alloc]initWithServices:self.services params:nil];
}


@end
