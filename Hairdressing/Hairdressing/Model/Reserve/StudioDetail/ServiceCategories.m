//
//  ServiceCategories.m
//  Hairdressing
//
//  Created by Guolong Yang on 16/4/6.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "ServiceCategories.h"

@implementation ServiceCategories

+ (instancetype)itemViewModelWithDict:(NSDictionary *)dict andServiceCount:(NSUInteger)serviceCount
{
    ServiceCategories *model = [[ServiceCategories alloc] init];
    model.serviceCount = serviceCount;
    model.desc = dict[@"description"] ;
    model.itemId = [dict[@"item_id"]intValue];
    model.item_name = dict[@"item_name"];
    model.item_urlStr = dict[@"item_icon"];
    model.order_num = [dict[@"order_num"] intValue];
    model.price = dict[@"price"] ;
    model.stand_price = dict[@"stand_price"];
    return model;
}

@end
