//
//  YZMHairstylistListViewModel.m
//  Hairdressing
//
//  Created by yzm on 16/4/12.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "YZMHairstylistListViewModel.h"
#import "MRCViewModelServices.h"
#import "MJExtension.h"
#import "YZMHairstyModel.h"
#import "DesignerDetailViewModel.h"

@implementation YZMHairstylistListViewModel

- (void)initialize
{
    [super initialize];
    
    self.title = @"发型师";
    self.shouldPullToRefresh = YES;
    self.shouldInfiniteScrolling = YES;

    
    self.didSelectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSIndexPath *indexPath) {
        
       YZMHairstyModel  *model = self.dataSource[indexPath.section][indexPath.row];
        DesignerDetailViewModel *viewModel = [[DesignerDetailViewModel alloc] initWithServices:self.services params:@{@"corp_id" : model.hairstylist_id }];
        viewModel.designerID = model.hairstylist_id;
        [self.services pushViewModel:viewModel animated:YES];
        
        
        return [RACSignal empty];
    }];
    
}

- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page
{
    return [[self.services.hairService getHairstylistWithSortType:self.sortTypeId districtId:self.areaId townId:@"0" distance:1000000 pNo:self.page pSize:self.perPage longitude:0l latitude:0l] map:^id(id value) {
        
        NSArray *arr = value[@"data"];
        NSMutableArray * hairArray = [YZMHairstyModel mj_objectArrayWithKeyValuesArray:arr];
        
        
        return hairArray;
        
    }];
    
}



@end
