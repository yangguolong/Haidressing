//
//  YZMOrderDetailsViewModel.h
//  Hairdressing
//
//  Created by yzm on 16/4/19.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "MRCTableViewModel.h"

@interface YZMOrderDetailsViewModel : MRCViewModel

@property (nonatomic, assign) YZMOrderPayType payType;
@property (nonatomic, strong) RACCommand *payOrderCommand;
@property (nonatomic, strong) RACCommand *editOrderCommand;
@property (nonatomic, strong) RACCommand *payResultCommand;

@property (nonatomic, assign) YZMOrderEditStatus editStatus;

@property (nonatomic, copy) NSString *orderNo;

@end
