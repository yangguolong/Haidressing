//
//  YZMFilterView.h
//  Hairdressing
//
//  过滤view
//
//  Created by 杨国龙 on 16/3/9.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZMRangeSlider.h"

@interface YZMFilterView : UIView <YZMRangeSliderDelegate>

@property (weak, nonatomic) IBOutlet YZMRangeSlider *rangeSlider;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraints;

+ (CGFloat)viewHeight;

@end
