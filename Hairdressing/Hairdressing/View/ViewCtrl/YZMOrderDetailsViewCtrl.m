//
//  YZMOrderListViewCtrl.m
//  Hairdressing
//
//  Created by yzm on 16/4/14.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "YZMOrderDetailsViewCtrl.h"
#import "YZMOrderTableViewCell.h"
#import "YZMOrderListHeaderView.h"
#import <Masonry/Masonry.h>

#import "YZMOrderDetailsHeaderView.h"
#import "YZMOrderDetailsViewModel.h"
#import "MRCViewModel.h"
#import "YZMOrderDetailsModel.h"
#import "NSDate+Helper.h"
#import "YZMPayTypeSelectView.h"
#import "YZMAppraiseViewModel.h"
/*
 这个地方显示的信息应该是：
 支付方式
 支付交易号
 下单时间
 支付时间
 （申请退款时间、取消退款时间、退款成功时间、拒绝退款时间）
 消费时间
 */


@interface YZMOrderDetailsViewCtrl ()

@property (nonatomic, strong) YZMOrderDetailsViewModel *viewModel;
@property (nonatomic, strong)  YZMOrderDetailsModel *model;

@property (weak, nonatomic) IBOutlet UIView *alertContainerView;            // 提示信息
@property (weak, nonatomic) IBOutlet UILabel *alertLabel;
@property (weak, nonatomic) IBOutlet UIView *authcodeContainerView;
@property (weak, nonatomic) IBOutlet UILabel *authcodeLabel;                // 验证码
@property (weak, nonatomic) IBOutlet UIView *favourableContainerView;       // 优惠信息
@property (weak, nonatomic) IBOutlet UILabel *favourableTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *favourablePriceLabel;
@property (weak, nonatomic) IBOutlet UIView *paywayContainerView;           //  支付方式
@property (weak, nonatomic) IBOutlet UILabel *paywayLabel;
@property (weak, nonatomic) IBOutlet UIView *payTSNContainerView;          // 支付交易号
@property (weak, nonatomic) IBOutlet UILabel *payTSNLabel;
@property (weak, nonatomic) IBOutlet UIView *createTimeContainerView;           // 下单时间
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *payTimeContainerView;              // 支付时间
@property (weak, nonatomic) IBOutlet UILabel *payTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *applyBackTimeContainerView;        // 申请退款时间
@property (weak, nonatomic) IBOutlet UILabel *applyBackTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *cancleBackTimeContainerView;       // 取消退款时间
@property (weak, nonatomic) IBOutlet UILabel *cancleBackTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *backDoneTimeContainerView;         // 退款成功时间
@property (weak, nonatomic) IBOutlet UILabel *backDoneTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *rejectBackTimeContainerView;       // 拒绝退款时间
@property (weak, nonatomic) IBOutlet UILabel *rejectBackTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *useTimeContainerView;              // 使用时间
@property (weak, nonatomic) IBOutlet UILabel *useTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *orderNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitPriceLabel;                   // 单价

@property (weak, nonatomic) IBOutlet UIButton *shopAddressButton;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *settlePriceLabel;


@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UIButton *rightFirstButton;
@property (weak, nonatomic) IBOutlet UIButton *rightSecondButton;

@property (strong, nonatomic) YZMPayTypeSelectView *payTypeSelView;

@end

