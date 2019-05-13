//
//  ServiceCell.m
//  Hairdressing
//
//  Created by Guolong Yang on 16/4/8.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "ServiceCell.h"
#import "ServiceCategories.h"
#import "Masonry.h"
@implementation ServiceCell

//- (void)awakeFromNib {
//
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)bindViewModel:(ServiceCategories*)viewModel
{
    
//    self.serviceCountLab.text =[NSString stringWithFormat:@"%lu",(unsigned long)viewModel.serviceCount];
    if (![viewModel.price isKindOfClass:[NSNull class]])
        self.servicePrice.text =[NSString stringWithFormat:@"¥%@",viewModel.price];
    if (![viewModel.item_name isKindOfClass:[NSNull class]])
        self.serviceType.text = viewModel.item_name;
    if (![viewModel.item_urlStr isKindOfClass:[NSNull class]])
        [self.serviceImageView sd_setImageWithURL:[NSURL URLWithString:viewModel.item_urlStr] placeholderImage:[UIImage imageNamed:@"list_butik_det_tang"]];
}
//-(void)addItem{
//    CGFloat constantY = self.constraint.constant;
//    self.constraint.constant = constantY+20;
//    CGRect rect = self.detailView.frame;
//  //  CGFloat y = rect.origin.y+30;
////    CGRect newRect = CGRectMake(rect.origin.x, y, rect.size.width, rect.size.height) ;
////    [self.detailView setFrame:newRect];
//    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10,20, 120, 20)];
//    label.text = @"服务项目";
//    label.textColor = [UIColor grayColor];
//    [label setFont:[UIFont systemFontOfSize:13.0f]];
//    [self addSubview:label];
//    [self layoutIfNeeded];
//}

//-(void)buyerCountHidden:(BOOL)hidden{
//    
//    self.serviceCountLab.hidden = hidden;
//    self.serviceItemLab.hidden  = hidden;
//}

@end
