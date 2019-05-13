//
//  AllCommentCell.h
//  Hairdressing
//
//  Created by BoDong on 16/4/21.
//  Copyright © 2016年 Cloudream. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRCReactiveView.h"
@interface AllCommentCell : UITableViewCell<MRCReactiveView>
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UILabel *commentLab;

@end
