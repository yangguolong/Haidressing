//
//  YZMCommentTableViewCell.m
//  Hairdressing
//
//  Created by yzm on 16/3/25.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "YZMCommentTableViewCell.h"

@implementation YZMCommentTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)cellHeight
{
    return 166;
}

+ (NSString *)indentifier
{
    return NSStringFromClass([self class]);
}

@end