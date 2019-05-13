//
//  AllCommentCell.m
//  Hairdressing
//
//  Created by BoDong on 16/4/21.
//  Copyright © 2016年 Cloudream. All rights reserved.
//

#import "AllCommentCell.h"
#import "YZMCommentViewModel.h"
@implementation AllCommentCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)bindViewModel:(YZMCommentViewModel*)viewModel{
    self.commentLab.text = viewModel.commentContent;
    self.nameLab.text = viewModel.userName;
    self.dateLab.text = viewModel.commentTimeStamp;

}

@end
