//
//  YZMCommendCorpCollectionViewCell.m
//  Hairdressing
//
//  Created by Yangjiaolong on 16/5/27.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "YZMCommendCorpCollectionViewCell.h"
#import "BitmapUtils.h"

@interface YZMCommendCorpCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation YZMCommendCorpCollectionViewCell

-(void)updateUIWithModel:(YZMCorpsModel *)model{
    [BitmapUtils setImageWithImageView:self.imageView URLString:model.env];
    self.nameLabel.text = model.corporation;
}
@end
