//
//  YZMReserveViewModel.m
//  Hairdressing
//
//  Created by 杨国龙 on 16/3/4.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "YZMReserveViewModel.h"
#import "YZMHairstylistListViewModel.h"
#import "YZMShopListViewModel.h"



@implementation YZMReserveViewModel

- (void)initialize
{
    [super initialize];
    
    self.title = @"发型师";
    
    YZMHairstylistListViewModel * hairstylistListViewModel = [[YZMHairstylistListViewModel alloc] initWithServices:self.services params:nil];
    YZMShopListViewModel *shopListViewModel = [[YZMShopListViewModel alloc] initWithServices:self.services params:nil];
    
    self.viewModels = @[hairstylistListViewModel, shopListViewModel];
}


@end