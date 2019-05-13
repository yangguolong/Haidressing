//
//  SettingViewController.h
//  Hairdressing
//
//  Created by BoDong on 16/3/29.
//  Copyright © 2016年 Cloudream. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{

    NSArray *settingListArray;
    UITableView *settingTableView;
}
@end
