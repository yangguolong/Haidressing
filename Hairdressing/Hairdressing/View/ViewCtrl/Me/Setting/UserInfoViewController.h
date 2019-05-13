//
//  UserInfoViewController.h
//  Hairdressing
//
//  Created by Guolong Yang on 16/3/28.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoViewModel.h"
#import "MediaPickerController.h"
#import "User.h"

@class AllUserInfoEditViewController;
@interface UserInfoViewController : MRCTableViewController
{

    NSArray     *userInfoListArray;
    
}
@property(nonatomic,strong)    UITableView *userInfoTableView;
@property (retain, nonatomic) AllUserInfoEditViewController *editUserInfo;
@property(nonatomic, retain) MediaPickerController  *mediaPicker;
@property(nonatomic,strong)UserInfoViewModel *viewModel;
@property(nonatomic,strong)UIButton *avatarButton;
@property(nonatomic,strong)User *localUser;
@property(nonatomic,copy,readwrite)NSString *birthStr;
@property(nonatomic,copy,readwrite)NSString *sexStr;
@end