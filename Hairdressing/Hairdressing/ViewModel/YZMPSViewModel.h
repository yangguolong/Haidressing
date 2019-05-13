//
//  YZMPSViewModel.h
//  Hairdressing
//
//  Created by Yangjiaolong on 16/4/12.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "MRCViewModel.h"

@interface YZMPSViewModel : MRCViewModel
@property (nonatomic,strong)UIImage * captureImage;

@property (nonatomic,strong) RACCommand * nextStepCommamd;

@end
