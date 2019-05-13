//
//  CommentCell.m
//  Hairdressing
//
//  Created by BoDong on 16/4/8.
//  Copyright © 2016年 Cloudream. All rights reserved.
//

#import "CommentCell.h"

@interface CommentCell ()

@end

@implementation CommentCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CommentCell*)cellWithTableView:(UITableView*)tableView{
    static NSString *identifier = @"CommentCell";
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CommentCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)setComment:(int *)comment
{
    
}

@end
