//
//  YZMOrderModel.h
//  Hairdressing
//
//  Created by yzm on 5/20/16.
//  Copyright © 2016 Yangjiaolong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YZMOrderCoupon.h"
#import "YZMOrderService.h"


typedef NS_ENUM(NSInteger, YZMOrderModelStatus) {
    YZMOrderModelStatusUnpaid           = 1,            // 未付款
    YZMOrderModelStatusPaid             = 2,            // 已付款
    YZMOrderModelStatusEvaluate         = 3,            // 待评价
    YZMOrderModelStatusApplyRefund      = 4,            // 申请退款
    YZMOrderModelStatusRefusedRefund    = 6,            // 拒绝退款
    YZMOrderModelStatusRefunding        = 7,            // 退款中
    YZMOrderModelStatusRefunded         = 8,            // 退款完成
    YZMOrderModelStatusEvaluated        = 10,           // 已评价

};


typedef NS_ENUM(NSInteger,YZMOrderPayType)  {
    YZMOrderPayTypeAli = 1,     // 支付宝支付
    YZMOrderPayTypeWeChat = 2,      // 微信支付
};

@interface YZMOrderModel : NSObject

@property (nonatomic ,copy) NSString *order_id;             // 订单id
@property (nonatomic ,copy) NSString *orderno;              // 订单标识
@property (nonatomic ,copy) NSString *order_check_no;       // 订单验证码
@property (nonatomic ,copy) NSString *corp_id;              // 门店id
@property (nonatomic ,copy) NSString *corporation;          // 门店名称

@property (nonatomic ,copy) NSString *total_price;          // 订单总价
@property (nonatomic ,copy) NSString *discount_price;       // 优惠价
@property (nonatomic ,copy) NSString *settle_price;         // 实付款

@property (nonatomic ,assign) YZMOrderModelStatus status;               // 订单状态
@property (nonatomic ,copy) NSString *remark;               // 备注
@property (nonatomic ,copy) NSString *hotline;              // 客服电话

@property (nonatomic ,assign) BOOL first_order;          // 是否使用首单优惠 0:否 1:是


@property (nonatomic ,copy) NSString *item_id;         // 服务项目id
@property (nonatomic ,copy) NSString *item_name;       // 服务项目名称
//@property (nonatomic ,copy) NSString *item_num;        // 服务项目数量
@property (nonatomic ,copy) NSString *item_url;        // 服务项目图片


//@property (nonatomic ,copy) NSString *price;      // 服务项目价格

//@property (nonatomic ,copy) NSString *abbreviation;         // 门店简称
//@property (nonatomic ,copy) NSString *hairsty_id;           // 发型师id
//@property (nonatomic ,strong) NSArray *items;               //
//@property (nonatomic ,strong) YZMOrderCoupon *coupons;      //
//@property (nonatomic ,copy) NSString *coupon_id;        // 优惠券id
//@property (nonatomic ,copy) NSString *coupon_name;      // 优惠券名称
//@property (nonatomic ,copy) NSString *face_value;       // 面值

+ (NSString *)stringfromStatusEnum:(YZMOrderModelStatus)stauts;

+ (NSString *)stringfromPayTypeEnum:(YZMOrderPayType)payType;

@end
