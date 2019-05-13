//
//  AllCommentCell.h
//  Hairdressing
//
//  Created by Guolong Yang on 16/4/21.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRCReactiveView.h"
#import "StudioComment.h"
@interface AllCommentCell : UITableViewCell<MRCReactiveView>
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UILabel *commentLab;

+ (CGFloat)heightOfCellWithModel:(StudioComment*)viewModel;
@end
