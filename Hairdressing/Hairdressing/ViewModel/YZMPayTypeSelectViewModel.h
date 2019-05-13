//
//  YZMPayTypeSelectViewModel.h
//  Hairdressing
//
//  Created by yzm on 16/5/27.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZMPayTypeSelectViewModel : NSObject

@property (nonatomic, strong) RACCommand *confirmCommand;
@property (nonatomic, copy) NSString *price;

@property (nonatomic, copy) NSString *orderId;

- (instancetype)initWithPrice:(NSString *)price orderId:(NSString *)orderId;

@end
