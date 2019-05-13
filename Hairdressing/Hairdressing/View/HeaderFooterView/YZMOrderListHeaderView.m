//
//  cloudcrack
//
//  Created by ygl on 15-1-11.
//  Copyright (c) 2015年 goking. All rights reserved.
//

#import "YZMOrderListHeaderView.h"

@implementation YZMOrderListHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.contentView.backgroundColor = [UIColor whiteColor];

}

+ (CGFloat)headerHeight
{
    return 50;

}

+ (instancetype)instance
{
    YZMOrderListHeaderView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    return view;
}
@end
