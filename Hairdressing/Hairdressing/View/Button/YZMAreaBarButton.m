//
//  YZMAreaBarButton.m
//  Hairdressing
//
//  Created by 杨国龙 on 16/3/4.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "YZMAreaBarButton.h"
#import "UIImage+GK.h"

#define ImageW 20;

@implementation YZMAreaBarButton

+ (instancetype)areaBarButton
{
    return [[self alloc] init];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //高亮的时候不要自动调整图标
        self.adjustsImageWhenHighlighted = NO;
        //字体样式 ： 粗体 、 16
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        //居中靠右
        self.imageView.contentMode = UIViewContentModeCenter;
        self.titleLabel.textAlignment = NSTextAlignmentRight;
        //背景
        [self setBackgroundImage:[UIImage resizedImageWithName:@"navigationbar_filter_background_highlighted"] forState:UIControlStateHighlighted];
        
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    
    return  CGRectMake(contentRect.size.width - 16.5, contentRect.size.height/2 - 6, 16.5,10.5);
//    CGFloat imageY = 0;
//    CGFloat imageW = ImageW;
//    CGFloat imageX = contentRect.size.width - imageW;
//    CGFloat imageH = contentRect.size.height;
//    return CGRectMake(imageX, imageY, imageW, imageH);
    
   
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleY = 0;
    CGFloat titleX = 0;
    CGFloat titleW = contentRect.size.width - ImageW;
    CGFloat titleH = contentRect.size.height;
    return CGRectMake(titleX, titleY, titleW, titleH);
}
@end
