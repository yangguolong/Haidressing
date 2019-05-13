//
//  YZMPayTypeSelectView.h
//  Hairdressing
//
//  Created by yzm on 16/5/26.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRCReactiveView.h"

@interface YZMPayTypeSelectView : UIView <MRCReactiveView>

 @property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@property (nonatomic, copy) NSString *orderId;
@property (nonatomic ,copy) NSString *price;

@property (assign, nonatomic) YZMOrderPayType payType;

+ (instancetype)instance;

- (void)showInView:(UIView *)superView;

- (void)hideView;

@end
