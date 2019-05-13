//
//  YZMPayOrderViewController.m
//  Hairdressing
//
//  Created by Guolong Yang on 16/4/25.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "YZMPayOrderViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WechatAuthSDK.h"



#import "WXApi.h"
#import "WXApiObject.h"
@interface YZMPayOrderViewController ()

@end

@implementation YZMPayOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


-(void)aliPayRequest{


//    Order *order = [[Order alloc] init];
//    order.partner = partner;
//    order.seller = seller;
//    order.tradeNO = [self generateTradeNO]; //订单ID（由商家?自?行制定）
//    order.productName = product.subject; //商品标题
//    order.productDescription = product.body; //商品描述
//    order.amount = [NSString stringWithFormat:@"%.2f",product.price]; //商
//    品价格
//    order.notifyURL = @"http://www.test.com"; //回调URL
//    order.service = @"mobile.securitypay.pay";
//    order.paymentType = @"1";
//    order.inputCharset = @"utf-8";
//    order.itBPay = @"30m";
//    
//    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
//    NSString *appScheme = @"alisdkdemo";
//    
//    //将商品信息拼接成字符串
//    NSString *orderSpec = [order description];
//    NSLog(@"orderSpec = %@",orderSpec);
//    
//    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
//    id<DataSigner> signer = CreateRSADataSigner(privateKey);
//    NSString *signedString = [signer signString:orderSpec];
//    
//    //将签名成功字符串格式化为订单字符串,请严格按照该格式
//    NSString *orderString = nil;
//    if (signedString != nil) {
//        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
//                       orderSpec, signedString, @"RSA"];
//        
//        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {//唤起支付宝支付页面
//            //【callback处理支付结果】
//            NSLog(@"reslut = %@",resultDic);
//        }];
//        
    
//    }
}

-(void)weChatPayRequest{
    PayReq *request = [[PayReq alloc] init];
//    request.partnerId = @"10000100";
//    request.prepayId= @"1101000000140415649af9fc314aa427";
//    request.package = @"Sign=WXPay";
//    request.nonceStr= @"a462b76e7436e98e0ed6e13c64b4fd1c";
//    request.timeStamp= @"1397527777";
//    request.sign= @"582282D72DD2B03AD892830965F428CB16E7A256";
    [WXApi sendReq:request];

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
