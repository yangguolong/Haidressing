//
//  YZMLoadActivityView.m
//  Hairdressing
//
//  Created by Yangjiaolong on 16/6/2.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "YZMLoadActivityView.h"


@interface YZMLoadActivityView ()

@property (weak, nonatomic) IBOutlet UIImageView *loadImageVIew;

@end

@implementation YZMLoadActivityView


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        NSMutableArray * images = [NSMutableArray array];
        for (int i = 1; i < 7; i++) {
            UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"xjc_%zd",i]];
            [images addObject:image];
        }
        
        [_loadImageVIew setAnimationImages:images];
        [_loadImageVIew startAnimating];
        [_loadImageVIew setAnimationDuration:2];
    }
    return self;
}

+(void)show{
    
    YZMLoadActivityView * alertView = [[[NSBundle mainBundle]loadNibNamed:@"YZMLoadActivityView" owner:self options:nil]firstObject];

    alertView.tag = 2333;
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    alertView.frame = window.bounds;
    
    [window addSubview:alertView];

    
}


+(void)hidden{
    UIView * view = [[UIApplication sharedApplication].keyWindow viewWithTag:2333];
    [view removeFromSuperview];
    
}

@end