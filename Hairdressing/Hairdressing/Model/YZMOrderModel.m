//
//  YZMOrderModel.m
//  Hairdressing
//
//  Created by yzm on 5/20/16.
//  Copyright © 2016 Yangjiaolong. All rights reserved.
//

#import "YZMOrderModel.h"
#import "YZMOrderItem.h"


@implementation YZMOrderModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"items" : [YZMOrderItem class]};
}

+ (NSString *)stringfromStatusEnum:(YZMOrderModelStatus)stauts
{
    NSString *string ;
    switch (stauts) {
        case YZMOrderModelStatusUnpaid:
            string = @"待付款";
            break;
        case YZMOrderModelStatusPaid:
            string = @"待消费";
            break;
        case YZMOrderModelStatusEvaluate:
            string = @"待评价";
            break;
        case YZMOrderModelStatusApplyRefund:
            string = @"退款中";
            break;
        case YZMOrderModelStatusRefusedRefund:
            string = @"待消费";
            break;
        case YZMOrderModelStatusRefunding:
            string = @"退款完成";
            break;
        case YZMOrderModelStatusRefunded:
            string = @"退款完成";
            break;
        case YZMOrderModelStatusEvaluated:
            string = @"已评价";
            break;
        default:
            string = @"";
            break;
    }
    return string;
}

+ (NSString *)stringfromPayTypeEnum:(YZMOrderPayType)payType
{
      NSString *string ;
    switch (payType) {
        case YZMOrderPayTypeAli:
            string = @"支付宝支付";
            break;
        case YZMOrderPayTypeWeChat:
            string = @"微信支付";
            break;
            
            
        default:
             string = @"";
            break;
    }
    return string;
}

@end
