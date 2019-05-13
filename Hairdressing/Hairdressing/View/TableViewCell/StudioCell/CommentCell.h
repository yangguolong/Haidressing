//
//  CommentCell.h
//  Hairdressing
//
//  Created by Guolong Yang on 16/4/8.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRCReactiveView.h"
#import "StudioComment.h"
@interface CommentCell : UITableViewCell <MRCReactiveView>

@property (weak, nonatomic) IBOutlet UILabel *commentCountLab;
@property (weak, nonatomic) IBOutlet UIImageView *commentHeadView;
@property (weak, nonatomic) IBOutlet UILabel *commentUserLab;
@property (weak, nonatomic) IBOutlet UILabel *commentLab;




@property (nonatomic, strong) StudioComment *viewModel;

//@property (weak, nonatomic) IBOutlet UILabel *commentCountLab;

//+(CommentCell*)cellWithTableView:(UITableView*)tableView;

+ (CGFloat)heightOfCellWithModel:(StudioComment*)viewModel;
@end
