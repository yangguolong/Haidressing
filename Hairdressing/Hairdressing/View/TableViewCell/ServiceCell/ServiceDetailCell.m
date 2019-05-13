//
//  ServiceDetailCell.m
//  Hairdressing
//
//  Created by Guolong Yang on 16/4/18.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "ServiceDetailCell.h"
#import "ServiceCategories.h"
@implementation ServiceDetailCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)bindViewModel:(ServiceCategories*)viewModel
{
    //    NSLog(@"service cell bind view model");
    self.serviceDetailLab.text =[NSString stringWithFormat:@"%@",viewModel.desc];
    //计算高度，然后返回给主tableview。
}


+ (CGFloat)heightOfCell:(ServiceCategories*)viewModel
{
    CGFloat height = 44;
//    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:self.serviceDetailLab.text];
//    CGSize maxSize = CGSizeMake(kWidth-10, MAXFLOAT);
//    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0] range:NSMakeRange(0, attrStr.length)];
//    CGSize attrStrSize = [attrStr boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
//    height += attrStrSize.height+10;
//    if (height < 90) {
//        height = 90;
//    }
    return height ;
}

@end
