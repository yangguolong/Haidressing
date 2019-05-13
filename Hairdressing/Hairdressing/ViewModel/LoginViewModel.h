//
//  LoginViewModel.h
//  Hairdressing
//
//  Created by admin on 16/3/26.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface LoginViewModel : MRCViewModel

///// The avatar URL of the user.
//@property (nonatomic, copy, readonly) NSURL *avatarURL;
@property (nonatomic, copy, readonly) NSURL *avatarURLStr;

/// The username entered by the user.
@property (nonatomic, copy) NSString *username;

/// The password entered by the user.
@property (nonatomic, copy) NSString *password;

@property (nonatomic, strong, readonly) RACSignal *validLoginSignal;

/// The command of login button.
@property (nonatomic, strong, readonly) RACCommand *loginCommand;

@property (nonatomic, strong, readonly) RACCommand *registCommand;

@property (nonatomic,strong,readonly) RACCommand *forgotPasswordCommand;

///// The command of uses to cancel logging.
@property (nonatomic, strong, readonly) RACCommand *cancelCommand;


@end
