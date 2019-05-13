//
//  OrderDetailCell.h
//  Hairdressing
//
//  Created by Guolong Yang on 16/5/24.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRCReactiveView.h"
@interface OrderDetailCell : UITableViewCell<MRCReactiveView>

@property (weak, nonatomic) IBOutlet UIView *waitingForPayView;

@property (weak, nonatomic) IBOutlet UIView *waitingForCousumeView;

@property (weak, nonatomic) IBOutlet UIView *waitingForReviewView;

@property (weak, nonatomic) IBOutlet UIView *moneyBackView;

@property (weak, nonatomic) IBOutlet UILabel *waitPayCountLab;//等待付款计数
@property (weak, nonatomic) IBOutlet UILabel *waitConsumeCountLab;//等待消费计数
@property (weak, nonatomic) IBOutlet UILabel *waitReviewCountLab;//等待评论计数


+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