@implementation YZMOrderDetailsViewCtrl

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    @weakify(self)
    self.rightFirstButton.layer.cornerRadius = 3;
    self.rightFirstButton.layer.borderWidth = 1;
    self.rightFirstButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.rightFirstButton.layer.masksToBounds = YES;
    
    self.rightSecondButton.layer.cornerRadius = 3;
    self.rightSecondButton.layer.borderWidth = 1;
    self.rightSecondButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.rightSecondButton.layer.masksToBounds = YES;
    
    [[RACObserve(self, model) filter:^BOOL(id value) {
        return value;
    }] subscribeNext:^(YZMOrderDetailsModel *model) {
        @strongify(self)
//        self.createTimeLabel.text = [NSString stringWithFormat:@"%@",model.create_time];
        self.alertLabel.text = [NSString stringWithFormat:@"%@",model.remark];
        self.authcodeLabel.text = [NSString stringWithFormat:@"%@", model.order_check_no];
        self.favourablePriceLabel.text = [NSString stringWithFormat:@"- %@", model.discount_price];
        self.paywayLabel.text = [NSString stringWithFormat:@"%@", [YZMOrderModel stringfromPayTypeEnum:model.pay_type]];
        self.payTSNLabel.text = [NSString stringWithFormat:@"%@", model.transaction_id];
        self.orderNoLabel.text = [NSString stringWithFormat:@"订单号 %@", model.orderno];
        self.statusNoLabel.text = [NSString stringWithFormat:@"%@", [YZMOrderModel stringfromStatusEnum:model.status]];
        self.itemNameLabel.text = [NSString stringWithFormat:@"%@", model.item_name];
        self.itemPriceLabel.text = [NSString stringWithFormat:@"￥%@", model.total_price];
        self.unitPriceLabel.text = [NSString stringWithFormat:@"￥%@", model.total_price];
        [self.shopAddressButton setTitle:model.address forState:UIControlStateNormal];
        self.shopNameLabel.text = [NSString stringWithFormat:@"%@", model.corporation];
        self.settlePriceLabel.text = [NSString stringWithFormat:@"￥%@", model.settle_price];
        
        
        self.createTimeLabel.text = [NSString stringWithFormat:@"%@", [NSDate stringWithTimeInterval:model.create_time]];
        self.payTimeLabel.text = [NSString stringWithFormat:@"%@", [NSDate stringWithTimeInterval:model.pay_time]];
        self.applyBackTimeLabel.text = [NSString stringWithFormat:@"%@", [NSDate stringWithTimeInterval:model.apply_back_time]];
        self.cancleBackTimeLabel.text = [NSString stringWithFormat:@"%@", [NSDate stringWithTimeInterval:model.cancel_back_time]];
        self.backDoneTimeLabel.text = [NSString stringWithFormat:@"%@", [NSDate stringWithTimeInterval:model.back_success_time]];
        self.rejectBackTimeLabel.text = [NSString stringWithFormat:@"%@", [NSDate stringWithTimeInterval:model.refuse_back_time]];
        self.useTimeLabel.text = [NSString stringWithFormat:@"%@", [NSDate stringWithTimeInterval:model.consume_time]];
        self.backDoneTimeLabel.text = [NSString stringWithFormat:@"%@", [NSDate stringWithTimeInterval:model.back_success_time]];
        
        [BitmapUtils setImageWithImageView:_iconImageView URLString:model.item_url];
        
        self.alertContainerView.hidden = YES;
        self.authcodeContainerView.hidden = YES;
        self.paywayContainerView.hidden = YES;
        self.payTSNContainerView.hidden = YES;
        self.favourableContainerView.hidden = YES;
        self.payTimeContainerView.hidden = YES;
        self.applyBackTimeContainerView.hidden = YES;
        self.backDoneTimeContainerView.hidden = YES;
        self.rejectBackTimeContainerView.hidden = YES;
        self.useTimeContainerView.hidden = YES;
//        self.createTimeContainerView.hidden = YES;
        self.cancleBackTimeContainerView.hidden = YES;
        
        self.favourableContainerView.hidden = !model.first_order;
        
        switch (model.status) {
            case YZMOrderModelStatusUnpaid:
                
                break;
            case YZMOrderModelStatusPaid:
                self.authcodeContainerView.hidden = NO;
                self.paywayContainerView.hidden = NO;
                self.payTSNContainerView.hidden = NO;
                self.payTimeContainerView.hidden = NO;
                
                break;
            case YZMOrderModelStatusEvaluate:
                self.authcodeContainerView.hidden = NO;
                self.paywayContainerView.hidden = NO;
                self.payTSNContainerView.hidden = NO;
                self.payTimeContainerView.hidden = NO;
                
                self.useTimeContainerView.hidden = NO;
                
                break;
            case YZMOrderModelStatusApplyRefund:
                self.authcodeContainerView.hidden = NO;
                self.paywayContainerView.hidden = NO;
                self.payTSNContainerView.hidden = NO;
                self.payTimeContainerView.hidden = NO;
                
                self.applyBackTimeContainerView.hidden = NO;

                
                
                break;
            case YZMOrderModelStatusRefusedRefund:
                self.authcodeContainerView.hidden = NO;
                self.paywayContainerView.hidden = NO;
                self.payTSNContainerView.hidden = NO;
                self.payTimeContainerView.hidden = NO;
                
                self.applyBackTimeContainerView.hidden = NO;
                
                self.rejectBackTimeContainerView.hidden = NO;
                
                self.alertContainerView.hidden = NO;
                break;
            case YZMOrderModelStatusRefunding:
                self.authcodeContainerView.hidden = NO;
                self.paywayContainerView.hidden = NO;
                self.payTSNContainerView.hidden = NO;
                self.payTimeContainerView.hidden = NO;
                
                self.applyBackTimeContainerView.hidden = NO;
                
                self.backDoneTimeContainerView.hidden = NO;
                break;
            case YZMOrderModelStatusRefunded:
                self.authcodeContainerView.hidden = NO;
                self.paywayContainerView.hidden = NO;
                self.payTSNContainerView.hidden = NO;
                self.payTimeContainerView.hidden = NO;
                
                self.applyBackTimeContainerView.hidden = NO;
                
                self.backDoneTimeContainerView.hidden = NO;

                break;
            case YZMOrderModelStatusEvaluated:
                
                self.authcodeContainerView.hidden = NO;
                self.paywayContainerView.hidden = NO;
                self.payTSNContainerView.hidden = NO;
                self.payTimeContainerView.hidden = NO;
                
                self.useTimeContainerView.hidden = NO;
                
                
                break;
                
            default:
                break;
        }
        
        switch (model.status) {
            case YZMOrderModelStatusUnpaid:{// 未付款
  
                
                self.rightFirstButton.hidden = NO;
                [self.rightFirstButton setTitle:@"立即付款" forState:UIControlStateNormal];
                
                self.rightFirstButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
                    @strongify(self)
                    // 立即付款
                    self.payTypeSelView.confirmButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
                        
                        @strongify(self)
                        [self.viewModel.payOrderCommand execute:model.order_id];
                        [self.payTypeSelView hideView];
                        
                        return [RACSignal empty];
                    }];
                    self.payTypeSelView.orderId = model.order_id;
                    self.payTypeSelView.price = model.settle_price;
                    
                    [self.payTypeSelView showInView:[UIApplication sharedApplication].keyWindow];
                    return [RACSignal empty];
                }];
                
                self.rightSecondButton.hidden = NO;
                [self.rightSecondButton setTitle:@"取消订单" forState:UIControlStateNormal];
                self.rightSecondButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
                    // 取消订单
                    self.viewModel.editStatus = YZMOrderEditStatusCancleOrder;
                    [self.viewModel.editOrderCommand execute:model.order_id];
                    
                    return [RACSignal empty];
                }];
            }
                break;
                
            case YZMOrderModelStatusPaid: {// 待消费
                self.rightFirstButton.hidden = NO;
                [self.rightFirstButton setTitle:@"联系客服" forState:UIControlStateNormal];
                self.rightFirstButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
                    
                    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",model.hotline];
                    UIWebView * callWebview = [[UIWebView alloc] init];
                    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                    [self.view addSubview:callWebview];
                    
                    
                    return [RACSignal empty];
                }];
                
                self.rightSecondButton.hidden = NO;
                [self.rightSecondButton setTitle:@"申请退款" forState:UIControlStateNormal];
                self.rightSecondButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
                    
                    self.viewModel.editStatus = YZMOrderEditStatusApplyBack;
                    [self.viewModel.editOrderCommand execute:model.order_id];
