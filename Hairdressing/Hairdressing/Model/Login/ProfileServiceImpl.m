//
//  ProfileServiceImpl.m
//  MTM
//
//  Created by 杨国龙 on 16/2/24.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "ProfileServiceImpl.h"
#import "MJExtension.h"

@implementation ProfileServiceImpl


-(RACSignal *)findPwdAndModifyWithPhone:(NSString *)tel newPassword:(NSString *)newPassword code:(NSString *)code withType:(NSNumber*)type{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"jsonrpc"] = @"2.0";
    parameters[@"params"] = @[ @{@"mobile" : tel, @"pwd" : [newPassword md5Str], @"captcha" : code, @"type" : type } ];
    
    return [super requestDataFromNetWithParams:parameters withAction:@"signIn"];//修改密码和登录是同一个接口

}



-(RACSignal *)getFavorspNo:(NSInteger)pNo pSize:(NSInteger)pSize{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"jsonrpc"] = @"2.0";
    parameters[@"params"] = @[ @{@"pNo" : @(pNo), @"pSize" : @(pSize) ,@"token":[[NSUserDefaults standardUserDefaults] valueForKey:USER_TOKEN]}];
    
    return [super requestDataFromNetWithParams:parameters withAction:@"getFavors"];

}

@end
