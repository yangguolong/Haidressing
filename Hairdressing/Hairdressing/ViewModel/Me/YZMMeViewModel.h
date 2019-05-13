//
//  YZMMeViewModel.h
//  Hairdressing
//
//  Created by 杨国龙 on 16/3/4.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "MRCTableViewModel.h"
#import "User.h"
@interface YZMMeViewModel : MRCTableViewModel


@property(nonatomic,strong,readwrite)User *user;
@property(nonatomic,copy)NSString *hairStyleModelPath;
@property(nonatomic,strong)RACCommand *requestDataCommand;
@property(nonatomic,strong,readonly)RACCommand *orderInfoCommand;//订单情况查询
@property(nonatomic,strong,readonly)RACCommand *imageUploadCommand;
@property(nonatomic,strong,readonly)RACCommand *goToSettingCommand;
@property(nonatomic,strong,readonly)RACCommand *cropImageCommand;
@property(nonatomic,strong,readonly)RACCommand *userInfoGetCommand;//重新获取用户的信息
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *imageURLString;//用户头像url string
@property(nonatomic,strong)UIImage *userImage;

@end
