//
//  RegistViewModel.m
//  MTM
//
//  Created by 杨国龙 on 16/1/27.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "RegistViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import "MRCMemoryCache.h"
#import "User.h"
#import "LoginService.h"
#import "MRCViewModelServices.h"
#import "MyTabBarViewModel.h"

@interface RegistViewModel ()

@property (nonatomic ,strong, readwrite) RACSignal *validPhoneSignal;

@property (nonatomic ,strong, readwrite) RACCommand *getAuthCodeCommand;

@property (nonatomic ,strong, readwrite) RACSignal *validRegistSignal;

@property (nonatomic ,strong, readwrite) RACCommand *registCommand;

@end


@implementation RegistViewModel

- (void)initialize
{
    [super initialize];
    self.title = @"注册";
    self.validRegistSignal = [[RACSignal
        combineLatest:@[RACObserve(self, username), RACObserve(self, password), RACObserve(self, authCode)]
        reduce:^(NSString *username, NSString *password, NSString* authCode ) {
            return @(username.length > 0 && password.length > 0 && authCode.length > 0);
        }]
        distinctUntilChanged];
    
    self.validPhoneSignal = [[RACSignal
                              combineLatest:@[RACObserve(self, username)]
                              reduce:^(NSString *username ) {
                                  return @([Utility vefifyPhoneNumber:username]);
                              }]
                             distinctUntilChanged];

    @weakify(self)
    self.registCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        return [[self.services.registService registWithUserName:self.username password:self.password authCode:self.authCode withType:@1]
            doNext:^(NSDictionary *responeData) {
                @strongify(self)
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
                    [self.services popToRootViewModelAnimated:YES];
                });
            }];
        }];

    self.getAuthCodeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
       
        @strongify(self)
        return [[self.services.registService getAuthCodeWithPhoneNumber:self.username]
        doNext:^(NSString *result) {
            // 获取到验证码的回调
            NSLog(@"autoCode:%@",result);
        }] ;
    }];
    
    
}

- (void)setUsername:(NSString *)username {
    _username = [username stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

@end
