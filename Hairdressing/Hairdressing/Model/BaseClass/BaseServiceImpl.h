//
//  ServiceImpl.h
//  MTM
//
//  Created by 杨国龙 on 16/1/27.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
//#import "User+Persistence.h"
//#import "UserManager.h"

@interface BaseServiceImpl : NSObject

//- (RACSignal *)requestDataFromNetWithParams:(NSDictionary *)parameters;
- (RACSignal *)requestDataFromNetWithParams:(NSDictionary *)parameters withAction:(NSString *)action;

- (RACSignal *)requestDataFromNetWithURLConfig:(NSString *)URLParam withAction:(NSString *)action;

-(RACSignal *)uploadImage:(UIImage *)image withToken:(NSString *)token AndAction:(NSString*)action;

@end
