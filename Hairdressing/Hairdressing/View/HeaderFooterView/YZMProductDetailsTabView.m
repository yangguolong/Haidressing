//
//  YZMProductDetailsTabView.m
//  Hairdressing
//
//  Created by 杨国龙 on 16/3/15.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "YZMProductDetailsTabView.h"
#import "ReactiveCocoa.h"

@interface YZMProductDetailsTabView ()

@property (weak, nonatomic) IBOutlet UIView *serviceDetailsView;
@property (weak, nonatomic) IBOutlet UIView *shopInfoView;
@property (weak, nonatomic) IBOutlet UIView *commentView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *indicatorMarginLeft;

@end

@implementation YZMProductDetailsTabView

- (void)awakeFromNib
{
    // 添加点击事件
    UIButton *btn = [[UIButton alloc] init];
    [btn rac_signalForControlEvents:UIControlEventTouchUpInside];
    
    [self.serviceDetailsView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClick:)]];
    [self.shopInfoView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClick:)]];
    [self.commentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClick:)]];
    
    
}

- (void)onClick:(UIGestureRecognizer *)gr
{
    if (gr.view == self.serviceDetailsView) {
        self.state = YZMProductDetailsTabViewSelectStateServiceDetail;
        self.indicatorMarginLeft.constant = 0;
    } else if (gr.view == self.shopInfoView) {
        self.state = YZMProductDetailsTabViewSelectStateShopInfo;
        self.indicatorMarginLeft.constant = self.frame.size.width / 3;
    } else if (gr.view == self.commentView) {
        self.state = YZMProductDetailsTabViewSelectStateComment;
        self.indicatorMarginLeft.constant = self.frame.size.width / 3 * 2;
    }
    
}

+ (CGFloat)viewHeight
{
    return 95;
}

@end
