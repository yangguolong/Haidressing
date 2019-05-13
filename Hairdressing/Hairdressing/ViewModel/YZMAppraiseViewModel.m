//
//  YZMAppraiseViewModel.m
//  Hairdressing
//
//  Created by Yangjiaolong on 16/5/24.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "YZMAppraiseViewModel.h"
#import "YZMAppraiseModel.h"
#import "YZMAppraiseLabelModel.h"

@interface YZMAppraiseViewModel ()

@end

@implementation YZMAppraiseViewModel

-(void)initialize{
    [super initialize];
    
    
    self.title = @"评价";
    self.aModel = [[YZMAppraiseModel alloc]init];
//    self.labels = [NSMutableArray array];
    
    //测试
    self.aModel.remark = @"测试评论";
    self.aModel.tech_score = 5.0;
    self.aModel.service_score = 5.0;
    self.aModel.env_score = 5.0;
    self.aModel.order_id =  self.params[@"order_id"];
    
    [[[self.services orderService] getCommentLabel] subscribeNext:^(NSDictionary * x) {
        DLog(@"xxx%@",x);
        NSMutableArray * arr = [NSMutableArray array];
        for (NSString * key in x.allKeys) {
            YZMAppraiseLabelModel * model = [[YZMAppraiseLabelModel alloc]init];
            model.Id = key;
            model.label = [x objectForKey:key];
            [arr addObject:model];
        }
        self.labels = arr;
    }];
    
    self.commitButtonCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [self.services.orderService commitAppraiseWithAppraiseModel:self.aModel];
    }];
    [self.commitButtonCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        [self.services popViewModelAnimated:YES];
    }];
}
@end