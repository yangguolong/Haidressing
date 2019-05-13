//
//  SettingServiceImpl.m
//  Hairdressing
//
//  Created by Guolong Yang on 16/4/14.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "SettingServiceImpl.h"
#import <AFNetworking/AFNetworking.h>
//#import "AppMacro.h"
#import <MJExtension/MJExtension.h>
#import "NSString+Category.h"

@implementation SettingServiceImpl


- (RACSignal *)settingWithToken:(NSString*)token UserName:(NSString *)username Birthday:(NSString*)birthday Sexurity:(NSString*)sex{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"jsonrpc"] = @"2.0";
    NSNumber *sexSignalInt = 0;
    if ([sex isEqualToString:@"男"]) {
        sexSignalInt = @1;
    }
    else
        sexSignalInt = @2;
    // 1.时间戳
    NSInteger timeStamp = [Utility timestampToDate:birthday type:6];
    
    parameters[@"params"] = @[ @{@"token" : token, @"nickname": username,@"birthday": [NSNumber numberWithInteger:timeStamp],@"sex":sexSignalInt } ];
    
    return [self requestDataFromNetWithParams:parameters withAction:@"setMyInfo"];
}


//上传用户头像
-(RACSignal *)uploadHeadImageWithToken:(NSString*)token HeadImage:(UIImage*)avartImage andAction:(NSString*)action
{
    //    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //    parameters[@"jsonrpc"] = @"2.0";
    //    parameters[@"params"] = @[ @{@"token" : token,@"token" : token, @"setMyAvatar": setMyAvatar } ];
    
    //   parameters[@"params"] = @[@{@"name" : username, @"password" : [password md5Str],@"loginway":loginway,@"nick":nickname,@"reception":reception}];
    
    return [self uploadImage:avartImage withToken:token AndAction:action];
    
    
}




-(RACSignal *)feedBackWithToken:(NSString*)token Content:(NSString*)content AndContactWay:(NSString*)contact_way
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"jsonrpc"] = @"2.0";
    parameters[@"params"] = @[ @{@"token" : token, @"content": content,@"contact_way": contact_way } ];

    //   parameters[@"params"] = @[@{@"name" : username, @"password" : [password md5Str],@"loginway":loginway,@"nick":nickname,@"reception":reception}];

    return [self requestDataFromNetWithParams:parameters withAction:@"feedback"];


}

//上传用户头像
-(RACSignal *)getUserInfoWithToken:(NSString*)token
{
  //  return [self uploadImage:avartImage withToken:token AndAction:action];//myInfo
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"jsonrpc"] = @"2.0";
    parameters[@"params"] = @[ @{@"token" : token } ];
    return [self requestDataFromNetWithParams:parameters withAction:@"myInfo"];
    
}
- (RACSignal *)getCommentWithStudioID:(NSNumber*)cropId pageNum:(NSNumber*)pNo pageSize:(NSNumber*)pSize{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"jsonrpc"] = @"2.0";
    parameters[@"params"] = @[ @{@"corpId" : cropId,@"pNo" : pNo,@"pSize" : pSize } ];
    
    return [self requestDataFromNetWithParams:parameters withAction:@"getCommentList"];
}



@end
