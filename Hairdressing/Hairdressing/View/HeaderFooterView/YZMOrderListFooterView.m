//
//  cloudcrack
//
//  Created by ygl on 15-1-11.
//  Copyright (c) 2015年 goking. All rights reserved.
//

#import "YZMOrderListFooterView.h"

@implementation YZMOrderListFooterView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.rightFirstButton.layer.cornerRadius = 3;
    self.rightFirstButton.layer.borderWidth = 1;
    self.rightFirstButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.rightFirstButton.layer.masksToBounds = YES;
    
    self.rightSecondButton.layer.cornerRadius = 3;
    self.rightSecondButton.layer.borderWidth = 1;
    self.rightSecondButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.rightSecondButton.layer.masksToBounds = YES;

}

+ (CGFloat)footerHeight
{
    return 50;
}

+ (instancetype)instance
{
    YZMOrderListFooterView * view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    return view;
}

- (void)bindViewModel:(id)viewModel
{
    
}

@end
