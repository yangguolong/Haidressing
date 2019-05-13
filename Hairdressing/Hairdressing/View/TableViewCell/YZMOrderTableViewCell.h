//
//  YZMOrderTableViewCell.h
//  Hairdressing
//
//  Created by yzm on 16/4/14.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRCReactiveView.h"

@interface YZMOrderTableViewCell : UITableViewCell <MRCReactiveView>

+ (CGFloat)cellHeight;

+ (NSString *)indentifier;

@end