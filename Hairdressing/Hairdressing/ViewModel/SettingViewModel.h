//
//  SettingViewModel.h
//  Hairdressing
//
//  Created by BoDong on 16/3/30.
//  Copyright © 2016年 Cloudream. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingViewModel : MRCTableViewModel



@property (nonatomic, strong, readonly) RACCommand *logoutCommand;
@end