//
                    return [RACSignal empty];
                }];
                
                break;
            }
            case YZMOrderModelStatusRefusedRefund: {// 待消费
                self.rightFirstButton.hidden = NO;
                [self.rightFirstButton setTitle:@"联系客服" forState:UIControlStateNormal];
                self.rightFirstButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
                    
                    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",model.hotline];
                    UIWebView * callWebview = [[UIWebView alloc] init];
                    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                    [self.view addSubview:callWebview];
                    
                    return [RACSignal empty];
                }];
                
                self.rightSecondButton.hidden = NO;
                [self.rightSecondButton setTitle:@"申请退款" forState:UIControlStateNormal];
                self.rightSecondButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
                    
                    self.viewModel.editStatus = YZMOrderEditStatusApplyBack;
                    [self.viewModel.editOrderCommand execute:model.order_id];
                    
                    return [RACSignal empty];
                }];
                
                break;
            }
                
            case YZMOrderModelStatusEvaluate:{// 待评价
                self.rightFirstButton.hidden = NO;
                [self.rightFirstButton setTitle:@"去评价" forState:UIControlStateNormal];
                self.rightFirstButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
                    YZMAppraiseViewModel *appraiseViewModel = [[YZMAppraiseViewModel alloc] initWithServices:self.viewModel.services params:@{@"order_id":model.order_id}];
                    [self.viewModel.services pushViewModel:appraiseViewModel animated:YES];
                    return [RACSignal empty];
                }];
                
                self.rightSecondButton.hidden = YES;
                
                break;
            }
                
            case YZMOrderModelStatusRefunding:{// 退款中
                self.rightFirstButton.hidden = NO;
                [self.rightFirstButton setTitle:@"取消退款" forState:UIControlStateNormal];
                self.rightFirstButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
                    
                    self.viewModel.editStatus = YZMOrderEditStatusCancleBack;
                    [self.viewModel.editOrderCommand execute:model.order_id];
//
                    return [RACSignal empty];
                }];
                
                self.rightSecondButton.hidden = YES;
                
                break;
            }
            default:
                
                self.rightFirstButton.hidden = YES;
                self.rightSecondButton.hidden = YES;
                
                break;
        }
    }];
    
    [[[self.viewModel.services.orderService getOrderInfoWithOrderNo:self.viewModel.orderNo] map:^id(id value) {
        
        YZMOrderDetailsModel *model = [YZMOrderDetailsModel mj_objectWithKeyValues:value[@"data"]];
        
        return model;
        
    }] subscribeNext:^(YZMOrderDetailsModel *model) {
        
        self.model = model;
    }];
    
    RAC(self.viewModel,payType) = RACObserve(self.payTypeSelView, payType);

}

- (YZMPayTypeSelectView *)payTypeSelView
{
    if (_payTypeSelView == nil)
    {
        _payTypeSelView = [YZMPayTypeSelectView instance];
        
    }
    return _payTypeSelView;
}


@end
