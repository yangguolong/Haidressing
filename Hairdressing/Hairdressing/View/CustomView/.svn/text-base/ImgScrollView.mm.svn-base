//
//  ImgScrollView.m
//  ismarter2.0_sz
//
//  Created by liuqian on 14-8-13.
//
//

#import "ImgScrollView.h"

#import "UIImage+KTCategory.h"
#import "AppDelegate.h"
#import <objc/runtime.h>



@implementation ImgScrollView
@synthesize parent;
@synthesize imgPath;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.bouncesZoom = YES;
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        self.minimumZoomScale = 1.0;
        self.userInteractionEnabled = YES;
        
        imgView = [[UIImageView alloc] init];
        imgView.tag = 12345;
        imgView.clipsToBounds = YES;
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.contentScaleFactor = [[UIScreen mainScreen] scale];
        [self addSubview:imgView];
        
        _loadImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chatgroup_send_picture"]];
        [self addSubview:_loadImageV];
        _loadImageV.hidden = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickMethod:)];
        [self addGestureRecognizer:tap];
        
    }
    return self;
}

- (void)initData
{
    //    boardType = self.blackboard.boardType;
    //    blackboardId = self.blackboard.serverBlackboardId;
    //    userId = self.blackboard.userId;
    //    if (boardType == 1) {
    //        filePath = [self.blackboard.originFileArray objectAtIndex:self.tag - 100];
    //        thumbnailPath = [self.blackboard.thumbnailPathArray objectAtIndex:self.tag - 100];
    //    }
    //    else {
    //        filePath = self.blackboard.picturePath;
    //        thumbnailPath = self.blackboard.picturePath;
    //    }
}


- (void)setContentWithFrame:(CGRect) rect
{
    imgView.frame = rect;
    initRect = rect;//缩放前的图片大小
    _loadImageV.center = imgView.center;
}

- (void)setAnimationRect
{
    imgView.frame = scaleOriginRect;
    _loadImageV.center = imgView.center;//加载图放在主显示图像中央
    [self startAnimation];//加载图执行动画效果
}

- (void)rechangeInitRect//恢复主显示图片的frame
{
    self.zoomScale = 1.0;
    imgView.frame = initRect;
}

- (void)setImage:(UIImage *)image AndViewTimes:(int)times
{
    imgView.image = image;
    self.thumbnailImage = image;
    //    if (times > 1)
    //    {
    //        imgSize = imgView.image.size;
    //        if (imgSize.width == 0 || imgSize.height == 0) {
    //            return;
    //        }
    //        float scaleX = self.frame.size.width/imgSize.width;
    //        float scaleY = self.frame.size.height/imgSize.height;
    //        if (scaleX > scaleY)
    //        {
    //            float imgViewWidth = imgSize.width*scaleY;
    //            self.maximumZoomScale = self.frame.size.width/imgViewWidth;
    //            scaleOriginRect = (CGRect){self.frame.size.width/2-imgViewWidth/2,0,imgViewWidth,self.frame.size.height};
    //        }
    //        else
    //        {
    //            float imgViewHeight = imgSize.height*scaleX;
    //            self.maximumZoomScale = self.frame.size.height/imgViewHeight;
    //            scaleOriginRect = (CGRect){0,self.frame.size.height/2-imgViewHeight/2,self.frame.size.width,imgViewHeight};
    //        }
    //        return;
    //    }
    CGSize curSize = self.frame.size;
    CGFloat width = initRect.size.width;
    CGFloat height = initRect.size.height;
    scaleOriginRect = CGRectMake((curSize.width - width) / 2,(curSize.height - height) / 2, width, height);
}

