//
//  YZMProductDetailsTabView.h
//  Hairdressing
//
//  Created by 杨国龙 on 16/3/15.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    YZMProductDetailsTabViewSelectStateServiceDetail = 0,
    YZMProductDetailsTabViewSelectStateShopInfo,
    YZMProductDetailsTabViewSelectStateComment,
}YZMProductDetailsTabViewSelectState;

@interface YZMProductDetailsTabView : UIView

@property (nonatomic ,assign) YZMProductDetailsTabViewSelectState state;

+ (CGFloat)viewHeight;

@end
