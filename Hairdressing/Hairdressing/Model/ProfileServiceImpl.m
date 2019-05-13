//
//  ProfileServiceImpl.m
//  MTM
//
//  Created by 杨国龙 on 16/2/24.
//  Copyright © 2016年 cloudream. All rights reserved.
//

#import "ProfileServiceImpl.h"
#import "MJExtension.h"

@implementation ProfileServiceImpl

- (RACSignal *)getTdDataList
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"id"] = @"12";
    parameters[@"jsonrpc"] = @"2.0";
    parameters[@"method"] = @"getTd2DataMApp";
    NSString *uid = [UserManager shareInstance].user ? [UserManager shareInstance].user.uid : @"" ;
    parameters[@"params"] = @[ @{ @"uId": uid } ];
    
    
    
    return [super requestDataFromNetWithParams:parameters];
}

-(RACSignal *)uploadImage:(id )image{
    
    NSMutableDictionary * parameters = [self getParameterDicWithMethodName:@"uploadUserFaceMApp"];
    User *user = [UserManager shareInstance].user;
    NSString *uid = user ? user.uid : @"" ;
    parameters[@"params"] = @[ @{ @"uid": uid} ];

    return [super uploadImage:image withParams:nil];
}
-(RACSignal *)modifyUserInfo{
     NSMutableDictionary * parameters = [self getParameterDicWithMethodName:@"modifyPersonInfoMApp"];
    
    User *user = [UserManager shareInstance].user;
    parameters[@"params"] = @[ @{ @"uid": user.uid,@"name":user.username?:@"",@"img_url":user.img_url?:@"",@"sex":user.sex?:@"",@"age":user.age?:@""} ];

    return [super requestDataFromNetWithParams:parameters];
}

- (RACSignal *)getTdDetailWithTid:(NSString *)tid
{

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"id"] = @"12";
    parameters[@"jsonrpc"] = @"2.0";
    parameters[@"method"] = @"getTdDetailMApp";
    parameters[@"params"] = @[ @{ @"tId": tid } ];
    
    return [super requestDataFromNetWithParams:parameters];

}

- (RACSignal *)delTdDataWithTid:(NSString *)tid{
    NSMutableDictionary * parameters = [self getParameterDicWithMethodName:@"delTdDataMApp"];
    parameters[@"params"] = @[ @{ @"tId": tid} ];
    
    return [super requestDataFromNetWithParams:parameters];
}


- (RACSignal *)bindTdDataGUID:(NSString *)GUID
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"id"] = @"12";
    parameters[@"jsonrpc"] = @"2.0";
    parameters[@"method"] = @"bindTdDataMApp";
      User *user = [UserManager shareInstance].user;
    NSString *uid = user ? user.uid : @"" ;
    
    parameters[@"params"] = @[ @{ @"uId": uid, @"guid" : GUID } ];
    
    return [super requestDataFromNetWithParams:parameters];
}
-(RACSignal *)getUserInfo{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"id"] = @"12";
    parameters[@"jsonrpc"] = @"2.0";
    parameters[@"method"] = @"getPersonInfoMApp";
    User *user = [UserManager shareInstance].user;
    NSString *userid = user ? user.uid : @"";
    
    parameters[@"params"] = @[ @{ @"userid": userid}];
    
    return [super requestDataFromNetWithParams:parameters];
    
}

-(RACSignal *)findPwdAndModifyWithPhone:(NSString *)tel newPassword:(NSString *)newPassword code:(NSString *)code{
    NSMutableDictionary * parameters = [self getParameterDicWithMethodName:@"findPwdAndModifyMApp"];
    parameters[@"telno"] = tel;
    parameters[@"newpassword"] = newPassword;
    parameters[@"code"] = code;
    
    return [super requestDataFromNetWithParams:parameters];
}

-(RACSignal *)getShippingAddressList{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"id"] = @"12";
    parameters[@"jsonrpc"] = @"2.0";
    parameters[@"method"] = @"getShippingAddressListMApp";
    User *user = [UserManager shareInstance].user;
    NSString *userid = user ? user.uid : @"";
    
    parameters[@"params"] = @[ @{ @"uid": userid} ];
    
    return [super requestDataFromNetWithParams:parameters];

}

-(RACSignal *)addshippingAddressWith:(ShippingModel *)model{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"id"] = @"12";
    parameters[@"jsonrpc"] = @"2.0";
    parameters[@"method"] = @"addShippingAddressMApp";
    User *user = [UserManager shareInstance].user;
    NSString *userid = user ? user.uid : @"";
    model.uid = userid;
    parameters[@"params"] = @[ model.mj_keyValues ];
    
    return [super requestDataFromNetWithParams:parameters];
 
}

-(RACSignal *)delShippingAddressWithShippingID:(NSString *)aid{
    NSMutableDictionary * parameters = [self getParameterDicWithMethodName:@"delShippingAddressMApp"];
    User *user = [UserManager shareInstance].user;
    NSString *userid = user ? user.uid : @"";
    parameters[@"params"] = @[@{ @"uid":userid,@"aid":aid} ];

    return [super requestDataFromNetWithParams:parameters];
}

-(RACSignal *)setDefaultShippingAddressWithID:(NSString *)aid{
    NSMutableDictionary * parameters = [self getParameterDicWithMethodName:@"setDefaultShippingAddressMApp"];
    User *user = [UserManager shareInstance].user;
    NSString *userid = user ? user.uid : @"";
    parameters[@"params"] = @[@{ @"uid":userid,@"aid":aid} ];

    return [super requestDataFromNetWithParams:parameters];

}

-(RACSignal *)getOrderList{
    NSMutableDictionary *parameters = [self getParameterDicWithMethodName:@"getOrderListMApp"];
    User *user = [UserManager shareInstance].user;
    NSString *userid = user ? user.uid : @"";
    
    parameters[@"params"] = @[ @{ @"userid": userid} ];
    
    return [super requestDataFromNetWithParams:parameters];
}

-(RACSignal *)delOrderwithOrderId:(NSString *)orderId{
    NSMutableDictionary *parameters = [self getParameterDicWithMethodName:@"delOrderMApp"];
    parameters[@"params"] = @[ @{ @"oid": orderId}];
    return [super requestDataFromNetWithParams:parameters];
}


-(NSMutableDictionary *)getParameterDicWithMethodName:(NSString *)methodName{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"id"] = @"12";
    parameters[@"jsonrpc"] = @"2.0";
    parameters[@"method"] = methodName;

    return parameters;
}

@end
