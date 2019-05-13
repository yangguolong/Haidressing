//
//  VPImageCropperViewController.m
//  dywTerminal
//
//  Created by zx_02 on 15/9/28.
//  Copyright © 2015年 zx_02. All rights reserved.
//

#import "VPImageCropperViewController.h"
#import "UserInfoViewController.h"
//#import "OtherUserInfoViewController.h"
//#import "OtherDynamicViewController.h"
//#import "DynamicViewController.h"
#import "VPImageCropperViewModel.h"
#define SCALE_FRAME_Y 100.0f
#define BOUNDCE_DURATION 0.3f

@interface VPImageCropperViewController ()


@property(nonatomic,strong,readwrite)VPImageCropperViewModel *viewModel;
@end

@implementation VPImageCropperViewController
@dynamic viewModel;
//- (id)initWithImage:(UIImage *)originalImage cropFrame:(CGRect)cropFrame limitScaleRatio:(NSInteger)limitRatio
//{
//    self = [super init];
//    if (self)
//    {
//        self.cropFrame = cropFrame;
//        self.limitRatio = limitRatio;
//        self.originalImage = originalImage;
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"裁剪图片";
    self.cropFrame = self.viewModel.cropFrame;
    self.limitRatio = self.viewModel.limitRatio;
    self.originalImage = self.viewModel.originalImage;
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBarHidden = NO;
//    self.tabBarController.tabBar.hidden = YES;
    UIButton *rightBt = [[UIButton alloc] initWithFrame:CGRectMake(0, 6, 50, 25)];
    [rightBt setTitle:@"获取" forState:UIControlStateNormal];
    [rightBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightBt.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
    [rightBt setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [rightBt addTarget:self action:@selector(btClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBt];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,rightItem, nil];
    
    [self initView];
}
//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = NO;
//    self.tabBarController.tabBar.hidden = YES;
//}
//
//-(void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    self.navigationController.navigationBarHidden = YES;
//    self.tabBarController.tabBar.hidden = NO;
//}

- (void)btClicked
{
    //发出更新头像图片的通知
     [[NSNotificationCenter defaultCenter] postNotificationName:UserUpdateHeadImageNotification object:[self getSubImage]];
    //[self.parent updateUserHead:[self getSubImage]];
    //[self.navigationController popViewControllerAnimated:YES];
    [self.viewModel.services popViewModelAnimated:YES];
}

- (void)initView
{
    self.showImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [self.showImgView setMultipleTouchEnabled:YES];
    [self.showImgView setUserInteractionEnabled:YES];
    [self.showImgView setImage:self.originalImage];
    [self.showImgView setUserInteractionEnabled:YES];
    [self.showImgView setMultipleTouchEnabled:YES];
    self.showImgView.backgroundColor = [UIColor clearColor];
    
    if (DEVICE_IS_IPHONE5) {
        self.showImgView.frame = CGRectMake(0, 0, 320, 568);
    }
    
    CGFloat oriWidth = self.cropFrame.size.width;
    CGFloat oriHeight = self.originalImage.size.height * (oriWidth / self.originalImage.size.width);
    CGFloat oriX = self.cropFrame.origin.x + (self.cropFrame.size.width - oriWidth) / 2;
    CGFloat oriY = self.cropFrame.origin.y + (self.cropFrame.size.height - oriHeight) / 2;
    self.oldFrame = CGRectMake(oriX, oriY, oriWidth, oriHeight);
    self.latestFrame = self.oldFrame;
    self.showImgView.frame = self.oldFrame;
    
    self.largeFrame = CGRectMake(0, 0, self.limitRatio * self.oldFrame.size.width, self.limitRatio * self.oldFrame.size.height);
    
    [self addGestureRecognizers];
    [self.view addSubview:self.showImgView];
    
    self.overlayView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.overlayView.alpha = .5f;
    self.overlayView.backgroundColor = [UIColor blackColor];
    self.overlayView.userInteractionEnabled = NO;
    self.overlayView.autoresizingMask = UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.overlayView];
    
    self.ratioView = [[UIView alloc] initWithFrame:self.cropFrame];
    self.ratioView.autoresizingMask = UIViewAutoresizingNone;
    [self.view addSubview:self.ratioView];
    [self overlayClipping];
}

- (void)overlayClipping
{
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    CGMutablePathRef path = CGPathCreateMutable();
    //图片高度与截取框高度保持一致
    if(self.oldFrame.size.height>=self.cropFrame.size.height)
    {
        CGPathAddRect(path, nil, CGRectMake(0, 0,
                                            self.ratioView.frame.origin.x,
                                            self.overlayView.frame.size.height));
        CGPathAddRect(path, nil, CGRectMake(
                                            self.ratioView.frame.origin.x + self.ratioView.frame.size.width,
                                            0,
                                            self.overlayView.frame.size.width - self.ratioView.frame.origin.x - self.ratioView.frame.size.width,
                                            self.overlayView.frame.size.height));
        CGPathAddRect(path, nil, CGRectMake(0, 0,
                                            self.overlayView.frame.size.width,
                                            self.ratioView.frame.origin.y));
        CGPathAddRect(path, nil, CGRectMake(0,
                                            self.ratioView.frame.origin.y + self.ratioView.frame.size.height,
                                            self.overlayView.frame.size.width,
                                            self.overlayView.frame.size.height - self.ratioView.frame.origin.y + self.ratioView.frame.size.height));
    }else
    {
        //重新赋值
        self.cropFrame = self.oldFrame;
        
        CGPathAddRect(path, nil, CGRectMake(0, 0,
                                            self.oldFrame.origin.x,
                                            self.overlayView.frame.size.height));
        CGPathAddRect(path, nil, CGRectMake(
                                            self.oldFrame.origin.x + self.oldFrame.size.width,
                                            0,
                                            self.overlayView.frame.size.width - self.oldFrame.origin.x - self.oldFrame.size.width,
                                            self.overlayView.frame.size.height));
        CGPathAddRect(path, nil, CGRectMake(0, 0,
                                            self.overlayView.frame.size.width,
                                            self.oldFrame.origin.y));
        CGPathAddRect(path, nil, CGRectMake(0,
                                            self.oldFrame.origin.y + self.oldFrame.size.height,
                                            self.overlayView.frame.size.width,
                                            self.overlayView.frame.size.height - self.oldFrame.origin.y + self.oldFrame.size.height));
    }
    
    
    maskLayer.path = path;
    self.overlayView.layer.mask = maskLayer;
    CGPathRelease(path);
}

