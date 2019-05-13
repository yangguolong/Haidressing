//
//  YZMSimpleImageViewCollectionViewCell.m
//  Hairdressing
//
//  Created by yzm on 5/9/16.
//  Copyright © 2016 Yangjiaolong. All rights reserved.
//

#import "YZMSimpleImageViewCollectionViewCell.h"


@interface YZMSimpleImageViewCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@end

@implementation YZMSimpleImageViewCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setImage_url:(NSString *)image_url
{
    _image_url = image_url;
    [BitmapUtils setImageWithImageView:self.imageView URLString:_image_url];
    
}

@end
