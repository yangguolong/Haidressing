//
//  YZMOrderTableViewCell.m
//  Hairdressing
//
//  Created by yzm on 16/4/14.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "YZMOrderTableViewCell.h"
#import "YZMOrderModel.h"

@interface YZMOrderTableViewCell ()

@property (nonatomic, strong) YZMOrderModel *viewModel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation YZMOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)bindViewModel:(YZMOrderModel *)viewModel
{
    _viewModel = viewModel;
    
    [BitmapUtils setImageWithImageView:_iconImageView URLString:viewModel.item_url];
    _nameLabel.text = [NSString stringWithFormat:@"%@", viewModel.item_name];
    _priceLabel.text = [NSString stringWithFormat:@"￥%@",viewModel.total_price];
}

+ (CGFloat)cellHeight
{
    return 84;
}

+ (NSString *)indentifier
{
    return @"YZMOrderTableViewCell";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
