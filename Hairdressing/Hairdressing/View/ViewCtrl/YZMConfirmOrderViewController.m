//
//  YZMConfirmOrderViewController.m
//  Hairdressing
//
//  Created by Yangjiaolong on 16/4/18.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "YZMConfirmOrderViewController.h"
#import "YZMConfirmOrderViewModel.h"



@interface YZMConfirmOrderViewController ()

@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *reduceButton;
@property (weak, nonatomic) IBOutlet UILabel *itemCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitPriceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *itemIconImageView;


@property (weak, nonatomic) IBOutlet UILabel *disCountLabel;
@property (weak, nonatomic) IBOutlet UIView *discountItemView;

@property (weak, nonatomic) IBOutlet UIButton *weChatpayButton;
@property (weak, nonatomic) IBOutlet UIButton *zhifubaopayButton;

@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *oldPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *disCountLabel2;
@property (weak, nonatomic) IBOutlet UILabel *realPriceLabel;

@property (nonatomic,strong,readonly) YZMConfirmOrderViewModel * viewModel;



@end

@implementation YZMConfirmOrderViewController
@dynamic viewModel;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.confirmButton.rac_command = self.viewModel.payButtonConmmand;
    
    [self configurefirstItem];
    [self configurePayItem];
    [self configureStatisticsItem];
    [self configureDisCountLabel];
    // Do any additional setup after loading the view.
}

-(void)configurePayItem{
    @weakify(self)
    [[RACSignal merge:@[[self.weChatpayButton rac_signalForControlEvents:UIControlEventTouchUpInside],[self.zhifubaopayButton rac_signalForControlEvents:UIControlEventTouchUpInside]]] subscribeNext:^(UIButton * bt) {
        @strongify(self)
        self.weChatpayButton.selected = NO;
        self.zhifubaopayButton.selected = NO;
        bt.selected = YES;
        self.viewModel.paytype = (bt == self.weChatpayButton ? 2 : 1);//2微信 1 支付宝
        
        
    }];
}
-(void)configurefirstItem{
    @weakify(self)
    RAC(self.unitPriceLabel,text) = [RACObserve(self.viewModel,unitPrice) map:^id(id value) {
        return [NSString stringWithFormat:@"￥%@",value];
        
    }];

    [[[RACSignal merge:@[[self.addButton rac_signalForControlEvents:UIControlEventTouchUpInside],[self.reduceButton rac_signalForControlEvents:UIControlEventTouchUpInside]]] filter:^BOOL(id value) {
        @strongify(self)
        return [self.itemCountLabel.text integerValue] >= 1;
    }] subscribeNext:^(UIButton * bt) {
        @strongify(self)
        NSInteger count = [self.itemCountLabel.text integerValue];
        if (bt == self.reduceButton) {
            count --;
            count = count > 1 ? count : 1;
        }else if (bt == self.addButton){
            count ++;
        }
        self.itemCountLabel.text = [NSString stringWithFormat:@"%zd",count];
        self.viewModel.num = [NSString stringWithFormat:@"%zd",count];
    }];
    
    RAC(self.viewModel,num) = [RACObserve(self.itemCountLabel, text) map:^id(id value) {
        @strongify(self)
        NSInteger num = [value integerValue];
        NSInteger price = [self.viewModel.unitPrice integerValue];
        NSInteger total = num * price;
        self.oldPriceLabel.text = [NSString stringWithFormat:@"￥%zd",total];
        NSInteger finalPrice = total;
        if ([self.viewModel.couponsModel.face_value integerValue]) {
            finalPrice -= [self.disCountLabel.text integerValue];
        }
        self.realPriceLabel.text = [NSString stringWithFormat:@"￥%zd",finalPrice];
        self.totalPriceLabel.text = [NSString stringWithFormat:@"￥%zd",finalPrice];
        return value;
    }];
    
      RAC(self.itemIconImageView,image) = RACObserve(self.viewModel, itemIconImage);
}
-(void)configureDisCountLabel{
    @weakify(self)

    [[RACObserve(self.viewModel, couponsModel) filter:^BOOL(id value) {
        return YES;
    }] subscribeNext:^(YZMCouponsModel * cModel) {
        @strongify(self)

        self.disCountLabel2.text = [NSString stringWithFormat:@"- %@",cModel.face_value? :@""];
        self.disCountLabel.text = [NSString stringWithFormat:@"- ￥%@",cModel.face_value];
        self.discountItemView.hidden = [cModel.face_value integerValue] <=0;
        self.disCountLabel2.hidden = self.discountItemView.hidden;

    }];
    
}
-(void)configureStatisticsItem{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end