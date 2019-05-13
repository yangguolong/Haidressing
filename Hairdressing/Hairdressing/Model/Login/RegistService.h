//
//  RegistService.h
//  MTM
//
//  Created by 杨国龙 on 16/1/27.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@protocol RegistService <NSObject>

- (RACSignal *)registWithUserName:(NSString *)username password:(NSString *)password authCode:(NSString *)authCode withType:(NSNumber*)type;

- (RACSignal *)getAuthCodeWithPhoneNumber:(NSString *)phoneNumber;

@end
