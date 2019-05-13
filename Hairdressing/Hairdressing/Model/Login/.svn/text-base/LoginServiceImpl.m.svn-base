//

#import "LoginServiceImpl.h"
#import <AFNetworking/AFNetworking.h>
//#import "AppMacro.h"
#import <MJExtension/MJExtension.h>
#import "NSString+Category.h"

@implementation LoginServiceImpl



- (RACSignal *)loginWithUserName:(NSString *)username password:(NSString *)password loginway:(NSString *)loginway reception:(NSString *)reception nickName:(NSString *) nickname;
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //    parameters[@"id"] = @"12";
    //    parameters[@"jsonrpc"] = @"2.0";
    //    parameters[@"method"] = @"userLoginMApp";
    //    parameters[@"params"] = @[@{@"name" : username, @"password" : [password md5Str],@"loginway":loginway,@"nick":nickname,@"reception":reception}];
    //
    //    return [super requestDataFromNetWithParams:parameters];
    [parameters setObject:username forKey:@"name"];
    [parameters setObject:password forKey:@"password"];
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:parameters];
        [subscriber sendCompleted];
        return nil;
    }];
    
    return signal;
}

//- (RACSignal *)loginWithUserName:(NSString *)username password:(NSString *)password loginway:(NSString *)loginway reception:(NSString *)reception nickName:(NSString *) nickname;
//{
////    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
////    //    parameters[@"id"] = @"12";
////    //    parameters[@"jsonrpc"] = @"2.0";
////    //    parameters[@"method"] = @"userLoginMApp";
////    //    parameters[@"params"] = @[@{@"name" : username, @"password" : [password md5Str],@"loginway":loginway,@"nick":nickname,@"reception":reception}];
////    //    return [super requestDataFromNetWithParams:parameters];
////    [parameters setObject:username forKey:@"name"];
////    [parameters setObject:password forKey:@"password"];
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    parameters[@"id"] = @"12";
//    parameters[@"jsonrpc"] = @"2.0";
//    parameters[@"method"] = @"userLoginMApp";
//    parameters[@"params"] = @[@{@"name" : username, @"password" : [password md5Str],@"loginway":loginway,@"nick":nickname,@"reception":reception}];
//
//    return [self requestDataFromNetWithParams:parameters withAction:<#(NSString *)#>];
//}


- (RACSignal *)loginWithUserName:(NSString *)username password:(NSString *)password {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"jsonrpc"] = @"2.0";
        parameters[@"params"] = @[ @{@"mobile" : username, @"pwd": [password md5Str] } ];

 //   parameters[@"params"] = @[@{@"name" : username, @"password" : [password md5Str],@"loginway":loginway,@"nick":nickname,@"reception":reception}];
    
    return [self requestDataFromNetWithParams:parameters withAction:@"login"];
}

-(RACSignal *)loginoutWithUserToken:(NSString*)token{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"jsonrpc"] = @"2.0";
    parameters[@"params"] = @[ @{ @"token": token } ];
    
    return [self requestDataFromNetWithParams:parameters withAction:@"logout"];
}
@end
