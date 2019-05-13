//
//  YZMPayTypeSelectViewModel.m
//  Hairdressing
//
//  Created by yzm on 16/5/27.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "YZMPayTypeSelectViewModel.h"

@implementation YZMPayTypeSelectViewModel


- (instancetype)initWithPrice:(NSString *)price orderId:(NSString *)orderId
{
    self = [super init];
    if (self) {
        self.price = price;
        self.orderId = orderId;
    }
    return self;
}
@end
