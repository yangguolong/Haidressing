//
//  YZMPSViewController.m
//  Hairdressing
//
//  Created by Yangjiaolong on 16/4/12.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "YZMPSViewController.h"
#import "YZMPSViewModel.h"
#import "UIView+Snapshot.h"
#include "ImageProcessor.h"
#import "UIView+ShowHUD.h"

@interface YZMPSViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *displayImage;

@property (nonatomic,strong,readonly) YZMPSViewModel * viewModel;


@property (weak, nonatomic) UIImage *oldImage;


@property (nonatomic,assign)int imageW;

@property (nonatomic,assign)int imageH;


@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *levelbuttons;

@property (nonatomic,assign) int whitenLevel;
@property (nonatomic,assign) int skinLevel;
@end

#define Mask8(x) ( (x) & 0xFF )
#define R(x) ( Mask8(x) )
#define G(x) ( Mask8(x >> 8 ) )
#define B(x) ( Mask8(x >> 16) )
#define A(x) ( Mask8(x >> 24) )
#define RGBAMake(r, g, b, a) ( Mask8(r) | Mask8(g) << 8 | Mask8(b) << 16 | Mask8(a) << 24 )

@implementation YZMPSViewController
@dynamic viewModel;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    [self setNavigationItems];
  
    self.oldImage = self.viewModel.captureImage;
    self.displayImage.image = self.viewModel.captureImage;
    
    _whitenLevel = 1;
    _skinLevel = 1;
    
    @weakify(self)
    [RACObserve(self, displayImage.image) subscribeNext:^(UIImage * image) {
        @strongify(self)
        self.viewModel.captureImage = image;
    }];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    UIImage * shapImage = [self.displayImage imageByRenderingView];
    self.viewModel.captureImage = shapImage;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setNavigationItems{
    
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage createImageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage createImageWithColor:[UIColor clearColor]]];
    UIButton * leftItembt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    leftItembt.layer.cornerRadius = 22;
    [leftItembt setImage:[UIImage imageNamed:@"sf_btn_back1"] forState:UIControlStateNormal];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftItembt];
    self.navigationItem.leftBarButtonItem = leftItem;
    [[leftItembt rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    
    UIButton * rightItembt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    rightItembt.layer.cornerRadius = 22;
    [rightItembt setImage:[UIImage imageNamed:@"sf_btn_yes"] forState:UIControlStateNormal];
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightItembt];
    self.navigationItem.rightBarButtonItem = rightItem;

    rightItembt.rac_command = self.viewModel.nextStepCommamd;

}

