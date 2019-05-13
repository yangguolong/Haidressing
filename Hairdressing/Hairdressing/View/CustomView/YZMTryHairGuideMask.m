//
//  YZMTryHairGuideMask.m
//  Hairdressing
//
//  Created by Yangjiaolong on 16/5/20.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "YZMTryHairGuideMask.h"

static NSString * kYZMTryHairGuideMaskNontShow = @"kYZMTryHairGuideMaskNontShow";
@implementation YZMTryHairGuideMask
+(void)show{
    
    
    BOOL dontShow = [[NSUserDefaults standardUserDefaults]boolForKey:kYZMTryHairGuideMaskNontShow];
    if (dontShow) {
        return;
    }
    
    
    YZMTryHairGuideMask * alertView = [[[NSBundle mainBundle]loadNibNamed:@"YZMTryHairGuideMask" owner:self options:nil]firstObject];
    
    
    
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    alertView.frame = window.bounds;
    
    [window addSubview:alertView];
}

- (IBAction)tap:(UITapGestureRecognizer *)sender {
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:kYZMTryHairGuideMaskNontShow];
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
