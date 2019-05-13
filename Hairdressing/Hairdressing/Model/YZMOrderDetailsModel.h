//
//  YZMOrderDetailsModel.h
//  Hairdressing
//
//  Created by yzm on 16/5/25.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YZMOrderModel.h"

@interface YZMOrderDetailsModel : YZMOrderModel

@property (nonatomic ,copy) NSString *address;                  // 门店地址
@property (nonatomic ,copy) NSString *transaction_id;           // 第三方交易号
@property (nonatomic ,assign) YZMOrderPayType pay_type;         // 支付方式
@property (nonatomic ,assign) NSTimeInterval apply_back_time;             // 申请退款时间
//@property (nonatomic ,assign) long back_op_time;                // 同意或拒绝退款时间
@property (nonatomic ,assign) NSTimeInterval update_time;                 // 订单最后更新时间
@property (nonatomic ,assign) NSTimeInterval consume_time;                 // 消费时间
@property (nonatomic ,assign) NSTimeInterval refuse_back_time;                 // 拒绝退款时间
@property (nonatomic ,assign) NSTimeInterval back_success_time;                 // 退款成功时间
@property (nonatomic ,assign) NSTimeInterval cancel_back_time;                 // 取消退款时间
@property (nonatomic ,assign) NSTimeInterval pay_time;                        // 支付时间
@property (nonatomic ,assign) NSTimeInterval create_time;          // 下单时间


@end
