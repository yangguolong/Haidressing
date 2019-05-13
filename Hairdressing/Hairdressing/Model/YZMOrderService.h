//
//  YZMOrderService.h
//  Hairdressing
//
//  Created by yzm on 5/19/16.
//  Copyright © 2016 Yangjiaolong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "YZMAppraiseModel.h"
#import "YZMOrderModel.h"


typedef NS_ENUM(NSInteger,YZMOrderRequestType) {
    YZMOrderRequestTypeAll = 0,             // 全部
    YZMOrderRequestTypeUnpaid,              // 待付款
    YZMOrderRequestTypeUnConsumed,          // 待消费
    YZMOrderRequestTypeReview,              // 待评价
    YZMOrderRequestTypeRefund               // 退款
    
};
typedef NS_ENUM(NSInteger,YZMOrderEditStatus) {
    YZMOrderEditStatusCancleOrder = 1,      // 取消订单
    YZMOrderEditStatusApplyBack = 2,       // 申请退款
    YZMOrderEditStatusCancleBack = 3,          // 取消退款
};




@protocol YZMOrderService <NSObject>




/**
 *  生成订单
 *
 *  @param payType
 *
 *  @return
 */
- (RACSignal *)placeOrderWithPayType:(YZMOrderPayType)payType;

/**
 * 支付订单
 *
 *  @param payType
 *
 *  @return
 */
- (RACSignal *)payOrderWithPayType:(YZMOrderPayType)payType orderId:(NSString *)orderId;


/**
 *  获取订单列表
 *
 *  @param status
 *
 *  @return
 */
- (RACSignal *)getOrdersWithOrderrRequestType:(YZMOrderRequestType)type;


/**
 *  获取订单详情
 *
 *  @param orderno  订单标识
 *
 *  @return
 */
- (RACSignal *)getOrderInfoWithOrderNo:(NSString *)orderno;

/**
 *  改变订单状态
 *
 *  @param
 *
 *  @return
 */
- (RACSignal *)editOrderWithOrderEditStatus:(YZMOrderEditStatus)editStatus orderId:(NSString *)orderId;

/**
 *  订单评价
 *
 *  @param model 订单评价model
 *
 *  @return 
 */
- (RACSignal *)commitAppraiseWithAppraiseModel:(YZMAppraiseModel *)model;

/**
 *  获取订单评价标签
 *
 *  @return 
 */
- (RACSignal *)getCommentLabel;


/**
 *  获取优惠券接口
 *
 *  @param corpId 优惠券试用的企业id
 *  @param itemId 服务项目id
 *  @param cityId 城市id
 *  @param pNo    页码，从第1页开始
 *  @param pSize  每页记录数
 *
 *  @return 
 */
- (RACSignal *)getCouponsWithcorpId:(NSString *)corpId itemId:(NSString *)itemId cityId:(NSString *)cityId pNo:(NSInteger)pNo pSize:(NSInteger)pSize;






@end