- (IBAction)levelButtonClick:(UIButton *)sender {
    
    [_levelbuttons setValue:@(NO) forKeyPath:@"selected"];
    
    sender.selected = YES;
    _skinLevel = sender.tag * 2 / 10.f * 15.f;
    _whitenLevel = fmaxf(2.0,sender.tag * 2 / 10.f * 10.f);
    
    [self.navigationController.view showHUD];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self starImageProgress];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController.view hideHUD];
        });
    });
    
}
-(void)starImageProgress{
    DLog(@"美颜开始 >>>>>>>");
    UIImage * image = _oldImage;
    
    //    CGBitmapContextGetData
    _imageW = image.size.width;
    _imageH = image.size.height;
    
    
    unsigned char * f =  [self logPixelsOfImage:image]; //[self fourToThire:cpath];
    
    unsigned char * t = (unsigned char *)malloc(_imageW * _imageH * 3 * sizeof(unsigned char));
    
    
    SkinWhiteningUseLogCurve(f, f, (int)image.size.width, (int)image.size.height, (int)(image.size.width * 3),_whitenLevel);
    
    DermabrasionFilter(f, t, (int)image.size.width, (int)image.size.height, (int)(image.size.width * 3),_skinLevel);
    
    
    
    CGColorSpaceRef colorSpace =     CGColorSpaceCreateDeviceRGB();
    CGImageRef inputCGImage = [image CGImage];
    NSUInteger width =                 CGImageGetWidth(inputCGImage);
    NSUInteger height = CGImageGetHeight(inputCGImage);
    
    // 2.
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel *     width;
    NSUInteger bitsPerComponent = 8;
    
    UInt32 * pixels;
    pixels = (UInt32 *) calloc(height * width, sizeof(UInt32));
    
    int l = 0;
    
    UInt32 * acurrentPixel = pixels;
    
    for (NSUInteger j = 0; j < _imageH; j++) {
        for (NSUInteger i = 0; i < _imageW; i++) {
            
            UInt32 newR = t[l++]; //R(inputColor) * (1 - ghostAlpha) + R(ghostColor) * ghostAlpha;
            UInt32 newG =  t[l++];//G(inputColor) * (1 - ghostAlpha) + G(ghostColor) * ghostAlpha;
            UInt32 newB =  t[l++];// B(inputColor) * (1 - ghostAlpha) + B(ghostColor) * ghostAlpha;
            
            
            *pixels = RGBAMake(newR, newG, newB, A(255));
            pixels ++;
            
        }
    }
    
    
    CGContextRef context =     CGBitmapContextCreate( acurrentPixel, width, height, bitsPerComponent, bytesPerRow, colorSpace,kCGImageAlphaNoneSkipLast | kCGBitmapByteOrder32Big);
    CGImageRef newimageref = CGBitmapContextCreateImage(context);
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIImage * aImage = [UIImage imageWithCGImage:newimageref];
        _displayImage.image = aImage;
    });
    
    free(f);
    free(t);
    free(acurrentPixel);
    
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    DLog(@"美颜结束>>>>  ");
}


