//
//  YZMTryHairShareView.m
//  Hairdressing
//
//  Created by Yangjiaolong on 16/5/31.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "YZMTryHairShareView.h"

@interface YZMTryHairShareView ()

@property (weak, nonatomic) IBOutlet UIButton *weChatButton;

@property (weak, nonatomic) IBOutlet UIButton *pyqButton;

@property (weak, nonatomic) IBOutlet UIButton *qqButton;

@end

@implementation YZMTryHairShareView

+(void)show{
    
    YZMTryHairShareView * alertView = [[[NSBundle mainBundle]loadNibNamed:@"YZMTryHairShareView" owner:self options:nil] lastObject];
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    alertView.frame = window.bounds;
    
    [window addSubview:alertView];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        DLog(@"ccc");
    }
    return self;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end