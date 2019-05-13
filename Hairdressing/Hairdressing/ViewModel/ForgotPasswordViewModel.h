//
//  ForgotPasswordViewModel.h
//  MTM
//
//  Created by 李昌庆 on 16/2/18.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "MRCViewModel.h"

@interface ForgotPasswordViewModel : MRCViewModel
@property (nonatomic ,copy) NSString *username;

@property (nonatomic ,copy) NSString *password;

@property (nonatomic ,copy) NSString *authCode;
@property (nonatomic ,strong, readonly) RACSignal *validPhoneSignal;

@property (nonatomic ,strong, readonly) RACCommand *getAuthCodeCommand;

@property (nonatomic ,strong, readonly) RACSignal *validRegistSignal;

@property (nonatomic ,strong, readonly) RACCommand *findpasswordButtonCommand;

@end
