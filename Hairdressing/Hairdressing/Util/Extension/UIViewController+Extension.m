//
//  UIViewController+Extension.m
//  ismarter2.0_sz
//
//  Created by zx_02 on 15/8/6.
//
//

#import "UIViewController+Extension.h"
#import <objc/runtime.h>

@implementation UIViewController (Extension)

static char *progressHUDKey = "progressHUDKey" ;
static char *hudKey = "hudKey" ;


#pragma mark - 不带风火轮
- (MBProgressHUD *)progressHUD
{
    MBProgressHUD *progressHUD;
    if (!objc_getAssociatedObject(self, progressHUDKey))
    {
        progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        progressHUD.minSize = CGSizeMake(120, 100);
        progressHUD.minShowTime = 1;
        progressHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark.png"]];//没有这个图片  ZY 1204
        [self.view addSubview:progressHUD];
        objc_setAssociatedObject(self, progressHUDKey, progressHUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return objc_getAssociatedObject(self, progressHUDKey);
}

- (void)showHUDComplete:(NSString *)title
{
    MBProgressHUD *progressHUD = self.progressHUD;
    if (title)
    {
        [progressHUD show:YES];
        progressHUD.labelText = title;
        progressHUD.mode = MBProgressHUDModeCustomView;
        [progressHUD hide:YES afterDelay:1.5];
    }
    else {
        [progressHUD hide:YES];
    }
}

#pragma mark - 带风火轮的
- (MBProgressHUD *)hud
{
    MBProgressHUD *hud;
    if (!objc_getAssociatedObject(self, hudKey))
    {
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        objc_setAssociatedObject(self, hudKey, hud, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return objc_getAssociatedObject(self, hudKey);
}

- (void)showHUD:(NSString *)title isDim:(BOOL)isDim
{
    self.hud.customView = nil;
    self.hud.dimBackground = isDim;
    self.hud.labelText = title;
    self.hud.mode = MBProgressHUDModeIndeterminate;
    self.hud.alpha = 1.0f;
}

- (void)showHUDSuccess:(NSString *)title
{
    self.hud.alpha = 1.0f;
    self.hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud_succeed"]];
    self.hud.mode = MBProgressHUDModeCustomView;
    if (title.length > 0) {
        self.hud.labelText = title;
    }else {
        self.hud.labelText = nil;
    }
    [self.hud hide:YES afterDelay:1.5];
}

- (void)showHUDFail:(NSString *)title
{
    self.hud.alpha = 1.0f;
    self.hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud_failed"]];
    self.hud.mode = MBProgressHUDModeCustomView;
    if (title.length > 0) {
        self.hud.labelText = title;
    }else {
        self.hud.labelText = nil;
    }
    [self.hud hide:YES afterDelay:1.5];
}

- (void)showHUDWarn:(NSString *)title;
{
    self.hud.alpha = 1.0f;
    self.hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud_warn"]];
    self.hud.mode = MBProgressHUDModeCustomView;
    if (title.length > 0) {
        self.hud.labelText = title;
    }else {
        self.hud.labelText = nil;
    }
    [self.hud hide:YES afterDelay:1.5];
}

- (void)showHUDWait:(NSString *)title
{
    self.hud.alpha = 1.0f;
    self.hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud_wait"]];
    self.hud.mode = MBProgressHUDModeCustomView;
    if (title.length > 0) {
        self.hud.labelText = title;
    }else {
        self.hud.labelText = nil;
    }
    [self.hud hide:YES afterDelay:1.5];
}

- (void)showHUDSuccessLonger:(NSString *)title
{
    self.hud.alpha = 1.0f;
    self.hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud_succeed"]];
    self.hud.mode = MBProgressHUDModeCustomView;
    if (title.length > 0) {
        self.hud.labelText = title;
    }else {
        self.hud.labelText = nil;
    }
    [self.hud hide:YES afterDelay:4];
}

- (void)hideHUD
{
    [self.hud hide:YES];
}

#pragma mark - 
- (UIViewController *)viewController
{
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
}

@end
