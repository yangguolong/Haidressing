//
//  UserInfoViewController.h
//  Hairdressing
//
//  Created by BoDong on 16/3/28.
//  Copyright © 2016年 Cloudream. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserViewModel.h"
#import "MediaPickerController.h"

@class AllUserInfoEditViewController;
@interface UserInfoViewController : MRCViewController
{

    NSArray     *userInfoListArray;
}
@property(nonatomic,strong)    UITableView *userInfoTableView;
@property (retain, nonatomic) AllUserInfoEditViewController *editUserInfo;
@property(nonatomic, retain) MediaPickerController  *mediaPicker;
@property(nonatomic,strong)UserViewModel *userViewModel;
@property(nonatomic,strong)UIButton *avatarButton;
@end