- (void)setImagePath:(NSString *)imagePath
{
    //    if (imagePath)
    //    {
    if (_loadImageV.hidden == YES) {
        _loadImageV.hidden = NO;
    }
    imgView.image = self.thumbnailImage;
    imgSize = imgView.image.size;
    if (imgSize.width == 0 || imgSize.height == 0) {
        return;
    }
    float scaleX = self.frame.size.width/imgSize.width;
    float scaleY = self.frame.size.height/imgSize.height;
    if (scaleX > scaleY)
    {
        float imgViewWidth = imgSize.width*scaleY;
        self.maximumZoomScale = self.frame.size.width/imgViewWidth;
        scaleOriginRect = (CGRect){self.frame.size.width/2-imgViewWidth/2,0,imgViewWidth,self.frame.size.height};
    }
    else
    {
        float imgViewHeight = imgSize.height*scaleX;
        self.maximumZoomScale = self.frame.size.height/imgViewHeight;
        scaleOriginRect = (CGRect){0,self.frame.size.height/2-imgViewHeight/2,self.frame.size.width,imgViewHeight};
        self.zoomScale = 1.0;
    }
    
    [UIView animateWithDuration:0.6
                     animations:^{
                         [self setAnimationRect];
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
    //        [imgView sd_setImageWithURL:[NSURL URLWithString:[Utility webPathWithPath:imgPath]] placeholderImage:self.thumbnailImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    //            [_loadImageV.layer removeAllAnimations];
    //            [_loadImageV removeFromSuperview];
    //
    //            imgSize = imgView.image.size;
    //            if (imgSize.width == 0 || imgSize.height == 0) {
    //                return;
    //            }
    //            float scaleX = self.frame.size.width/imgSize.width;
    //            float scaleY = self.frame.size.height/imgSize.height;
    //            if (scaleX > scaleY)
    //            {
    //                float imgViewWidth = imgSize.width*scaleY;
    //                self.maximumZoomScale = self.frame.size.width/imgViewWidth;
    //                scaleOriginRect = (CGRect){self.frame.size.width/2-imgViewWidth/2,0,imgViewWidth,self.frame.size.height};
    //            }
    //            else
    //            {
    //                float imgViewHeight = imgSize.height*scaleX;
    //                self.maximumZoomScale = self.frame.size.height/imgViewHeight;
    //                scaleOriginRect = (CGRect){0,self.frame.size.height/2-imgViewHeight/2,self.frame.size.width,imgViewHeight};
    //                self.zoomScale = 1.0;
    //            }
    //
    //            [UIView animateWithDuration:0.6
    //                             animations:^{
    //                                 [self setAnimationRect];
    //                             }
    //                             completion:^(BOOL finished){
    //
    //                             }];
    //
    //        }];
    //    }
    
}


#pragma mark - scroll delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imgView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGSize boundsSize = scrollView.bounds.size;
    CGRect imgFrame = imgView.frame;
    CGSize contentSize = scrollView.contentSize;
    CGPoint centerPoint = CGPointMake(contentSize.width/2, contentSize.height/2);
    
    if (imgFrame.size.width <= boundsSize.width) {
        centerPoint.x = boundsSize.width/2;
    }
    if (imgFrame.size.height <= boundsSize.height) {
        centerPoint.y = boundsSize.height/2;
    }
    imgView.center = centerPoint;
}

#pragma mark -
#pragma mark - touch
- (void)clickMethod:(UIGestureRecognizer *)tap//点击放大图片效果的过程
{
    [self.parent tapImageViewTappedWithObject:self];
}


//#pragma mark - actionSheet delegate
//-(void)actionSheet:(LEActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    /*
//    switch (buttonIndex) {
//        case 0:
//            ;
//            [self forwardBlackboardImage];
//            break;
//
//        case 1:
//            ;
//            [self savePhoto];
//            break;
//
//        case 2:
//            ;
//            [self collectBlackboardImage];
//            break;
//
//        default:
//            break;
//    } */
//    switch (buttonIndex)
//    {
//        case 0:
//            [self savePhoto];
//            break;
//        case 1:
//            [self recognizeQR];
//            break;
//        default:
//            break;
//    }
//}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSString *iTunesLink = [NSString stringWithFormat:@"%@",alertView.message];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
    }
}

-(void)startAnimation
{
    CABasicAnimation *rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 2;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 10000000000;
    [_loadImageV.layer addAnimation:rotationAnimation forKey:@"loadingAnimation"];
}

@end
