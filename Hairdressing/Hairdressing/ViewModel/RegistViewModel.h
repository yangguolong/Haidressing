//
//  RegistViewModel.h
//  MTM
//
//  Created by 杨国龙 on 16/1/27.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "MRCViewModel.h"

@interface RegistViewModel : MRCViewModel

@property (nonatomic ,copy) NSString *username;

@property (nonatomic ,copy) NSString *password;

@property (nonatomic ,copy) NSString *authCode;

@property (nonatomic ,strong, readonly) RACSignal *validPhoneSignal;

@property (nonatomic ,strong, readonly) RACCommand *getAuthCodeCommand;

@property (nonatomic ,strong, readonly) RACSignal *validRegistSignal;

@property (nonatomic ,strong, readonly) RACCommand *registCommand;


@end
