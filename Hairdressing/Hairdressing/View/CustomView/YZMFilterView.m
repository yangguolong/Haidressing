//
//  YZMFilterView.m
//  Hairdressing
//
//  Created by 杨国龙 on 16/3/9.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "YZMFilterView.h"

@interface YZMFilterView ()

@end

@implementation YZMFilterView

- (void)awakeFromNib
{
    //custom number formatter range slider
    self.rangeSlider.delegate = self;
    self.rangeSlider.minValue = 0;
    self.rangeSlider.maxValue = 100;
    self.rangeSlider.selectedMinimum = 40;
    self.rangeSlider.selectedMaximum = 60;
    self.rangeSlider.handleImage = [UIImage imageNamed:@"test5"];
    self.rangeSlider.selectedHandleDiameterMultiplier = 1;
    self.rangeSlider.tintColorBetweenHandles = [UIColor redColor];
    self.rangeSlider.lineHeight = 10;
    NSNumberFormatter *customFormatter = [[NSNumberFormatter alloc] init];
    customFormatter.positivePrefix = @"￥";
    self.rangeSlider.numberFormatterOverride = customFormatter;
}

- (void)rangeSlider:(YZMRangeSlider *)sender didChangeSelectedMinimumValue:(float)selectedMinimum andMaximumValue:(float)selectedMaximum
{
      NSLog(@"Custom slider updated. Min Value: %.0f Max Value: %.0f", selectedMinimum, selectedMaximum);

}

+ (CGFloat)viewHeight
{
    return 179;
}

@end
