//
//  YZMMeViewCtrlView.h
//  Hairdressing
//
//  Created by 杨国龙 on 16/3/4.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "MRCTableViewController.h"
#import "MyTabBarViewCtrl.h"
#import "User.h"
#import "YZMMeViewModel.h"
#import "MediaPickerController.h"
@interface YZMMeViewController : MRCTableViewController<UIViewControllerTransitioningDelegate,LEActionSheetDelegate,UIScrollViewDelegate>
{
    NSArray *moreFunctionListArray;

   // UIButton *userPortrait;//用户头像
    

}

@property(nonatomic, retain) MediaPickerController  *mediaPicker;

@end