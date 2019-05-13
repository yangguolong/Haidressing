//
//  AliPayDemoViewModel.m
//  Hairdressing
//
//  Created by Guolong Yang on 16/5/10.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "AliPayDemoViewModel.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApiObject.h"
#import "WXApi.h"
@interface AliPayDemoViewModel()
@property(nonatomic,strong,readwrite)RACCommand *payCommand;

@property(nonatomic,strong,readwrite)RACCommand *confirmCommand;//确定订单是否已支付
@property(nonatomic,assign,readwrite)int payType;

@property(nonatomic,assign,readwrite)int itemID;

@property(nonatomic,assign,readwrite)int orderNum;


@end

@implementation AliPayDemoViewModel

-(void)initialize{
    @weakify(self)
   // self.payType = 1;
    self.itemID = 50;
    self.orderNum = 1;
    void (^doNext)(NSDictionary *) = ^(NSDictionary *responeData) {
    //    @strongify(self)
        // 获取到订单成功，跳转至支付宝支付页面。
        //将签名成功字符串格式化为订单字符串,请严格按照该格式
                @strongify(self)
        
        if (self.payType == 1) {//支付宝支付
            NSString *appScheme = @"alisdkYZMHairDressing";
            NSString *orderString = responeData[@"url"];
            NSString *tradeNumStr =responeData[@"outTradeNo"];
            [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                @strongify(self)
                NSLog(@"reslut = %@",resultDic);
                //跳转支付宝钱包进行支付，处理支付结果
                
                [self.confirmCommand execute:tradeNumStr];
            }];
        }
        else{//微信支付
            [self jumpToBizPay:responeData];
        
        }

        
        
    };
    
    self.payCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *payType) {
        @strongify(self)
        
       // [self alipayCall];
        self.payType = [payType intValue];//付款类型
        return [[self.services.studioService getSignedOrderWithToken:[[NSUserDefaults standardUserDefaults]objectForKey:USER_TOKEN] payType:payType ItemID:[NSNumber numberWithInt:self.itemID] andOrderNum:[NSNumber numberWithInt:self.orderNum]] doNext:doNext];
    }];
    self.confirmCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *taderNumStr) {
        @strongify(self)
        
        // [self alipayCall];
        
        return [[self.services.studioService confirmOrderPaidOrNotWithToken:[[NSUserDefaults standardUserDefaults]objectForKey:USER_TOKEN] payType:[NSNumber numberWithInt:self.payType] outTradeNum:taderNumStr] doNext:^(NSDictionary *dict) {
                if ([dict[@"status"] integerValue] == 2 ) {//支付宝文档建议此处再去服务端查询一下支付结果，以服务端查询结果为准
                    //支付成功,这里放你们想要的操作
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"支付成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [[self rac_signalForSelector:@selector(alertView:clickedButtonAtIndex:) fromProtocol:@protocol(UIAlertViewDelegate)] subscribeNext:^(RACTuple *tuple) {
                        switch ([tuple.second integerValue]) {
                            case 0:
                                NSLog(@"确定");
                                break;
                            case 1:
                                NSLog(@"tuple 1 ");
                                break;
                            default:
                                break;
                        }
                    }];
                    [alertView show];
                }
                else{
                    NSString *msg  =@"支付未成功";
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [[self rac_signalForSelector:@selector(alertView:clickedButtonAtIndex:) fromProtocol:@protocol(UIAlertViewDelegate)] subscribeNext:^(RACTuple *tuple) {
                        switch ([tuple.second integerValue]) {
                                case 0:
                                NSLog(@"确定");
                                break;
                            case 1:
                                NSLog(@"tuple 1 ");
                                break;
                            default:
                                break;
                        }
                    }];
                    [alertView show];
                    
                }
        }];
    }];
    
}



