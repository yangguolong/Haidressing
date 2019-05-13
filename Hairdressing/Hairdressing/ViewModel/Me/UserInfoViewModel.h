//
//  UserInfoViewModel.h
//  Hairdressing
//
//  Created by Guolong Yang on 16/3/28.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
@interface UserInfoViewModel : MRCTableViewModel
@property(nonatomic,strong,readonly)RACCommand *requestCommand;

@property(nonatomic,strong,readonly)RACCommand *saveCommand;

@property(nonatomic,strong,readonly)RACCommand *imageUploadCommand;

@property(nonatomic,strong,readonly)RACCommand *cropImageCommand;//剪切头像图片command
@property (nonatomic, strong, readwrite) RACSignal *validLoginSignal;

@property(nonatomic,strong)User *models;

//@property(nonatomic,copy)NSURL *avatarURL;
@property(nonatomic,copy)NSString *avatarURLStr;

//@property(nonatomic,copy)NSString *portraitImageDir;
@property(nonatomic,copy)NSString *userName;
@property(nonatomic, copy)  NSString *birthday;
@property(nonatomic,copy) NSString *sexuality;
@property(nonatomic,copy) NSString *account;//电话号码字符串


@property(nonatomic,strong)UIImage *avartImage;
@end
