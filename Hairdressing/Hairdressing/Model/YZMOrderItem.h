//
//  YZMOrderItem.h
//  Hairdressing
//
//  Created by yzm on 5/20/16.
//  Copyright © 2016 Yangjiaolong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZMOrderItem : NSObject

@property (nonatomic ,copy) NSString *item_id;         // 服务项目id
@property (nonatomic ,copy) NSString *item_name;       // 服务项目名称
@property (nonatomic ,copy) NSString *item_num;        // 服务项目数量
@property (nonatomic ,copy) NSString *item_url;        // 服务项目图片
@property (nonatomic ,copy) NSString *price;      // 服务项目价格


@end
