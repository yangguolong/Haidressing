//
//  VPImageCropperViewModel.h
//  Hairdressing
//
//  Created by Guolong Yang on 16/5/24.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VPImageCropperViewModel : MRCViewModel
//(UIImage *)originalImage cropFrame:(CGRect)cropFrame limitScaleRatio:(NSInteger)limitRatio

@property(nonatomic,strong,readwrite)UIImage *originalImage;
@property(nonatomic,assign,readwrite)CGRect cropFrame;
@property(nonatomic,assign,readwrite)NSInteger limitRatio;

@end
