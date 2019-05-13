//
//  UIView+ShowHUD.m
//  MinLED
//
//  Created by Yigol on 14/12/16.
//  Copyright (c) 2014年 injoinow. All rights reserved.
//

#define HUDSTRING @"加载中..."
#define ACTIVITYTAG 8888
#define AUTOHIDEACTIVITYTAG 9999
#define HudAlpha 0.9
#define HudWhiteColor 0

#define HUDERROR @"请求数据失败！"

#import "UIView+ShowHUD.h"
#import <MBProgressHUD/MBProgressHUD.h>

@implementation UIView (ShowHUD)

- (void)showHUD
{
    UIView *view = [self viewWithTag:ACTIVITYTAG];
    if (view) {
        [view removeFromSuperview];
    }
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self];
    
    hud.color = [UIColor colorWithWhite:HudWhiteColor alpha:HudAlpha];
    hud.activityIndicatorColor = [UIColor darkGrayColor];
    hud.labelColor = [UIColor whiteColor];
    hud.tag = ACTIVITYTAG;
    hud.labelText = HUDSTRING;
    [self addSubview:hud];
    [hud show:YES];
}

- (void)showHUDWith:(NSString *)str
{
    UIView *view = [self viewWithTag:ACTIVITYTAG];
    if (view) {
        [view removeFromSuperview];
    }
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self];
    hud.color = [UIColor colorWithWhite:HudWhiteColor alpha:HudAlpha];
    hud.activityIndicatorColor = [UIColor darkGrayColor];
    hud.labelColor = [UIColor whiteColor];
    hud.tag = ACTIVITYTAG;
    hud.labelText = str;
    [self addSubview:hud];
    [hud show:YES];
}

- (void)showHUDWith:(NSString *)str hideAfterDelay:(NSTimeInterval )timeInterval
{
//    UIView *view = [self viewWithTag:AUTOHIDEACTIVITYTAG];
//    if (view) {
//        return;
//    }
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self];
    hud.color = [UIColor colorWithWhite:HudWhiteColor alpha:HudAlpha];
    hud.labelColor = [UIColor whiteColor];
    hud.tag = AUTOHIDEACTIVITYTAG;
    hud.labelText = str;
    hud.mode = MBProgressHUDModeText;
    [self addSubview:hud];
    [hud show:YES];
    [hud hide:YES afterDelay:timeInterval];
}



- (void)showHUDWithError
{
    UIView *view = [self viewWithTag:ACTIVITYTAG];
    if (view) {
        [view removeFromSuperview];
    }
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Error_Network"]];
    hud.color = [UIColor colorWithWhite:HudWhiteColor alpha:HudAlpha];
    hud.labelColor = [UIColor whiteColor];
    hud.tag = AUTOHIDEACTIVITYTAG;
    hud.labelText = HUDERROR;
    [self addSubview:hud];
    [hud show:YES];
    [hud hide:YES afterDelay:1.0];
}

- (void)hideHUD
{
    MBProgressHUD *view =(MBProgressHUD *) [self viewWithTag:ACTIVITYTAG];
    [view hide:YES];
}


@end
