//
//  YZMHotHairStyleHeaderView.h
//  Hairdressing
//
//  Created by 杨国龙 on 16/3/7.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZMHotHairStyleHeaderView : UICollectionReusableView

+ (NSString *)indentifier;

+ (CGFloat)height;

- (void)setTitle:(NSString *)title;

@end
