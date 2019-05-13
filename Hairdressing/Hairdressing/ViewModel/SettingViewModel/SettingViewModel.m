//
//  SettingViewModel.m
//  Hairdressing
//
//  Created by Guolong Yang on 16/3/30.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "SettingViewModel.h"
#import "LoginViewModel.h"
#import "MRCViewModelServices.h"
#import "MyTabBarViewModel.h"
#import "CopyRightViewModel.h"
@interface SettingViewModel ()
@property(nonatomic,strong,readwrite)RACCommand *loginCommand;
@property (nonatomic, strong, readwrite) RACCommand *logoutCommand;

@end
@implementation SettingViewModel

-(void)initialize{
    [super initialize];
    self.title = @"设置";
    @weakify(self)
    self.didSelectCommand =[[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSIndexPath *indexPath) {
        @strongify(self)
        if (indexPath.section == 0 && indexPath.row == 0) {
            CopyRightViewModel *copyRightViewModel = [[CopyRightViewModel alloc]initWithServices:self.services params:nil];
            [self.services pushViewModel:copyRightViewModel animated:YES];
        }
        return [RACSignal empty];
    }];
    void (^logout)(NSDictionary *) = ^(NSDictionary *responeData) {
        @strongify(self)
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:ISLOGIN];
//        MyTabBarViewModel *viewModel = [[MyTabBarViewModel alloc] initWithServices:self.services params:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.services popViewModelAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:UserInfoChangeNotification object:nil];
        });
        
        
    };
    self.logoutCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {

        if ([[NSUserDefaults standardUserDefaults] boolForKey:ISLOGIN]) {
            return [[self.services.loginServices loginoutWithUserToken:[[NSUserDefaults standardUserDefaults] objectForKey:USER_TOKEN]]doNext:logout];
        }
        else
        {
            LoginViewModel *loginVM = [[LoginViewModel alloc]initWithServices:self.services params:nil];
            [self.services presentViewModel:loginVM animated:YES completion:nil];
            return [RACSignal empty];
        }

    }];
    
    

}




@end