//
//  YZMOrderServiceImpl.m
//  Hairdressing
//
//  Created by yzm on 5/19/16.
//  Copyright © 2016 Yangjiaolong. All rights reserved.
//

#import "YZMOrderServiceImpl.h"
#import "YZMOrderService.h"

@implementation YZMOrderServiceImpl

- (RACSignal *)getOrdersWithOrderrRequestType:(YZMOrderRequestType)type
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"jsonrpc"] = @"2.0";
    parameters[@"params"] = @[ @{@"token" : [[NSUserDefaults standardUserDefaults] valueForKey:USER_TOKEN], @"status": @(type)} ];
    
    return [super requestDataFromNetWithParams:parameters withAction:@"getOrders"];

}
- (RACSignal *)placeOrderWithPayType:(YZMOrderPayType)payType
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"jsonrpc"] = @"2.0";
    parameters[@"params"] = @[ @{@"token" : [[NSUserDefaults standardUserDefaults] valueForKey:USER_TOKEN], @"itemId": @"25", @"num": @"2", @"payType": @"1"} ];
    
    return [super requestDataFromNetWithParams:parameters withAction:@"placeOrder"];
}

- (RACSignal *)editOrderWithOrderEditStatus:(YZMOrderEditStatus)editStatus orderId:(NSString *)orderId
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"jsonrpc"] = @"2.0";
    parameters[@"params"] = @[ @{@"token" : [[NSUserDefaults standardUserDefaults] valueForKey:USER_TOKEN], @"order_id":orderId, @"op_type": @(editStatus) } ];
    
    return [super requestDataFromNetWithParams:parameters withAction:@"editOrder"];

}

- (RACSignal *)payOrderWithPayType:(YZMOrderPayType)payType orderId:(NSString *)orderId
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"jsonrpc"] = @"2.0";
    parameters[@"params"] = @[ @{@"token" : [[NSUserDefaults standardUserDefaults] valueForKey:USER_TOKEN], @"orderId": orderId, @"payType": @(payType)} ];
    
    return [super requestDataFromNetWithParams:parameters withAction:@"payOrder"];
}

- (RACSignal *)getOrderInfoWithOrderNo:(NSString *)orderno
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"jsonrpc"] = @"2.0";
    parameters[@"params"] = @[ @{@"token" : [[NSUserDefaults standardUserDefaults] valueForKey:USER_TOKEN], @"orderno": orderno} ];
    
    return [super requestDataFromNetWithParams:parameters withAction:@"orderInfo"];

}
-(RACSignal *)commitAppraiseWithAppraiseModel:(YZMAppraiseModel *)model{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"jsonrpc"] = @"2.0";
    model.token = [[NSUserDefaults standardUserDefaults]objectForKey:USER_TOKEN];
    
    parameters[@"params"] =@[[model mj_keyValues]];
    return  [super requestDataFromNetWithParams:parameters withAction:@"orderScore"];
}

-(RACSignal *)getCommentLabel{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"jsonrpc"] = @"2.0";
    
    parameters[@"params"] =@[@{}];
    return [super requestDataFromNetWithParams:parameters withAction:@"getCommentLabel"];
    
}


-(RACSignal *)getCouponsWithcorpId:(NSString *)corpId itemId:(NSString *)itemId cityId:(NSString *)cityId pNo:(NSInteger)pNo pSize:(NSInteger)pSize{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"jsonrpc"] = @"2.0";
    
    parameters[@"params"] =@[@{@"corp_id":corpId,@"item_id":itemId,@"city_id":cityId,@"pNo":@(pNo),@"pSize":@(pSize),@"token":[[NSUserDefaults standardUserDefaults]objectForKey:USER_TOKEN]}];
    
    return [super requestDataFromNetWithParams:parameters withAction:@"getCoupons"];

}



@end
