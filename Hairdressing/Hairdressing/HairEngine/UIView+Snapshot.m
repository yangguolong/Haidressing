#import "UIView+SnapShot.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView(Extended)
- (UIImage *)imageByRenderingView
{
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}

@end