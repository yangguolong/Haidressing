//
//  OrderDetailCell.m
//  Hairdressing
//
//  Created by Guolong Yang on 16/5/24.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "OrderDetailCell.h"
#import "AllOrderInfoViewModel.h"
@implementation OrderDetailCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)bindViewModel:(AllOrderInfoViewModel*)viewModel{
    if (viewModel==nil) {
        return;
    }
    if (viewModel.unPayedCount==0) {
        self.waitPayCountLab.hidden = YES;
    }
    if (viewModel.unCommentCount==0) {
        self.waitReviewCountLab.hidden = YES;
    }
    if (viewModel.payedCount==0) {
        self.waitConsumeCountLab.hidden = YES;
    }
    self.waitPayCountLab.text = [NSString stringWithFormat:@"%d",viewModel.unPayedCount];
    self.waitConsumeCountLab.text =[NSString stringWithFormat:@"%d",viewModel.payedCount];
    self.waitReviewCountLab.text =[NSString stringWithFormat:@"%d",viewModel.unCommentCount];

}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    
    static NSString *cellID = @"OrderDetailCell";
    OrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"OrderDetailCell" owner:self options:nil]firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    //将模型的值传递给cell
    
    return cell;
}

@end
