//
//  YZMPayTypeSelectView.m
//  Hairdressing
//
//  Created by yzm on 16/5/26.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "YZMPayTypeSelectView.h"
#import "YZMOrderModel.h"
#import "YZMPayTypeSelectViewModel.h"

@interface YZMPayTypeSelectView ()

@property (weak, nonatomic) IBOutlet UIView *transparentView;
@property (weak, nonatomic) IBOutlet UIButton *wechatCheckBox;
@property (weak, nonatomic) IBOutlet UIButton *aliCheckBox;
@property (weak, nonatomic) IBOutlet UIView *wechatContainerView;
@property (weak, nonatomic) IBOutlet UIView *aliContainerView;



@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (nonatomic, strong) YZMPayTypeSelectViewModel *viewModel;
@end

@implementation YZMPayTypeSelectView



//- (void)bindViewModel:(YZMPayTypeSelectViewModel *)viewModel
//{
//    _viewModel = viewModel;
//    
//    
//}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView)];
    [_transparentView addGestureRecognizer:tapGR];
    
     UITapGestureRecognizer *wechatTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onViewClick:)];
    [_wechatContainerView addGestureRecognizer:wechatTapGR];
    
    UITapGestureRecognizer *aliTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onViewClick:)];
    [_aliContainerView addGestureRecognizer:aliTapGR];
    
    [self onViewClick:_wechatCheckBox];
}

+ (instancetype)instance
{
    YZMPayTypeSelectView * view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
    
    return view;
}


- (IBAction)onViewClick:(id)obj
{
    if ([obj isKindOfClass:[UITapGestureRecognizer class]]) {
        
        UITapGestureRecognizer *tgr = (UITapGestureRecognizer *)obj;
   
        if (tgr.view == _wechatContainerView) {
            
            self.payType = YZMOrderPayTypeWeChat;
        
        } else if (tgr.view == _aliContainerView){
            
            self.payType = YZMOrderPayTypeAli;

        }

        
    } else if ([obj isKindOfClass:[UIButton class]]) {
        
        if (obj == _wechatCheckBox) {
            
            self.payType = YZMOrderPayTypeWeChat;
            
        } else if (obj == _aliCheckBox){
            
            self.payType = YZMOrderPayTypeAli;
            
        }
    }
}

- (void)showInView:(UIView *)superView
{
    [superView addSubview:self];
    
    
}

- (void)hideView
{
    [self removeFromSuperview];
}

- (IBAction)hideButtonClick:(UIButton *)sender {
    
    [self hideView];
    
}

- (void)setPayType:(YZMOrderPayType)payType
{
    _payType = payType;
    if (payType == YZMOrderPayTypeAli) {
        _wechatCheckBox.selected = NO;
        _aliCheckBox.selected = YES;
    } else if (payType == YZMOrderPayTypeWeChat){
        _wechatCheckBox.selected = YES;
        _aliCheckBox.selected = NO;
    }
}

- (void)setPrice:(NSString *)price
{
    _price = price;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",price];
}

@end
