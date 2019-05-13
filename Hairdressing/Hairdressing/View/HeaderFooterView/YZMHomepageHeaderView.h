//
//  YZMHomepageHeaderView.h
//  Hairdressing
//
//  Created by 杨国龙 on 16/3/4.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJNewsView.h"

@interface YZMHomepageHeaderView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet MJNewsView *sliderView;

@property (weak, nonatomic) NSArray *categoryData;

+ (CGFloat)height;

+ (NSString *)indentifier;

@end
