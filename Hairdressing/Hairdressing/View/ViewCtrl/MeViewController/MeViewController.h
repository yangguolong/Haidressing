//
//  YZMMeViewCtrlView.h
//  Hairdressing
//
//  Created by 杨国龙 on 16/3/4.
//  Copyright © 2016年 Cloudream. All rights reserved.
//

#import "MRCTableViewController.h"
#import "MyTabBarViewCtrl.h"
@interface MeViewController : MRCViewController<UITableViewDataSource,UITableViewDelegate,UIViewControllerTransitioningDelegate>
{
    NSArray *moreFunctionListArray;
    UITableView *meTableView;
    UIImageView *userPortrait;//用户头像
}



@end
