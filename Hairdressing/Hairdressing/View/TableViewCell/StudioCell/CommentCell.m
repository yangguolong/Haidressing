//
//  CommentCell.m
//  Hairdressing
//
//  Created by Guolong Yang on 16/4/8.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "CommentCell.h"

@interface CommentCell ()

@end

@implementation CommentCell

//- (void)awakeFromNib {
//    // Initialization code
//}

- (void)bindViewModel:(StudioComment*)viewModel
{
    self.viewModel = viewModel;
    self.commentCountLab.text = [NSString stringWithFormat:@"%lu",(unsigned long)viewModel.commentCount];
    if (viewModel.commentCount!=0) {
        if (![viewModel.nickName isKindOfClass:[NSNull class]])
            self.commentUserLab.text = viewModel.nickName;
        if (![viewModel.remark isKindOfClass:[NSNull class]])
            self.commentLab.text = viewModel.remark;
        if (![viewModel.headImgURLStr isKindOfClass:[NSNull class]])
            [self.commentHeadView sd_setImageWithURL:[NSURL URLWithString:viewModel.headImgURLStr] placeholderImage:[UIImage imageNamed:@"tab_my_n"]];
        else
            self.commentHeadView.image = [UIImage imageNamed:@"tab_my_n"];
    }
    else
        self.commentHeadView.hidden = YES;

}


+ (CGFloat)heightOfCellWithModel:(StudioComment*)viewModel
{
    CGFloat height = 80;
    NSMutableAttributedString *attrStr;
    if (viewModel.remark==nil) {
        attrStr =[[NSMutableAttributedString alloc]initWithString:@" "];
    }
    else
        attrStr =[[NSMutableAttributedString alloc]initWithString:viewModel.remark];
    CGSize maxSize = CGSizeMake(kWidth-46, MAXFLOAT);
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0] range:NSMakeRange(0, attrStr.length)];
    CGSize attrStrSize = [attrStr boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    height += attrStrSize.height+8;
//    if (height < 90) {
//        height = 90;
//    }
    return height ;
}
//+ (CommentCell*)cellWithTableView:(UITableView*)tableView{
//    static NSString *identifier = @"CommentCell";
//    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    if (cell == nil) {
//        cell = [[[NSBundle mainBundle] loadNibNamed:@"CommentCell" owner:self options:nil] lastObject];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
//    return cell;
//}

- (void)setComment:(int *)comment
{
    
}

@end