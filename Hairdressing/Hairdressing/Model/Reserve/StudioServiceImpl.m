//
//  StudioServiceImpl.m
//  Hairdressing
//
//  Created by Guolong Yang on 16/5/5.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "StudioServiceImpl.h"
#import <AFNetworking/AFNetworking.h>
#import <SSZipArchive/SSZipArchive.h>
#import "Utility.h"
@implementation StudioServiceImpl



#pragma mark --门店详情service
- (RACSignal *)getStudioDetailWithStudioID:(NSNumber*)cropId {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"jsonrpc"] = @"2.0";
    parameters[@"params"] = @[ @{@"corpId" : cropId } ];
    
    //   parameters[@"params"] = @[@{@"name" : username, @"password" : [password md5Str],@"loginway":loginway,@"nick":nickname,@"reception":reception}];
    
    return [self requestDataFromNetWithParams:parameters withAction:@"corpInfo"];
}

- (RACSignal *)getDesignerDetailWithHairStyleID:(NSNumber*)hairStyId {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"jsonrpc"] = @"2.0";
    parameters[@"params"] = @[ @{@"hairstyId" : hairStyId } ];
    
    //   parameters[@"params"] = @[@{@"name" : username, @"password" : [password md5Str],@"loginway":loginway,@"nick":nickname,@"reception":reception}];
    
    return [self requestDataFromNetWithParams:parameters withAction:@"hairstyInfo"];
}

- (RACSignal *)getCommentWithStudioID:(NSNumber*)cropId pageNum:(NSNumber*)pNo pageSize:(NSNumber*)pSize{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"jsonrpc"] = @"2.0";
    parameters[@"params"] = @[ @{@"corpId" : cropId,@"pNo" : pNo,@"pSize" : pSize } ];
    
    //   parameters[@"params"] = @[@{@"name" : username, @"password" : [password md5Str],@"loginway":loginway,@"nick":nickname,@"reception":reception}];
    
    return [self requestDataFromNetWithParams:parameters withAction:@"getCommentList"];
}

#pragma mark -- 服务详情service
- (RACSignal *)getServiceDetailWithItemID:(NSNumber*)itemId {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"jsonrpc"] = @"2.0";
    parameters[@"params"] = @[ @{@"itemId" : itemId } ];
    
    //   parameters[@"params"] = @[@{@"name" : username, @"password" : [password md5Str],@"loginway":loginway,@"nick":nickname,@"reception":reception}];
    
    return [self requestDataFromNetWithParams:parameters withAction:@"getServiceInfo"];
}

#pragma mark -- 发型师作品Service
- (RACSignal *)getDesigerComposiWithDesignerID:(NSNumber*)itemId andPageNum:(NSNumber *)pageNum andSize:(NSNumber *)pageSize{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"jsonrpc"] = @"2.0";
    parameters[@"params"] = @[ @{@"hairstylistId" : itemId,@"pNo" : pageNum,@"pSize" : pageSize } ];
    
    //   parameters[@"params"] = @[@{@"name" : username, @"password" : [password md5Str],@"loginway":loginway,@"nick":nickname,@"reception":reception}];
    
    return [self requestDataFromNetWithParams:parameters withAction:@"getPortfolios"];
}

#pragma mark --获取已签名的订单
- (RACSignal *)getSignedOrderWithToken:(NSString*)token payType:(NSNumber*)payType ItemID:(NSString*)itemId andOrderNum:(NSString*)orderNum{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"jsonrpc"] = @"2.0";
    parameters[@"params"] = @[ @{@"token" : token,@"payType" : payType,@"itemId" : itemId,@"num" : orderNum} ];
    
    //   parameters[@"params"] = @[@{@"name" : username, @"password" : [password md5Str],@"loginway":loginway,@"nick":nickname,@"reception":reception}];
    
    return [self requestDataFromNetWithParams:parameters withAction:@"placeOrder"];
}

#pragma mark --确认订单是否成功支付
- (RACSignal *)confirmOrderPaidOrNotWithToken:(NSString*)token payType:(NSNumber*)payType outTradeNum:(NSString*)outTradeStr{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"jsonrpc"] = @"2.0";
    parameters[@"params"] = @[ @{@"token" : token,@"platform" : payType,@"out_trade_no" : outTradeStr} ];
    
    //   parameters[@"params"] = @[@{@"name" : username, @"password" : [password md5Str],@"loginway":loginway,@"nick":nickname,@"reception":reception}];
    
    return [self requestDataFromNetWithParams:parameters withAction:@"selectOrderStatus"];
}

#pragma mark --查看所有订单的状态
- (RACSignal *)confirmAllOrderInfoWithToken:(NSString*)token{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"jsonrpc"] = @"2.0";
    parameters[@"params"] = @[ @{@"token" : token} ];
    
    
    return [self requestDataFromNetWithParams:parameters withAction:@"orderStat"];
}


@end
