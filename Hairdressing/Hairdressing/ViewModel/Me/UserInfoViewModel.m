//
//  UserInfoViewModel.m
//  Hairdressing
//
//  Created by Guolong Yang on 16/3/28.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "UserInfoViewModel.h"
#import "UserInfoEditViewModel.h"
#import "User.h"
#import "VPImageCropperViewModel.h"
@interface UserInfoViewModel()

@property(nonatomic,strong,readwrite)RACCommand *imageUploadCommand;
@property(nonatomic,strong,readwrite)RACCommand *saveCommand;
@property(nonatomic,strong,readwrite)RACCommand *cropImageCommand;
@end
@implementation UserInfoViewModel



-(void)initialize{
    [super initialize];
    self.models = [User dataInit];
    RAC(self,userName)=RACObserve(self.models, name);
    RAC(self,birthday)  = RACObserve(self.models, birthday);
    RAC(self,sexuality) =RACObserve(self.models, sex);
    RAC(self,account) = RACObserve(self.models, account);
    RAC(self,avatarURLStr) = RACObserve(self.models, portraitImageDir);
    @weakify(self)
    self.saveCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *nameKeyStr) {
        @strongify(self)

            return [[[self.services.settingService settingWithToken:[[NSUserDefaults standardUserDefaults] objectForKey:USER_TOKEN] UserName:self.userName Birthday:self.birthday Sexurity:self.sexuality] doNext:^(id x) {
                User *user = [User getUserFromDB];
//                user.birthday =[NSString stringWithFormat:@"%lu",(unsigned long)[Utility compareHoursWithDate:self.birthday]];
                user.birthday = self.birthday;
                user.sex = self.sexuality;
                user.name = self.userName;
                [user saveOrUpdate];
            }] doNext:^(id x) {
                [[NSNotificationCenter defaultCenter] postNotificationName:UserInfoChangeNotification object:nil];
            }];

    }];

    void (^doNext)(NSDictionary *) = ^(NSDictionary *responeData) {
       // @strongify(self)
        // 保存用户到内存
        if (![responeData isKindOfClass:[NSNull class]])
        {
            User *user = [User getUserFromDB];
            user.portraitImageDir = responeData[@"head_img"];
            [user saveOrUpdate];
            
        }
        
    };
    self.imageUploadCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(UIImage *image) {
        return [[self.services.settingService uploadHeadImageWithToken:[[NSUserDefaults standardUserDefaults] objectForKey:USER_TOKEN] HeadImage:image andAction:@"setMyAvatar"] doNext:doNext];
    }];
    
    self.cropImageCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIImage *image) {
        @strongify(self)
        VPImageCropperViewModel *vpViewModel = [[VPImageCropperViewModel alloc]initWithServices:self.services params:nil];
        vpViewModel.originalImage = image;
        [self.services pushViewModel:vpViewModel animated:YES];
        return [RACSignal empty];
    }];
    self.validLoginSignal = [[RACSignal combineLatest:
                              @[RACObserve(self, userName),RACObserve(self, sexuality),RACObserve(self, birthday)]  reduce:^(NSString *username,NSString *sex,NSString *birthday){
                       //           @strongify(self)
                                  User *user = [User getUserFromDB];
                                  return @(!([user.name isEqualToString:username]&&[user.sex isEqualToString:sex]&&[user.birthday isEqualToString:birthday]));
                                //  return @(username.length>0 && password.length>0 );
                              }]
                             distinctUntilChanged];

}


@end