- (void)addGestureRecognizers
{
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    [self.view addGestureRecognizer:pinchGestureRecognizer];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [self.view addGestureRecognizer:panGestureRecognizer];
}

- (void) pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    //缩放
    UIView *view = self.showImgView;
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        pinchGestureRecognizer.scale = 1;
    }
    else if (pinchGestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        CGRect newFrame = self.showImgView.frame;
        newFrame = [self handleScaleOverflow:newFrame];
        newFrame = [self handleBorderOverflow:newFrame];
        [UIView animateWithDuration:BOUNDCE_DURATION
                         animations:^{
                             self.showImgView.frame = newFrame;
                             self.latestFrame = newFrame;
                         }];
    }
}

- (void) panView:(UIPanGestureRecognizer *)panGestureRecognizer
{
    //拖动
    UIView *view = self.showImgView;
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        CGFloat absCenterX = self.cropFrame.origin.x + self.cropFrame.size.width / 2;
        CGFloat absCenterY = self.cropFrame.origin.y + self.cropFrame.size.height / 2;
        CGFloat scaleRatio = self.showImgView.frame.size.width / self.cropFrame.size.width;
        CGFloat acceleratorX = 1 - ABS(absCenterX - view.center.x) / (scaleRatio * absCenterX);
        CGFloat acceleratorY = 1 - ABS(absCenterY - view.center.y) / (scaleRatio * absCenterY);
        CGPoint translation = [panGestureRecognizer translationInView:view.superview];
        [view setCenter:(CGPoint){view.center.x + translation.x * acceleratorX, view.center.y + translation.y * acceleratorY}];
        [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
    }
    else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        CGRect newFrame = self.showImgView.frame;
        newFrame = [self handleBorderOverflow:newFrame];
        [UIView animateWithDuration:BOUNDCE_DURATION animations:^{
            self.showImgView.frame = newFrame;
            self.latestFrame = newFrame;
        }];
    }
}

- (CGRect)handleScaleOverflow:(CGRect)newFrame
{
    CGPoint oriCenter = CGPointMake(newFrame.origin.x + newFrame.size.width/2, newFrame.origin.y + newFrame.size.height/2);
    if (newFrame.size.width < self.oldFrame.size.width) {
        newFrame = self.oldFrame;
    }
    if (newFrame.size.width > self.largeFrame.size.width) {
        newFrame = self.largeFrame;
    }
    newFrame.origin.x = oriCenter.x - newFrame.size.width/2;
    newFrame.origin.y = oriCenter.y - newFrame.size.height/2;
    return newFrame;
}

- (CGRect)handleBorderOverflow:(CGRect)newFrame
{
    if (newFrame.origin.x > self.cropFrame.origin.x) newFrame.origin.x = self.cropFrame.origin.x;
    if (CGRectGetMaxX(newFrame) < self.cropFrame.size.width) newFrame.origin.x = self.cropFrame.size.width - newFrame.size.width;
    if (newFrame.origin.y > self.cropFrame.origin.y) newFrame.origin.y = self.cropFrame.origin.y;
    if (CGRectGetMaxY(newFrame) < self.cropFrame.origin.y + self.cropFrame.size.height) {
        newFrame.origin.y = self.cropFrame.origin.y + self.cropFrame.size.height - newFrame.size.height;
    }
    if (self.showImgView.frame.size.width > self.showImgView.frame.size.height && newFrame.size.height <= self.cropFrame.size.height) {
        newFrame.origin.y = self.cropFrame.origin.y + (self.cropFrame.size.height - newFrame.size.height) / 2;
    }
    return newFrame;
}

//获取截图
-(UIImage *)getSubImage
{
    CGRect squareFrame = self.cropFrame;
    
    CGFloat scaleRatio = self.latestFrame.size.width / self.originalImage.size.width;
    CGFloat x = (squareFrame.origin.x - self.latestFrame.origin.x) / scaleRatio;
    CGFloat y = (squareFrame.origin.y - self.latestFrame.origin.y) / scaleRatio;
    CGFloat w = squareFrame.size.width / scaleRatio;
    CGFloat h = squareFrame.size.height / scaleRatio;
    CGRect myImageRect = CGRectMake(x, y, w, h);
    CGImageRef imageRef = self.originalImage.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
    CGSize size;
    size.width = myImageRect.size.width;
    size.height = myImageRect.size.height;
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, myImageRect, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    return smallImage;
}

#pragma mark -
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
