//
//  AliPayDemoViewController.m
//  Hairdressing
//
//  Created by Guolong Yang on 16/5/10.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "AliPayDemoViewController.h"
#import "AliPayDemoViewModel.h"

//#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
@interface AliPayDemoViewController ()
@property (weak, nonatomic) IBOutlet UIButton *aliPayButton;

@property (weak, nonatomic) IBOutlet UIButton *weChatPayButton;

@property(nonatomic,strong)AliPayDemoViewModel *viewModel;
@end

@implementation AliPayDemoViewController
@dynamic viewModel;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付宝支付订单";
    // Do any additional setup after loading the view from its nib.
}

-(void)bindViewModel{
    [[self.aliPayButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self.viewModel.payCommand execute:@1];
    }];
    [[self.weChatPayButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self.viewModel.payCommand execute:@2];
    }];
    
}




@end
