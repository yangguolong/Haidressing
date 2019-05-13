//
//  DesignerDetailCell.m
//  Hairdressing
//
//  Created by BoDong on 16/4/8.
//  Copyright © 2016年 Cloudream. All rights reserved.
//

#import "StudioDetailCell.h"

@implementation StudioDetailCell

- (void)awakeFromNib {
    // Initialization code
}

//- (void)bindViewModel:(id)viewModel
//{
//    
//    
//    
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(StudioDetailCell*)cellWithTableView:(UITableView*)tableView{
    static NSString *identifier = @"StudioTableViewCell";
    StudioDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"StudioDetailCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

@end
