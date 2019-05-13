//
//  YZMPaintViewModel.h
//  Hairdressing
//
//  Created by Yangjiaolong on 16/4/12.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "MRCViewModel.h"

@interface YZMPaintViewModel : MRCViewModel
@property (nonatomic,strong) UIImage * inputImage;

@property (nonatomic,strong) RACCommand * nextStepCommand;

@end
