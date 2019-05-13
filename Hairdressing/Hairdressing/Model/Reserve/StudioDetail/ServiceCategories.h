//
//  ServiceCategories.h
//  Hairdressing
//
//  Created by Guolong Yang on 16/4/6.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceCategories : JKDBModel

@property(nonatomic,assign) NSUInteger serviceCount;//服务项目种类数量

@property(nonatomic,assign) int itemId;
@property(nonatomic,assign) int corp_id;
@property(nonatomic,copy) NSString *item_name;
@property(nonatomic,copy) NSString *item_urlStr;
@property(nonatomic,copy)NSString *price;
@property(nonatomic,copy)NSString *stand_price;
@property(nonatomic,assign) int  order_num;
@property(nonatomic,copy) NSString *desc;// 服务描述
@property(nonatomic,assign) int parent_id;
@property(nonatomic,assign) int input_date;
@property(nonatomic,assign) int update_date;



+ (instancetype)itemViewModelWithDict:(NSDictionary *)dict andServiceCount:(NSUInteger)serviceCount;
@end
