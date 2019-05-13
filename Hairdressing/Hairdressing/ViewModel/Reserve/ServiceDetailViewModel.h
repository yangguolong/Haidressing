//
//  ServiceDetailViewModel.h
//  Hairdressing
//
//  Created by Guolong Yang on 16/4/15.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceDetailViewModel : MRCViewModel

@property(nonatomic,strong,readonly)NSNumber *serviceID;
@property(nonatomic,strong,readonly)NSString *imagePathStr;
@property(nonatomic,assign,readonly)NSString * price;
@property(nonatomic,copy,readonly)NSString * serviceName;
@property(nonatomic,copy,readonly)NSString * serviceDetail;
@property(nonatomic,copy) NSArray * supplys;
@property(nonatomic,copy)NSAttributedString * standPrice;
@property(nonatomic,strong)RACCommand *confirmOrderCommand;

@end
