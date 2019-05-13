//
//  cloudcrack
//
//  Created by ygl on 15-1-11.
//  Copyright (c) 2015年 goking. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZMOrderListHeaderView : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

+ (CGFloat)headerHeight;

+ (instancetype)instance;

@end
