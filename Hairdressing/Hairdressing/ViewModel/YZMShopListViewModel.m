//
//  YZMShopListViewModel.m
//  Hairdressing
//
//  Created by yzm on 16/4/12.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "YZMShopListViewModel.h"
#import "MRCViewModelServices.h"
#import "MJExtension.h"
#import "YZMShopModel.h"

@implementation YZMShopListViewModel

- (void)initialize
{
    [super initialize];
    
    self.title = @"门店";
    self.shouldPullToRefresh = YES;
    self.shouldInfiniteScrolling = YES;

}

- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page
{
    return [[self.services.hairService getCorplistWithSortType:self.sortTypeId districtId:self.areaId townId:@"0" distance:1000000 pNo:self.page pSize:self.perPage longitude:0l latitude:0l corporation:self.corporation] map:^id(id value) {
        
        NSArray *arr = value[@"data"];
        NSMutableArray * hairArray = [YZMShopModel mj_objectArrayWithKeyValuesArray:arr];
        return hairArray;
    }];
    
}

@end
