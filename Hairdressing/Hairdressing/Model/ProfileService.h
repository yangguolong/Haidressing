
//
//  ProfileService.h
//  MTM
//
//  Created by 杨国龙 on 16/2/24.
//  Copyright © 2016年 cloudream. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "ShippingModel.h"

@protocol ProfileService <NSObject>

// 绑定测量数据
- (RACSignal *)bindTdDataGUID:(NSString *)GUID;

// 获取测量数据列表
- (RACSignal *)getTdDataList;

// 获取测量数据详情及拍照数据
- (RACSignal *)getTdDetailWithTid:(NSString *)tid;

/**
 *  删除量体数据
 *
 *  @param tid 量体数据id
 *
 *  @return 
 */
-(RACSignal *)delTdDataWithTid:(NSString *)tid;

/**
 *  获取用户信息
 *
 *
 *  @return 返回用户信息
 */
- (RACSignal *)getUserInfo;

/**
 *  修改用户信息
 *
 *  @return
 */
- (RACSignal *)modifyUserInfo;

/**
 *  找回密码
 *
 *  @param tel         手机号
 *  @param newPassword 新密码
 *  @param code        验证码
 *
 *  @return 
 */
-(RACSignal *)findPwdAndModifyWithPhone:(NSString *)tel newPassword:(NSString *)newPassword code:(NSString *)code;

/**
 *  上传图片
 *
 *  @param image 要上传的图片
 *
 *  @return
 */
-(RACSignal *)uploadImage:( id)image;

/**
 *  获取收回地址
 *
 *  @return 
 */
-(RACSignal *)getShippingAddressList;


/**
 *  添加收货地址
 *
 *  @param model 收货地址模型
 *
 *  @return
 */
-(RACSignal *)addshippingAddressWith:(ShippingModel * )model;

/**
 *  删除收货地址
 *
 *  @param aid 收货地址id
 *
 *  @return
 */
-(RACSignal *)delShippingAddressWithShippingID:(NSString *)aid;

/**
 *  设置默认收货地址
 *
 *  @param aid 收货地址id
 *
 *  @return 
 */
-(RACSignal *)setDefaultShippingAddressWithID:(NSString *)aid;


/**
 *  获取订单
 *
 *  @return
 */
-(RACSignal *)getOrderList;


/**
 *  删除订单
 *
 *  @param orderId 订单编号
 *
 *  @return
 */
-(RACSignal *)delOrderwithOrderId:(NSString *)orderId;

@end
