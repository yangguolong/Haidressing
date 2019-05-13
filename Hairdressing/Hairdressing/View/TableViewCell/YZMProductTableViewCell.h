//
//  YZMProductTableViewCell.h
//  Hairdressing
//
//  Created by 杨国龙 on 16/3/7.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRCReactiveView.h"

@interface YZMProductTableViewCell : UITableViewCell <MRCReactiveView>

+ (NSString *)indentifier;

+ (CGFloat)cellHeight;

@end