-(void)jumpToBizPay:(NSDictionary*)dict{
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




//-(void)alipayCall{
//    //
//    //选中商品调用支付宝极简支付
//    /*
//     *点击获取prodcut实例并初始化订单信息
//     */
//    /*
//     *商户的唯一的parnter和seller。
//     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
//     */
//    
//    /*============================================================================*/
//    /*=======================需要填写商户app申请的===================================*/
//    /*============================================================================*/
//    NSString *partner = @"2088221649060907";//PID
//    NSString *seller = @"product@Yangjiaolong.com";//收款账号
//    NSString *privateKey = @"MIICXQIBAAKBgQDZ4y4gNrbGsHliTutpouq5hr1BNc7FkZsSdiTFoTHetXKdvIA/cKTNXnjODNdd8Nzf2wq2Ah0QcyJFoKzyN0lNZ2boMeQUfpEWHmhoQ9BZ+mTyQckGBe93kxmKzFLiUVCz5c66smb53bF8T05hA11ZeLSUbOVCQngDAjkJFt21ZwIDAQABAoGBAKYPOuxaRtsPTLPcKhcMj5BuXHcCp2B0JJfhaw0kWXm/GGeXbrbrBu9ufOutZca299+0dWlaGwSaexhN6QGBmV74xcw4Cq1kA+77XZtyixxg2pK4fD7Vt48BtEEycCjL+xjukQY/1On4vHnTMjbq3BD7BlDxmDCV63oIC/DYODhBAkEA8VcYEEgEteGyuzYLD3/olyZrcWstRBZVJxAXxPsrI7oCD3SFLslnrFNLRGv+0yHe45DR3O4UQ4HAmPk+YQLDCQJBAOcfY5E+tjhpGCa2/kMP48kEp1A31zrlbnm3D2YiQIQF0+GouZRJkWKEftOCke4z6ifKC+Aj8YGYltFIhVVEoO8CQFzclzzEiVN2ubABVnYrUFLAjL0CcVNuiGtUbOD1iB7iFqLdwdVD1+ldz2tPZqjUso+7jJTG4vMqvPHfjZoEVwkCQQDPfMNzOlx2SgrvfqrG47X32eCmyGrFqgFC7c+6PhezLlQoKsPn1x/Y1N/S3E5MDXkyHVYJ89q1IJqM6dEhWoorAkAgykiIeqFIYP/6I1MYENkjYZNzRegzlvEQh2J6PvwUsbD+mJ7kjfdSdnkN67QZ4i3JbunEWDSKIgfTtZlu+psp";//私钥
//    /*============================================================================*/
//    /*============================================================================*/
//    /*============================================================================*/
//    
//    //partner和seller获取失败,提示
//    if ([partner length] == 0 ||
//        [seller length] == 0 ||
//        [privateKey length] == 0)
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                        message:@"缺少partner或者seller或者私钥。"
//                                                       delegate:self
//                                              cancelButtonTitle:@"确定"
//                                              otherButtonTitles:nil];
//        [alert show];
//        return;
//    }
//    
//    /*
//     *生成订单信息及签名
//     */
//    //将商品信息赋予AlixPayOrder的成员变量
//    Order *order = [[Order alloc] init];
//    order.partner = partner;
//    order.seller = seller;
//    order.tradeNO = [self generateTradeNO]; //订单ID（由商家自行制定）
////    order.productName = product.subject; //商品标题
////    order.productDescription = product.body; //商品描述
////    order.amount = [NSString stringWithFormat:@"%.2f",product.price]; //商品价格
//    order.notifyURL =  @"http://www.xxx.com"; //回调URL
//    
//    order.service = @"mobile.securitypay.pay";
//    order.paymentType = @"1";
//    order.inputCharset = @"utf-8";
//    order.itBPay = @"30m";
//    order.showUrl = @"m.alipay.com";
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
//        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//            NSLog(@"reslut = %@",resultDic);
//        }];
//    }
//    
//}
//
//- (NSString *)generateTradeNO
//{
//    static int kNumber = 15;
//    
//    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
//    NSMutableString *resultStr = [[NSMutableString alloc] init];
//    srand((unsigned)time(0));
//    for (int i = 0; i < kNumber; i++)
//    {
//        unsigned index = rand() % [sourceStr length];
//        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
//        [resultStr appendString:oneStr];
//    }
//    return resultStr;
//}
//-(void)aliPayConfirm{
//
//    if ([resultDic[@"ResultStatus"] isEqualToString:@"9000"]) {//支付宝文档建议此处再去服务端查询一下支付结果，以服务端查询结果为准
//        //支付成功,这里放你们想要的操作
//        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"支付成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [[self rac_signalForSelector:@selector(alertView:clickedButtonAtIndex:) fromProtocol:@protocol(UIAlertViewDelegate)] subscribeNext:^(RACTuple *tuple) {
//            switch ([tuple.second integerValue]) {
//                    
//                    NSLog(@"确定");
//                    break;
//                case 1:
//                    NSLog(@"tuple 1 ");
//                    break;
//                default:
//                    break;
//            }
//        }];
//        [alertView show];
//    }
//    else{
//        NSString *msg  =nil;
//        if([resultDic[@"memo"] length]!=0)
//            msg =[resultDic[@"memo"] stringValue];
//        else
//            msg = @"支付异常";
//        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [[self rac_signalForSelector:@selector(alertView:clickedButtonAtIndex:) fromProtocol:@protocol(UIAlertViewDelegate)] subscribeNext:^(RACTuple *tuple) {
//            switch ([tuple.second integerValue]) {
//                    
//                    NSLog(@"确定");
//                    break;
//                case 1:
//                    NSLog(@"tuple 1 ");
//                    break;
//                default:
//                    break;
//            }
//        }];
//        [alertView show];
//        
//    }
//
//}

@end
