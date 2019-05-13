//
//  UserSettingModel.h
//  Hairdressing
//
//  Created by Guolong Yang on 16/3/29.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : JKDBModel

@property(nonatomic,copy)NSString *portraitImageDir;
@property(nonatomic,copy)NSString *name;
@property(nonatomic, copy)  NSString *birthday;
@property(nonatomic,copy) NSString *sex;
@property(nonatomic,copy) NSString *account;//电话号码字符串

+ (User *)getUserFromDB;
+ (User *)getUserFromLocalCache;
+(User *)dataInit;
///**
// *  用户单例
// *
// *  @return 
// */
//+(User*)sharedInstance;
@end
