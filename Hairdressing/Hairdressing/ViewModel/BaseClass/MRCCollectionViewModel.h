//
//  MRCCollectionViewModel.h
//  MTM
//
//  Created by 李昌庆 on 16/2/1.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "MRCViewModel.h"

@interface MRCCollectionViewModel : MRCViewModel

@property (nonatomic,strong)NSMutableArray * dataSource;

@property (nonatomic,assign) NSUInteger page;
@property (nonatomic,assign) NSUInteger perPage;

@property (nonatomic,assign) BOOL shouldPullToRefresh;
@property (nonatomic,assign) BOOL shouldInfiniteScrolling;

@property (nonatomic,strong) RACCommand * didSelectCommand;
@property (nonatomic,strong,readonly) RACCommand * requestRemoteDataCommand;


-(BOOL(^)(NSError * error))requestRemoteDataErrorsFilter;

-(NSUInteger)offsetForPage:(NSUInteger)page;

-(RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page;

@end