- (UIImage *)processUsingPixels:(unsigned char *)inputImage {
    
    // 1. Get the raw pixels of the image
    UInt32 * inputPixels;
    
    //    CGImageRef inputCGImage = [inputImage CGImage];
    NSUInteger inputWidth = _imageW; //CGImageGetWidth(inputCGImage);
    NSUInteger inputHeight =_imageH; // CGImageGetHeight(inputCGImage);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    NSUInteger bytesPerPixel = 4;
    NSUInteger bitsPerComponent = 8;
    
    NSUInteger inputBytesPerRow = bytesPerPixel * inputWidth;
    
    inputPixels = (UInt32 *)calloc(inputHeight * inputWidth, sizeof(UInt32));
    
    CGContextRef context = CGBitmapContextCreate(inputPixels, inputWidth, inputHeight,
                                                 bitsPerComponent, inputBytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    //    CGContextDrawImage(context, CGRectMake(0, 0, inputWidth, inputHeight), inputCGImage);
    
    // 2. Blend the ghost onto the image
    UIImage * ghostImage = [UIImage imageNamed:@"ghost"];
    CGImageRef ghostCGImage = [ghostImage CGImage];
    
    // 2.1 Calculate the size & position of the ghost
    CGFloat ghostImageAspectRatio = ghostImage.size.width / ghostImage.size.height;
    NSInteger targetGhostWidth = inputWidth * 0.25;
    CGSize ghostSize = CGSizeMake(targetGhostWidth, targetGhostWidth / ghostImageAspectRatio);
    CGPoint ghostOrigin = CGPointMake(inputWidth * 0.5, inputHeight * 0.2);
    
    // 2.2 Scale & Get pixels of the ghost
    NSUInteger ghostBytesPerRow = bytesPerPixel * ghostSize.width;
    
    UInt32 * ghostPixels = (UInt32 *)calloc(ghostSize.width * ghostSize.height, sizeof(UInt32));
    
    CGContextRef ghostContext = CGBitmapContextCreate(ghostPixels, ghostSize.width, ghostSize.height,
                                                      bitsPerComponent, ghostBytesPerRow, colorSpace,
                                                      kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGContextDrawImage(ghostContext, CGRectMake(0, 0, ghostSize.width, ghostSize.height),ghostCGImage);
    
    // 2.3 Blend each pixel
    NSUInteger offsetPixelCountForInput = ghostOrigin.y * inputWidth + ghostOrigin.x;
    for (NSUInteger j = 0; j < ghostSize.height; j++) {
        for (NSUInteger i = 0; i < ghostSize.width; i++) {
            UInt32 * inputPixel = inputPixels + j * inputWidth + i + offsetPixelCountForInput;
            UInt32 inputColor = *inputPixel;
            
            UInt32 * ghostPixel = ghostPixels + j * (int)ghostSize.width + i;
            UInt32 ghostColor = *ghostPixel;
            
            // Blend the ghost with 50% alpha
            CGFloat ghostAlpha = 0.5f * (A(ghostColor) / 255.0);
            UInt32 newR = R(inputColor) * (1 - ghostAlpha) + R(ghostColor) * ghostAlpha;
            UInt32 newG = G(inputColor) * (1 - ghostAlpha) + G(ghostColor) * ghostAlpha;
            UInt32 newB = B(inputColor) * (1 - ghostAlpha) + B(ghostColor) * ghostAlpha;
            
            //Clamp, not really useful here :p
            newR = MAX(0,MIN(255, newR));
            newG = MAX(0,MIN(255, newG));
            newB = MAX(0,MIN(255, newB));
            
            *inputPixel = RGBAMake(newR, newG, newB, A(inputColor));
        }
    }
    
    // 3. Convert the image to Black & White
    for (NSUInteger j = 0; j < inputHeight; j++) {
        for (NSUInteger i = 0; i < inputWidth; i++) {
            UInt32 * currentPixel = inputPixels + (j * inputWidth) + i;
            UInt32 color = *currentPixel;
            
            // Average of RGB = greyscale
            UInt32 averageColor = (R(color) + G(color) + B(color)) / 3.0;
            
            *currentPixel = RGBAMake(averageColor, averageColor, averageColor, A(color));
        }
    }
    
    // 4. Create a new UIImage
    CGImageRef newCGImage = CGBitmapContextCreateImage(context);
    UIImage * processedImage = [UIImage imageWithCGImage:newCGImage];
    
    // 5. Cleanup!
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    CGContextRelease(ghostContext);
    free(inputPixels);
    free(ghostPixels);
    
    return processedImage;
}
//#undef RGBAMake
//#undef R
//#undef G
//#undef B
//#undef A
//#undef Mask8


- (unsigned char *)logPixelsOfImage:(UIImage*)image {
    // 1. Get pixels of image
    CGImageRef inputCGImage = [image CGImage];
    NSUInteger width = CGImageGetWidth(inputCGImage);
    NSUInteger height = CGImageGetHeight(inputCGImage);
    
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    
    UInt32 * pixels;
    pixels = (UInt32 *) calloc(height * width, sizeof(UInt32));
    unsigned char * scr = (unsigned char *)calloc(height*width *3 ,sizeof(unsigned char));
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixels, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast|kCGBitmapByteOrder32Big);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), inputCGImage);
    
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
#define Mask8(x) ( (x) & 0xFF )
#define R(x) ( Mask8(x) )
#define G(x) ( Mask8(x >> 8 ) )
#define B(x) ( Mask8(x >> 16) )
    
    // 2. Iterate and log!
    //    NSLog(@"Brightness of image:");
    int index = 0;
    UInt32 * currentPixel = pixels;
    for (NSUInteger j = 0; j < height; j++) {
        for (NSUInteger i = 0; i < width; i++) {
            UInt32 color = *currentPixel;
            scr[index++] = R(color);
            scr[index++] = G(color);
            scr[index++] = B(color);
            //            scr[index++] = 255;
            //            printf("%3.0f ", (R(color)+G(color)+B(color))/3.0);
            currentPixel++;
        }
        //        printf("\n");
    }
    
    free(pixels);
    
#undef R
#undef G
#undef B
    
    return scr;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
