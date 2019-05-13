//
//  YZMOrderCoupon.h
//  Hairdressing
//
//  Created by yzm on 5/20/16.
//  Copyright © 2016 Yangjiaolong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZMOrderCoupon : NSObject

@property (nonatomic ,copy) NSString *coupon_id;        // 优惠券id
@property (nonatomic ,copy) NSString *coupon_name;      // 优惠券名称
@property (nonatomic ,copy) NSString *face_value;       // 面值

@end
