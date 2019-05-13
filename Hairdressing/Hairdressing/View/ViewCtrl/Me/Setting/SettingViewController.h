//
//  SettingViewController.h
//  Hairdressing
//
//  Created by Guolong Yang on 16/3/29.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingViewModel.h"
@interface SettingViewController : MRCViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{

    NSArray *settingListArray;
}

@property(nonatomic,strong,readonly)SettingViewModel *viewModel;

@end
