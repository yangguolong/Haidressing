//
//  YLRangeSliderViewDelegate.h
//  FantasyRealFootball
//
//  Created by Tom Thorpe on 16/04/2014.
//  Copyright (c) 2014 Yahoo inc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YZMRangeSlider;

@protocol YZMRangeSliderDelegate <NSObject>

/**
 * Called when the RangeSlider values are changed
 */
-(void)rangeSlider:(YZMRangeSlider *)sender didChangeSelectedMinimumValue:(float)selectedMinimum andMaximumValue:(float)selectedMaximum;

@optional

/**
 * Called when the user has finished interacting with the RangeSlider
 */
- (void)didEndTouchesInRangeSlider:(YZMRangeSlider *)sender;

/**
 * Called when the user has started interacting with the RangeSlider
 */
- (void)didStarYZMouchesInRangeSlider:(YZMRangeSlider *)sender;

@end
