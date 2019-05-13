//
//  YZMSlider.h
//  CustomSlider
//
//  Created by Yangjiaolong on 16/5/30.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZMSlider : UIControl

@property (nonatomic,copy)void (^valuedidChangeBlock)(CGFloat index);

@end
