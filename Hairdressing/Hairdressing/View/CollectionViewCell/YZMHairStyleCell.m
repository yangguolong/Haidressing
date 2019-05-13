//
//  YZMHairStyleCell.m
//  Hairdressing
//
//  Created by Yangjiaolong on 16/5/21.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "YZMHairStyleCell.h"
#import "YZMHairStyleModel.h"
#import "BitmapUtils.h"

@interface YZMHairStyleCell ()


@property (weak, nonatomic) IBOutlet UIImageView *imageVIew;

@end

@implementation YZMHairStyleCell

-(void)configWithModel:(YZMHairStyleModel *)model{
    [BitmapUtils setImageWithImageView:self.imageVIew URLString:model.filename_2d];
}

@end
