//
//  YZMHairCategoryCollectionViewCell.m
//  Hairdressing
//
//  Created by 杨国龙 on 16/3/7.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "YZMHairCategoryCollectionViewCell.h"
#import "MRCConstant.h"

@interface YZMHairCategoryCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation YZMHairCategoryCollectionViewCell

+ (NSString *)indentifier
{
    return @"YZMHairCategoryCollectionViewCell";
}

- (void)awakeFromNib {
    
    self.layer.borderColor =  RGB(145, 128, 72).CGColor;
    self.layer.borderWidth = 1;
    
}

@end
