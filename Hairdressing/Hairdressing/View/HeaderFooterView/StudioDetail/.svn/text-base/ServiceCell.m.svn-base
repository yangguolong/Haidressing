//
//  ServiceCell.m
//  Hairdressing
//
//  Created by BoDong on 16/4/8.
//  Copyright © 2016年 Cloudream. All rights reserved.
//

#import "ServiceCell.h"

@implementation ServiceCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(ServiceCell*)cellWithTableView:(UITableView*)tableView labHidden:(BOOL)hidden{
    static NSString *identifier = @"ServiceCell";
    ServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ServiceCell" owner:self options:nil] lastObject];
        cell.serviceCountLab.hidden = hidden;
        cell.serviceItemLab.hidden = hidden;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

@end
