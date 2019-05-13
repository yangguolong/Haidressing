//
//  YZMHotHairStyleHeaderView.m
//  Hairdressing
//
//  Created by 杨国龙 on 16/3/7.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "YZMHotHairStyleHeaderView.h"

@interface YZMHotHairStyleHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end


@implementation YZMHotHairStyleHeaderView

- (void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

+ (NSString *)indentifier
{
    return @"YZMHotHairStyleHeaderView";
}

+ (CGFloat)height
{
    return 44;
}

- (void)awakeFromNib {
    // Initialization code
}

@end