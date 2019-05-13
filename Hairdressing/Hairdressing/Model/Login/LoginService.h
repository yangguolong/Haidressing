//
//  LoginService.h
//  MTM
//
//  Created by 杨国龙 on 16/1/21.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@protocol LoginService <NSObject>

- (RACSignal *)loginWithUserName:(NSString *)username password:(NSString *)password;

-(RACSignal *)loginoutWithUserToken:(NSString*)token;
//- (RACSignal *)loginWithUserName:(NSString *)username password:(NSString *)password loginway:(NSString *)loginway reception:(NSString *)reception nickName:(NSString *) nickname;

//- (RACSignal *)loginWithWeiboAndUserName:(NSString *)username reception:(NSString *)reception nickName:(NSString *) nickname;
//
//- (RACSignal *)loginWithWeChatAndUserName:(NSString *)username reception:(NSString *)reception nickName:(NSString *) nickname;
//
//
//- (RACSignal *)loginWithQQAndUserName:(NSString *)username reception:(NSString *)reception nickName:(NSString *) nickname;


@end
