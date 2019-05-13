//
//  ServiceImpl.m
//  MTM
//
//  Created by 杨国龙 on 16/1/27.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "BaseServiceImpl.h"
#import <AFNetworking/AFNetworking.h>
//#import "AppMacro.h"
#import <MJExtension/MJExtension.h>
#import "NSString+Category.h"
#import "Utility.h"

// http://服务地址/appapi/getAd?request_id=123&time=123&sign=cessssss
// http://服务地址/appapi/index?request_id=123&time=123&sign=cessssss
// http://服务地址/appapi/getCorplist?request_id=123&time=123&sign=cessssss
// http://服务地址/appapi/getCorpinfo?request_id=123&time=123&sign=cessssss
// http://服务地址/appapi/getServiceList?request_id=123&time=123&sign=cessssss
// http://服务地址/appapi/getServiceInfo?request_id=123&time=123&sign=cessssss
// http://服务地址/appapi/getCommentList?request_id=123&time=123&sign=cessssss
// http://服务地址/appapi/corpInfo?request_id=123&time=123&sign=cessssss
// http://服务地址/appapi/getHairstyleList?request_id=123&time=123&sign=cessssss
// http://服务地址/appapi/getHairstylist?request_id=123&time=123&sign=cessssss
// http://服务地址/appapi/getHairType?request_id=123&time=123&sign=cessssss
// http://服务地址/appapi/getPortfolios?request_id=123&time=123&sign=cessssss
// http://服务地址/appapi/corpInfo?request_id=123&time=123&sign=cessssss
// http://服务地址/appapi/login?request_id=123&time=123&sign=cessssss


@implementation BaseServiceImpl

- (RACSignal *)requestDataFromNetWithParams:(NSDictionary *)parameters withAction:(NSString *)action
{
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        // 1.时间戳
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval timestamp=[dat timeIntervalSince1970];
        NSString *time = [NSString stringWithFormat:@"%0.f", timestamp];
        
        // 2. request_id: 标识每个请求的唯一数字串,对于同一个request_id的请求，服务器端只接受一次.规则：年份(2位)+月份+日期+时+分+秒+6位随机数    例如 160218160101123456s
        NSString *date = [Utility  getDateByTimestamp:timestamp type:8];
        NSString * genRandString = [Utility genRandStringLength:6];
        NSString *request_id = [NSString stringWithFormat:@"%@%@", date, genRandString];
        
        
        // 3.sign: 指请求方按照后台规定的规则生成的一串字符串，后台系统用该字符串进行请求的身份认证。
        // 生成规则：md5(BA),其中A= "API请求地址的?后的所有字符串(不包括sign)"，B=md5('hair.cloud.net ')。
        
        NSString *B = [@"hair.cloud.net" md5Str];
        NSString *A = [NSString stringWithFormat:@"request_id=%@&time=%@",request_id ,time] ;
        NSString *sign = [[NSString stringWithFormat:@"%@%@", B, A] md5Str];
        
        NSString *requestURL = [NSString stringWithFormat:@"%@%@?%@&sign=%@",ONLINEHOST,action, A, sign];
        DLog(@"设置请求URL: %@", requestURL);
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestURL]];
        [request setHTTPMethod:@"POST"];
        
        // 添加body
        NSString *str = [parameters mj_JSONString];
        if (str) {
            DLog(@"设置请求参数：%@",str);
            NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
            [request setHTTPBody:data];
        }
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        manager.responseSerializer = [AFJSONResponseSerializer serializer]; //AFJSONResponseSerializer
        NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error)
        {
            if (error)
            {
              
                DLog(@"Error: %@", error);
                [subscriber sendError:error];
                
            } else
            {
                NSLog(@"%@ %@", response, responseObject);
     
                if([responseObject objectForKey:@"code"])
                {                          
                    
                    int code = [responseObject[@"code"] intValue];
                    switch (code) {
                        case 0:
                            
                            DLog(@"请求成功: %@", responseObject[@"result"]);
                            [subscriber sendNext:responseObject[@"result"]];
                            [subscriber sendCompleted];
                            
                            break;
                            
                        default:
                            DLog(@"Error: %@", responseObject[@"msg"]);
                            [subscriber sendError:responseObject[@"msg"]];
                            break;
                    }
                }
            }
        }];
        [dataTask resume];
        
        return [RACDisposable disposableWithBlock:^{
            [dataTask cancel];
        }];
        
    }]
            replayLazily];
    
}


-(RACSignal *)uploadImage:(UIImage *)image withToken:(NSString *)token AndAction:(NSString*)action{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 1.时间戳
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval timestamp=[dat timeIntervalSince1970];
        NSString *time = [NSString stringWithFormat:@"%0.f", timestamp];
        
        // 2. request_id: 标识每个请求的唯一数字串,对于同一个request_id的请求，服务器端只接受一次.规则：年份(2位)+月份+日期+时+分+秒+6位随机数    例如 160218160101123456s
        NSString *date = [Utility  getDateByTimestamp:timestamp type:8];
        NSString * genRandString = [Utility genRandStringLength:6];
        NSString *request_id = [NSString stringWithFormat:@"%@%@", date, genRandString];
        
        //3.token string
        NSString *tokenStr = [NSString stringWithFormat:@"token=%@",token];
        
        // 4.sign: 指请求方按照后台规定的规则生成的一串字符串，后台系统用该字符串进行请求的身份认证。
        // 生成规则：md5(BA),其中A= "API请求地址的?后的所有字符串(不包括sign)"，B=md5('hair.cloud.net ')。
        
        NSString *B = [@"hair.cloud.net" md5Str];
        NSString *A = [NSString stringWithFormat:@"request_id=%@&time=%@",request_id ,time] ;
        NSString *sign = [[NSString stringWithFormat:@"%@%@", B, A] md5Str];
        
        NSString *requestURL = [NSString stringWithFormat:@"%@%@?%@&%@&sign=%@",ONLINEHOST,action, tokenStr,A, sign];
        DLog(@"设置请求URL: %@", requestURL);
        
//        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestURL]];
//        [request setHTTPMethod:@"POST"];

//        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestURL]];

          NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:requestURL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
              [formData appendPartWithFormData:UIImagePNGRepresentation(image) name:@"file"];
          } error:nil];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//        NSString *str = [parameters mj_JSONString];
//        if (str) {
//            DLog(@"设置请求参数：%@",str);
////            NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
////            [request setHTTPBody:data];
//        }
        NSData * imagedata = UIImagePNGRepresentation(image);
        
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
        [manager POST:requestURL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [formData appendPartWithFileData:imagedata name:@"file" fileName:@"1.png" mimeType:@"image/png"];
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [subscriber sendNext:responseObject[@"result"]];
            [subscriber sendCompleted];
            NSLog(@"re %@",responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [subscriber sendError:error];
            NSLog(@"error %@",error);
        }];
     //   [uploadTask resume];
        return [RACDisposable disposableWithBlock:^{
            
           // [uploadTask cancel];
        }];
    }];
    
    
}

@end