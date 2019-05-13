//
//  SettingViewModel.m
//  Hairdressing
//
//  Created by BoDong on 16/3/30.
//  Copyright © 2016年 Cloudream. All rights reserved.
//

#import "SettingViewModel.h"
#import "LoginViewModel.h"
#import "MRCViewModelServices.h"
@interface SettingViewModel ()

@property (nonatomic, strong, readwrite) RACCommand *logoutCommand;

@end
@implementation SettingViewModel

-(void)initialize{
    @weakify(self)
    self.logoutCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
//        [SSKeychain deleteAccessToken];
//        
//        [[MRCMemoryCache sharedInstance] removeObjectForKey:@"currentUser"];
        
        LoginViewModel *loginViewModel = [[LoginViewModel alloc] initWithServices:self.services params:nil];
        [self.services resetRootViewModel:loginViewModel];
        
        return [RACSignal empty];
    }];
    
//    self.didSelectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSIndexPath *indexPath) {
//        @strongify(self)
//        if (indexPath.section == 1 && indexPath.row == 0) {
//            MRCAboutViewModel *aboutViewModel = [[MRCAboutViewModel alloc] initWithServices:self.services params:nil];
//            [self.services pushViewModel:aboutViewModel animated:YES];
//        }
//        return [RACSignal empty];
//    }];

}




@end
