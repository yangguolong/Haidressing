//
//  AllCommentCell.m
//  Hairdressing
//
//  Created by Guolong Yang on 16/4/21.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "AllCommentCell.h"
#import "StudioComment.h"
@implementation AllCommentCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)bindViewModel:(StudioComment*)viewModel{
    if (![viewModel.remark isKindOfClass:[NSNull class]])
        self.commentLab.text = viewModel.remark;
    if (![viewModel.nickName isKindOfClass:[NSNull class]])
        self.nameLab.text = viewModel.nickName;
    self.dateLab.text = [Utility getDateByTimestamp:viewModel.creat_time type:4];
    //image_1.png
   // self.headImageView.image =
    if (![viewModel.headImgURLStr isKindOfClass:[NSNull class]]) {
            [self.headImageView sd_setImageWithURL:[NSURL URLWithString:viewModel.headImgURLStr] placeholderImage:[UIImage imageNamed:@"tab_my_s"] ];
    }

}

+ (CGFloat)heightOfCellWithModel:(StudioComment*)viewModel
{
    CGFloat height = 64;
    NSMutableAttributedString *attrStr;
    if (viewModel.remark==nil) {
        attrStr =[[NSMutableAttributedString alloc]initWithString:@" "];
    }
    else
        attrStr =[[NSMutableAttributedString alloc]initWithString:viewModel.remark];
    CGSize maxSize = CGSizeMake(kWidth-20, MAXFLOAT);
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0] range:NSMakeRange(0, attrStr.length)];
    CGSize attrStrSize = [attrStr boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    height += attrStrSize.height+8;
    //    if (height < 90) {
    //        height = 90;
    //    }
    return height ;
}

@end