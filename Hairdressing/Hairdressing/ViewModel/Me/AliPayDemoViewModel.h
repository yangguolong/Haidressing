//
//  AliPayDemoViewModel.h
//  Hairdressing
//
//  Created by Guolong Yang on 16/5/10.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AliPayDemoViewModel : MRCViewModel
@property(nonatomic,strong,readonly)RACCommand *payCommand;
@property(nonatomic,strong,readonly)RACCommand *confirmCommand;//确定订单是否已支付

@property(nonatomic,assign,readonly)int payType;

@property(nonatomic,assign,readonly)int itemID;

@property(nonatomic,assign,readonly)int orderNum;


@end
