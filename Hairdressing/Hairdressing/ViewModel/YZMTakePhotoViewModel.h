//
//  YZMTakePhotoViewModel.h
//  Hairdressing
//
//  Created by Yangjiaolong on 16/4/5.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "MRCViewModel.h"

@interface YZMTakePhotoViewModel : MRCViewModel

@property (nonatomic,strong) UIImage * captureImage;

@property (nonatomic,strong) RACCommand * didPickerImageCommand;

@end
