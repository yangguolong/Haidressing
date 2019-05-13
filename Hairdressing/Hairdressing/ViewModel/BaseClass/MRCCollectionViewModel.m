//
//  MRCCollectionViewModel.m
//  MTM
//
//  Created by 李昌庆 on 16/2/1.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "MRCCollectionViewModel.h"

@interface MRCCollectionViewModel ()

@property (nonatomic,strong,readwrite) RACCommand * requestRemoteDataCommand;

@end

@implementation MRCCollectionViewModel


-(void)initialize{

    [super initialize];
    self.page = 1;
    self.perPage = 6;
    @weakify(self)
    self.requestRemoteDataCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(NSNumber * page) {
        @strongify(self)
        return [[self requestRemoteDataSignalWithPage:page.unsignedIntegerValue] takeUntil:self.rac_willDeallocSignal];
        
    }];
    [[self.requestRemoteDataCommand.errors
      filter:[self requestRemoteDataErrorsFilter]]
     subscribe:self.errors];
}

-(BOOL (^)(NSError *))requestRemoteDataErrorsFilter{
    return ^(NSError *error){
        return YES;
    };
}

- (id)fetchLocalData {
    return nil;
}

-(NSUInteger)offsetForPage:(NSUInteger)page{
    return (page - 1) * self.perPage;
}

-(RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page{
    return [RACSignal empty];
}


@end
