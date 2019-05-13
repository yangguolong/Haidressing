//
//  YZMOrderListViewModel.h
//  Hairdressing
//
//  Created by yzm on 16/4/14.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "MRCTableViewModel.h"
#import "YZMPayTypeSelectViewModel.h"

@interface YZMOrderListViewModel : MRCTableViewModel

@property (nonatomic, assign) YZMOrderRequestType requestType;

@property (nonatomic, assign) YZMOrderPayType payType;

@property (nonatomic, strong) RACCommand *payOrderCommand;
@property (nonatomic, strong) RACCommand *editOrderCommand;
@property (nonatomic, strong) RACCommand *payResultCommand;

@property (nonatomic, assign) YZMOrderEditStatus editStatus;



//@property (nonatomic ,strong) YZMPayTypeSelectViewModel *paytypeSelViewModel;

@end
