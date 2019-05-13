//
//  SettingViewModel.h
//  Hairdressing
//
//  Created by Guolong Yang on 16/3/30.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingViewModel : MRCTableViewModel


@property(nonatomic,strong,readonly)RACCommand *loginCommand;
@property (nonatomic, strong, readonly) RACCommand *logoutCommand;
@end
