//
//  YZMHairstyleCollectionViewCell.m
//  Hairdressing
//
//  Created by 杨国龙 on 16/3/4.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "YZMHairstyleCollectionViewCell.h"

@interface YZMHairstyleCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;


@end

@implementation YZMHairstyleCollectionViewCell

+ (NSString *)indentifier
{
    return @"YZMHairstyleCollectionViewCell";
}

- (void)awakeFromNib {
    // Initialization code
}

@end
