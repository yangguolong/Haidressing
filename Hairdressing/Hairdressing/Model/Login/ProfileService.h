
//
//  ProfileService.h
//  MTM
//
//  Created by 杨国龙 on 16/2/24.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
//#import "ShippingModel.h"

@protocol ProfileService <NSObject>


-(RACSignal *)findPwdAndModifyWithPhone:(NSString *)tel newPassword:(NSString *)newPassword code:(NSString *)code  withType:(NSNumber*)type;


/**
 *  我的收藏列表
 *
 *  @param pNo   页码用第一页开始
 *  @param pSize 每页记录数
 *
 *  @return 
 */
-(RACSignal *)getFavorspNo:(NSInteger )pNo pSize:(NSInteger )pSize;

@end