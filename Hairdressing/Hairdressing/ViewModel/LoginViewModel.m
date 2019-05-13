//
//  LoginViewModel.m
//  Hairdressing
//
//  Created by admin on 16/3/26.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "LoginViewModel.h"
#import "YZMHomepageViewModel.h"
#import "MyTabBarViewModel.h"
#import "ForgotPasswordViewModel.h"
#import "RegistViewModel.h"
#import "User.h"
@interface LoginViewModel ()

@property (nonatomic, copy, readwrite) NSURL *avatarURL;

@property (nonatomic, strong, readwrite) RACSignal *validLoginSignal;

/// The command of login button.
@property (nonatomic, strong, readwrite) RACCommand *loginCommand;

@property (nonatomic, strong, readwrite) RACCommand *registCommand;

@property (nonatomic,strong,readwrite) RACCommand *forgotPasswordCommand;

@end

@implementation LoginViewModel

-(void)initialize{
    [super initialize];
    self.title = @"登录";
    @weakify(self)
    RAC(self,avatarURL) = [[RACObserve(self, username) map:^id(NSString *userName) {
        return userName;
    }] distinctUntilChanged];
    
    self.validLoginSignal = [[RACSignal combineLatest:
                              @[RACObserve(self, username),RACObserve(self, password)]  reduce:^(NSString *username,NSString *password){
                                  return @(username.length>0 && password.length>0 );
                              }]
                             distinctUntilChanged];
    
    void (^doNext)(NSDictionary *) = ^(NSDictionary *responeData) {
        @strongify(self)
        // 保存用户到内存
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:ISLOGIN];
            [[NSUserDefaults standardUserDefaults] setObject:[responeData objectForKey:@"token"] forKey:USER_TOKEN];//2b01abdd8cef33a417f64cde15da7140
            [[NSUserDefaults standardUserDefaults] setObject:self.username forKey:USER_ACCOUT];
            [[NSUserDefaults standardUserDefaults] setObject:self.password forKey:USER_PASSWORD];
            
            User *user = [User getUserFromDB];
            if (!user) {
                user  = [[User alloc]  init];
                user.account = [[NSUserDefaults standardUserDefaults] objectForKey:USER_ACCOUT];
                [user saveOrUpdate];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.services dismissViewModelAnimated:YES completion:^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:UserInfoChangeNotification object:nil];
                }];
            });

    };
    
    _loginCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"点击了登录");
        return [[self.services.loginServices loginWithUserName:self.username password:self.password]
                doNext:doNext];
    }];
    
    self.registCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        RegistViewModel * registModel = [[RegistViewModel alloc]initWithServices:self.services params:nil];
        
        [self.services pushViewModel:registModel animated:YES];
        
        return [RACSignal empty];
        
    }];
    
    self.forgotPasswordCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        ForgotPasswordViewModel * viewModel = [[ForgotPasswordViewModel alloc]initWithServices:self.services params:nil];
        [self.services pushViewModel:viewModel animated:YES];
        return [RACSignal empty];
    }];
    
    _cancelCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.services dismissViewModelAnimated:YES completion:nil];
            });
            return nil;
        }];
    }];
    
    
}


- (void)setUsername:(NSString *)username {
    _username = [username stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}





@end
