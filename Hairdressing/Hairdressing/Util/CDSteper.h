//
//  CDSteper.h
//  Fitroom3D
//
//  Created by 李昌庆 on 15/5/21.
//  Copyright (c) 2015年 Yangjiaolong. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface CDSteper : UIView

@property (nonatomic,assign)IBInspectable NSInteger maxValues;
@property (nonatomic,assign)IBInspectable NSInteger minValues;
@property (nonatomic,assign)IBInspectable NSInteger currentValues;
@property (nonatomic,strong)IBInspectable UIImage * minButtonImage;
@property (nonatomic,strong)IBInspectable UIImage * maxButtonImage;
//@property (nonatomic,strong)IBInspectable UIImage * minButtonbackgrandImage;
//@property (nonatomic,strong)IBInspectable UIImage * maxButtonbackgrandImage;
@property (nonatomic,strong)IBInspectable UIColor * textLabelBackgrandColor;
@property (nonatomic,strong)IBInspectable UIFont* textLabelFont;
@property (nonatomic,assign)IBInspectable CGFloat buttonsWidth;
@property (nonatomic,assign)IBInspectable CGFloat buttonsHeight;

@end
