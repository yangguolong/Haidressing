//
//  RegistServiceImpl.m
//  MTM
//
//  Created by 杨国龙 on 16/1/27.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "RegistServiceImpl.h"
#import "NSString+Category.h"

@implementation RegistServiceImpl

- (RACSignal *)registWithUserName:(NSString *)username password:(NSString *)password authCode:(NSString *)authCode withType:(NSNumber*)type
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"jsonrpc"] = @"2.0";
    parameters[@"params"] = @[ @{@"mobile" : username, @"pwd" : [password md5Str], @"captcha" : authCode, @"type" : type } ];

    return [super requestDataFromNetWithParams:parameters withAction:@"signIn"];
}

- (RACSignal *)getAuthCodeWithPhoneNumber:(NSString *)phoneNumber
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"jsonrpc"] = @"2.0";
    parameters[@"params"] = @[ @{@"mobile" : phoneNumber }];
//        parameters[@"params"] = @[ @{@"telno" : phoneNumber }];
    //    parameters[@"params"] = @[ @{@"cityId" : @"440300", @"sortType": @"1", @"districtId" : @"0", @"townId" : @"0", @"longitude": @"114.02597366", @"latitude": @"22.54605355", @"distance": @"100000000", @"pNo": @"1", @"pSize": @"10" } ];
//    NSLog(@"dic:%@",parameters);
    return [super requestDataFromNetWithParams:parameters withAction:@"sendMobileCode"];
}

@end