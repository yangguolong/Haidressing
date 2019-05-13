//
//  YZMCouponsModel.h
//  Hairdressing
//
//  Created by Yangjiaolong on 16/5/25.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZMCouponsModel : NSObject

@property (nonatomic,copy)NSString * coupon_id;

@property (nonatomic,copy)NSString * face_value;

@property (nonatomic,copy)NSString * coupon_name;

@property (nonatomic,copy)NSString * coupon_img;

@property (nonatomic,copy)NSString * coupon_desc;

@property (nonatomic,copy)NSString * corp_id;

@property (nonatomic,copy)NSString * item_id;

@property (nonatomic,copy)NSString * start_time;

@property (nonatomic,copy)NSString * stop_time;

@property (nonatomic,copy)NSString * create_time;


/**
 "coupon_id": "1",
 "face_value": "20",
 "coupon_name": "新注册用户优惠券",
 "coupon_img": " http://xxxx/x.jpg ",
 "coupon_desc": "新用户注册，手单立减20元",
 "corp_id": "1002",
 "item_id": "10",
 "city_id": "40030",
 "start_time": "1460022794",
 "stop_time": "1460022794",
 "create_time": "1460022794"

 */
@end
