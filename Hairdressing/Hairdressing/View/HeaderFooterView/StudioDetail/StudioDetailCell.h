//
//  DesignerDetailCell.h
//  Hairdressing
//
//  Created by BoDong on 16/4/8.
//  Copyright © 2016年 Cloudream. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRCReactiveView.h"

@interface StudioDetailCell : UITableViewCell <MRCReactiveView>




+(StudioDetailCell*)cellWithTableView:(UITableView*)tableView;
@end
