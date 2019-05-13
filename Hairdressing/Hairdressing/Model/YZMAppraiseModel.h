//
//  YZMAppraiseModel.h
//  Hairdressing
//
//  Created by Yangjiaolong on 16/5/24.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZMAppraiseModel : NSObject
//用户登录token
@property (nonatomic,copy)NSString * token;
//订单id
@property (nonatomic,copy)NSString * order_id;
/**
 *  评论内容
 */
@property (nonatomic,copy)NSString * remark;
/**
 *  技术评分
 */
@property (nonatomic,assign)NSInteger tech_score;
/**
 *  服务评分
 */
@property (nonatomic,assign)NSInteger service_score;
/**
 *  环境评分
 */
@property (nonatomic,assign)NSInteger env_score;
/**
 *  标签id，逗号分隔
 */
@property (nonatomic,copy)NSString * labels;

@end
