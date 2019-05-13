//
//  YZMSupplyCollectionViewCell.m
//  Hairdressing
//
//  Created by Yangjiaolong on 16/5/27.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "YZMSupplyCollectionViewCell.h"
#import "BitmapUtils.h"


@interface YZMSupplyCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation YZMSupplyCollectionViewCell

-(void)updateWithSupplyModel:(YZMSupplyModel *)sModel{
    [BitmapUtils setImageWithImageView:self.imageView URLString:sModel.supply_icon];
    self.nameLabel.text = sModel.supply_name;
}

@end
