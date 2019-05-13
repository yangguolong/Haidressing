//
//  YZMShopModel.h
//  Hairdressing
//
//  Created by yzm on 5/13/16.
//  Copyright © 2016 Yangjiaolong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZMShopModel : NSObject

@property (nonatomic ,copy) NSString *corp_id;              // 门店序号
@property (nonatomic ,copy) NSString *corporation;          // 门店名称
@property (nonatomic ,copy) NSString *distance;             // 距离
@property (nonatomic ,copy) NSString *commercial_area;        // 发型师所在商圈
@property (nonatomic ,copy) NSString *env_img;              //  环境图
@property (nonatomic ,copy) NSString *fares_start;          // 起步价
@property (nonatomic ,copy) NSString *signature;            // 小编寄语
@property (nonatomic ,strong) NSArray *corp_label;          // 门店标签


@end