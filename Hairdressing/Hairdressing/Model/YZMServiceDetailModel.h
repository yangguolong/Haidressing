//
//  YZMServiceDetailModel.h
//  Hairdressing
//
//  Created by Yangjiaolong on 16/5/23.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZMServiceDetailModel : NSObject
@property (nonatomic,copy) NSString * corp_id;
@property (nonatomic,copy) NSString * serviceDetail;
@property (nonatomic,copy) NSString * input_date;
@property (nonatomic,copy) NSString * item_id;
@property (nonatomic,copy) NSString * item_name;
@property (nonatomic,copy) NSString * item_url;
@property (nonatomic,copy) NSString * order_num;
@property (nonatomic,copy) NSString * parent_id;
@property (nonatomic,copy) NSString * price;
@property (nonatomic,copy) NSString * stand_price;
@property (nonatomic,copy) NSString * status;
@property (nonatomic,copy) NSArray  * supply;
@property (nonatomic,copy) NSString * update_date;
@property (nonatomic,copy) NSString * item_icon;

@end
