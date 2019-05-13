//
//  UserSettingModel.m
//  Hairdressing
//
//  Created by Guolong Yang on 16/3/29.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "User.h"

@implementation User

static User *mySelf = nil;

//+(User*)sharedInstance{
//    static User *_sharedInstance = nil;
//    static dispatch_once_t oncePredicate;
//    dispatch_once(&oncePredicate, ^{
//        _sharedInstance =[[User alloc]init];
//    });
//    return _sharedInstance;
//}




+ (User *)getUserFromDB
{
    if (mySelf == nil){
        NSString *accout = [[NSUserDefaults standardUserDefaults] objectForKey:USER_ACCOUT];
        User *user1 = (User *)[User findFirstByCriteria:[NSString stringWithFormat:@"WHERE account = \'%@\'",accout]];
        mySelf = user1;
    }
    return mySelf;
}

+ (User *)getUserFromLocalCache{
    NSString *accout = [[NSUserDefaults standardUserDefaults] objectForKey:USER_ACCOUT];
    User *user1 = (User *)[User findFirstByCriteria:[NSString stringWithFormat:@"WHERE account = \'%@\'",accout]];
    return user1;
}

+(User *)dataInit{
    User *user=[User getUserFromDB];
    if (!user) {
        user  = [[User alloc]  init];
        user.account = [[NSUserDefaults standardUserDefaults] objectForKey:USER_ACCOUT];
        
        [user saveOrUpdate];
    }
    return user;
}

@end
