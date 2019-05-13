//
//  YZMAppraiseViewModel.h
//  Hairdressing
//
//  Created by Yangjiaolong on 16/5/24.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "MRCViewModel.h"

@interface YZMAppraiseViewModel : MRCViewModel
@property (nonatomic,strong)YZMAppraiseModel * aModel;

@property (nonatomic,strong) RACCommand * commitButtonCommand;

@property (nonatomic,strong) NSMutableArray * labels;

//@property (nonatomic,copy)NSString * remark;
//
//@property (nonatomic,assign)NSInteger tech_score;
//
//@property (nonatomic,assign)NSInteger service_score;
//
//@property (nonatomic,assign)NSInteger env_score;
//
//@property (nonatomic,copy)NSString * labels;


@end
