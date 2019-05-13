//
//  YZMConfirmOrderViewModel.h
//  Hairdressing
//
//  Created by Yangjiaolong on 16/5/10.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "MRCTableViewModel.h"
#import "YZMCouponsModel.h"

typedef NS_ENUM(NSInteger,PayType){
    ZHIFUBAO = 1,
    WECHAT = 2,
};

@interface YZMConfirmOrderViewModel : MRCTableViewModel

@property (nonatomic,strong) RACCommand * payButtonConmmand;

@property (nonatomic,strong) RACCommand * payResultCommand;

@property (nonatomic,copy) NSString * num;

@property (nonatomic,assign) int paytype;

@property (nonatomic,copy) NSString * disCountPrice;

@property (nonatomic,strong) UIImage * itemIconImage;

@property (nonatomic,strong) NSString * unitPrice;

@property (nonatomic,strong) YZMCouponsModel * couponsModel;

@end