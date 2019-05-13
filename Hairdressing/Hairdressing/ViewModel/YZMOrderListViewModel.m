//
//  YZMOrderListViewModel.m
//  Hairdressing
//
//  Created by yzm on 16/4/14.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "YZMOrderListViewModel.h"
#import "MRCViewModelServices.h"
#import "YZMOrderModel.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApiObject.h"
#import "WXApi.h"
#import "WXApiManager.h"

@interface YZMOrderListViewModel ()<WXApiManagerDelegate,WXApiDelegate>

@property (nonatomic, strong) NSString *outTradeNo;




@end

@implementation YZMOrderListViewModel

- (instancetype)initWithServices:(id<MRCViewModelServices>)services params:(NSDictionary *)params
{
    self = [super initWithServices:services params:params];
    if (self) {
        self.requestType = [params[@"requestType"] integerValue];
    }
    return self;
}

- (void)initialize
{
    [super initialize];
    
    self.title = @"我的订单";
    
    @weakify(self)

    self.payOrderCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString * orderID) {
       
        return [self.services.orderService payOrderWithPayType:_payType orderId:orderID];
    }];
    
    self.editOrderCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString * orderID) {
        
        return [self.services.orderService editOrderWithOrderEditStatus:self.editStatus orderId:orderID];
    }];
    
    [WXApiManager sharedManager].delegate = self;
    
    self.payResultCommand  = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [[[self.services studioService] confirmOrderPaidOrNotWithToken:[[NSUserDefaults standardUserDefaults] valueForKey:USER_TOKEN] payType:@(_payType) outTradeNum:self.outTradeNo] doNext:^(NSDictionary * dic) {
            
            if ([dic[@"status"] integerValue] == 2 ) {//支付宝文档建议此处再去服务端查询一下支付结果，以服务端查询结果为准
                DLog(@"服务器返回 成功支付结果");
            }else{
                DLog(@"服务器返回 支付失败结果");
            }
        }];
    }];
   

    
    [self.payOrderCommand.executionSignals.switchToLatest subscribeNext:^(id responeData) {
            
            // 获取到订单成功，跳转至支付宝支付页面。
            //将签名成功字符串格式化为订单字符串,请严格按照该格式
            @strongify(self)
            
            if (self.payType == YZMOrderPayTypeAli) {//支付宝支付
                NSString *appScheme = @"alisdkYZMHairDressing";
                NSString *orderString = responeData[@"url"];
               self.outTradeNo =responeData[@"outTradeNo"];
                [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                    @strongify(self)
                    NSLog(@"reslut = %@",resultDic);
                    //跳转支付宝钱包进行支付，处理支付结果
                    [self.payResultCommand execute:self.outTradeNo];
                    
                }];
            }
            else{//微信支付
                
                [self jumpToBizPay:responeData];
                
            }
        
    }];
    
}

-(void)jumpToBizPay:(NSDictionary*)dict{
    if (![WXApi isWXAppInstalled]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还没有安装微信，请先下载微信客户端" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去下载", nil];
        [[self rac_signalForSelector:@selector(alertView:clickedButtonAtIndex:) fromProtocol:@protocol(UIAlertViewDelegate)] subscribeNext:^(RACTuple *tuple) {
            switch ([tuple.second integerValue]) {
                case 0:
                    //            {
                    //                dispatch_async(dispatch_get_main_queue(), ^{
                    //                    [self.services popViewModelAnimated:YES];
                    //                });
                    //            }
                    //  NSLog(@"tuple 0 ");
                    break;
                case 1:
                {
                    
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id414478124"]];
                    // NSLog(@"tuple 1 ");
                }
                    
                    break;
                default:
                    break;
            }
        }];
        [alertView show];
    } else if (![WXApi isWXAppSupportApi]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的微信版本不支持支付功能" delegate:self cancelButtonTitle:nil otherButtonTitles:@"去下载", nil];
        [[self rac_signalForSelector:@selector(alertView:clickedButtonAtIndex:) fromProtocol:@protocol(UIAlertViewDelegate)] subscribeNext:^(RACTuple *tuple) {
            switch ([tuple.second integerValue]) {
                case 0:
                    //  NSLog(@"tuple 0 ");
                    break;
                case 1:
                    // NSLog(@"tuple 1 ");
                    break;
                default:
                    break;
            }
        }];
        [alertView show];
    }
    
    dict = [dict objectForKey:@"url"];
    if(dict != nil)
    {
        NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
        
        //调起微信支付
        PayReq* req             = [[PayReq alloc] init];
        req.partnerId           = [dict objectForKey:@"partnerid"];
        req.prepayId            = [dict objectForKey:@"prepayid"];
        req.nonceStr            = [dict objectForKey:@"noncestr"];
        req.timeStamp           = stamp.intValue;
        req.package             = [dict objectForKey:@"package"];
        req.sign                = [dict objectForKey:@"sign"];
        
        [WXApi sendReq:req];
        //日志输出
    }
    
}

//-(void)jumpToBizPay:(NSDictionary*)dict{
//    dict = [dict objectForKey:@"url"];
//    if(dict != nil)
//    {
//        NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
//        
//        //调起微信支付
//        PayReq* req             = [[PayReq alloc] init];
//        req.partnerId           = [dict objectForKey:@"partnerid"];
//        req.prepayId            = [dict objectForKey:@"prepayid"];
//        req.nonceStr            = [dict objectForKey:@"noncestr"];
//        req.timeStamp           = stamp.intValue;
//        req.package             = [dict objectForKey:@"package"];
//        req.sign                = [dict objectForKey:@"sign"];
//        
//        [WXApi sendReq:req];
//        //日志输出
//    }
//    
//}
-(void)managerDidRecvPayResp:(BaseResp *)resp{
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp*response=(PayResp*)resp;
        
        [self.payResultCommand execute:self.outTradeNo];
        
        switch(response.errCode){
                DLog(@"微信支付返回结果 %@",response);
            case WXSuccess:
                //服务器端查询支付通知或查询API返回的结果再提示成功
                DLog(@"支付成功");
                break;
            default:
                DLog(@"支付失败，retcode=%d",resp.errCode);
                break;
        }
    }
    
}
- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page
{
    return [[self.services.orderService getOrdersWithOrderrRequestType:_requestType] map:^id(id value) {
        NSArray *array = [YZMOrderModel mj_objectArrayWithKeyValuesArray:value[@"data"]];
        return array;
    }];
}

#pragma mark - WXApiDelegate
/**
 *  照微信SDK Sample，在类实现onResp函数，支付完成后，微信APP会返回到商户APP并回调onResp函数，开发者需要在该函数中接收通知，判断返回错误码，如果支付成功则去后台查询支付结果再展示用户实际支付结果。
 *
 *  @param resp
 */
-(void)onResp:(BaseResp*)resp{
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp*response=(PayResp*)resp;
        switch(response.errCode){
            case WXSuccess:
                //服务器端查询支付通知或查询API返回的结果再提示成功
                NSLog(@"支付成功");
                break;
            default:
                NSLog(@"支付失败，retcode=%d",resp.errCode);
                break;
        }
    }
}

@end