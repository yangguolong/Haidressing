//
//  UserInfoEditViewModel.h
//  Hairdressing
//
//  Created by Guolong Yang on 16/4/13.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
@interface UserInfoEditViewModel : MRCViewModel

@property(nonatomic,copy)NSString *userEditItem;

@property(nonatomic,strong)User *models;

@property(nonatomic,copy)NSURL *avatarURL;

@property(nonatomic,copy)NSString *portraitImageDir;
@property(nonatomic,copy)NSString *name;
@property(nonatomic, copy)  NSString *birthday;
@property(nonatomic,copy) NSString *sexuality;
@property(nonatomic,copy) NSString *account;//电话号码字符串

@end
