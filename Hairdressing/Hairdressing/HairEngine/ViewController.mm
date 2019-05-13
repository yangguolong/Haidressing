//
//  ViewController.m
//  HairTest
//
//  Created by Yangjiaolong on 16/4/6.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "ViewController.h"
#import "HairEngine.h"
#import "AppDelegate.h"
#import "PaintView.h"
#import "TouchPoint.h"
#import <OpenGLES/EAGL.h>
#import "RenderViewController.h"
#import "UIView+Snapshot.h"

static NSString* const kSDFileSelectionDirectory = @"work";

@interface ViewController ()<PaintViewDelegate>
{
    HairEngine * _hairEngine;
    unsigned char * _InputImageData;
    int _InputImageWidth;
    int _InputImageHeight;
    HEContour * _ContourForHair;
    EAGLContext * _GLContext;

    float _ScaleFactor;
    float _PhotoWidth;
    float _PhotoHeight;
    
    bool _AlreadyGenHeadData;
    bool _IsGenHeadDataSuccess;
}
@property(nonatomic,strong)UIImage * inputImage;
@property (strong, nonatomic) UIImageView *photoImageView;

@property (nonatomic,strong) PaintView * paintView;

@property (strong, nonatomic)  UIImageView *maskImageView;
@property (nonatomic,strong) UIView * interactionView;
@end

struct PSPoint {
    int x, y;
};


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _hairEngine = [appDelegate getHairEngine];
    self.inputImage = [UIImage imageNamed:@"020.jpg"];
    [self processInputImage];
    [self initUI];
    [self initPaintSelection];
    
    _AlreadyGenHeadData = NO;
    _IsGenHeadDataSuccess = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self generateHeadGeometryData];
    });
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)initUI
{
    _PhotoWidth = self.inputImage.size.width;
    _PhotoHeight = self.inputImage.size.height;
    printf("PS Photo width = %d height = %d\n", (int)_PhotoWidth, (int)_PhotoHeight);
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    float widthScreen = screenRect.size.width;
    float heightScreen = screenRect.size.height;
    float sizeFactor = 0.96f;
    float rstWidth, rstHeight;
    
    float widthPhoto = _PhotoWidth;
    float heightPhoto = _PhotoHeight;
    
    float radioPhoto = widthPhoto / heightPhoto;
    float radioScreen = widthScreen / heightScreen;
    
    if(radioPhoto > radioScreen)
    {
        rstWidth =  widthScreen * sizeFactor;
        rstHeight = rstWidth / radioPhoto;
        _ScaleFactor = widthPhoto / rstWidth;
    }
    else
    {
        rstHeight = heightScreen * sizeFactor;
        rstWidth =  rstHeight * radioPhoto;
        _ScaleFactor = heightPhoto / rstHeight;
    }
    
    printf("(%f %f) _ScaleFactor = %f\n", rstWidth, rstHeight, _ScaleFactor);
    
    CGRect rstRect = CGRectMake((widthScreen - rstWidth) / 2.0f, (heightScreen - rstHeight) / 2.0f, rstWidth, rstHeight);
    
//    self.baseView = [[[ACMagnifyingView alloc] initWithFrame:self.view.bounds] autorelease];
//    [self.baseView setBackgroundColor:[UIColor clearColor]];
//    ACLoupe *loupe = [[[ACLoupe alloc] init] autorelease];
//    self.baseView.magnifyingGlass = loupe;
//    loupe.scaleAtTouchPoint = YES;
//    [self.view insertSubview:self.baseView atIndex:0];
    
    self.interactionView = [[UIView alloc] initWithFrame:rstRect];
    [self.view insertSubview:self.interactionView atIndex:0];
//    [self.baseView insertSubview:self.interactionView atIndex:0];
    
    self.maskImageView = [[UIImageView alloc] initWithFrame:self.interactionView.bounds];
    self.maskImageView.image = nil;
    [self.interactionView insertSubview:self.maskImageView atIndex:0];
    
    self.paintView = [[PaintView alloc] initWithFrame:self.interactionView.bounds];
    [self.paintView useTools:BRUSH_RED];
    self.paintView.delegate = self;
    [self.interactionView insertSubview:self.paintView atIndex:0];
    
    self.photoImageView = [[UIImageView alloc] initWithFrame:rstRect];
    self.photoImageView.image = self.inputImage;
//    CALayer * layer = self.photoImageView.layer;
//    [layer setShadowColor:[[UIColor blackColor] CGColor]];
//    [layer setShadowOffset:CGSizeMake(-1, 5)];
//    [layer setShadowRadius:15.0f];
//    [layer setShadowOpacity:0.4f];
    //[self.baseView insertSubview:self.photoImageView atIndex:0];
    [self.view insertSubview:self.photoImageView atIndex:0];

}

- (void)processInputImage
{
    NSString * photoDirectory = [self photoDirectory];
    NSString * imageName = [[photoDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"inputImage"]] stringByAppendingPathExtension:@"png"];
    NSData * photoData = UIImagePNGRepresentation(self.inputImage);
    bool isSuccess = [[NSFileManager defaultManager] createFileAtPath:imageName contents:photoData attributes:nil];
    if(!isSuccess)
        NSLog(@"\nfailed. to save inputImage\n%@\n",imageName);
    
    //get imageData
    self.inputImage = [UIImage imageWithContentsOfFile:imageName];
    int bytesPerPixel = 4;
    int bitsPerComponent = 8;
    
    CGImageRef imageRef = [self.inputImage CGImage];
    int width = self.inputImage.size.width;
    int height = self.inputImage.size.height;
    
    printf("input image after processed: (%d %d)\n", width, height);
    
    unsigned char * rawData = new unsigned char[height * width * bytesPerPixel];
    
    int bytesPerRow = bytesPerPixel * width;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rawData, width, height, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    _InputImageData = rawData;
    _InputImageWidth = width;
    _InputImageHeight = height;
}
-(void)generateHeadGeometryData
{
    _AlreadyGenHeadData = NO;
    _IsGenHeadDataSuccess = YES;
    _IsGenHeadDataSuccess = _hairEngine->finishStrokeStep1();
    dispatch_sync(dispatch_get_main_queue(), ^{
//        [self.featureButton setHidden:NO];
    });
    _AlreadyGenHeadData = YES;
}
- (void)initPaintSelection
{
    NSString * workDir = [self photoDirectory];
    const char * workDirChar = [workDir UTF8String];
    
    _hairEngine->setImage(_InputImageData, _InputImageWidth, _InputImageHeight, workDirChar);
    
    //_maskArrayForHair = NULL;
    _ContourForHair = NULL;
}


-(void)didDrawOneStroke:(id)sender
{
    PaintingTools toolIndex;
    NSMutableArray * rstArray = [self.paintView generatePointsWithPaintingToolsIndex:toolIndex];
    [self.paintView clearView];
    
    PSPoint * pointsArray = [self transformPointsArray:rstArray];
    bool isForHair = (toolIndex == BRUSH_RED);
    
    if(toolIndex == BRUSH_RED || toolIndex == ERASER)
        //_maskArrayForHair = _HairEngine->addStroke((isForHair?1:0), rstArray.count, (int *)pointsArray);
        _ContourForHair = _hairEngine->addStroke((isForHair?1:0), (int)rstArray.count, (int *)pointsArray);
    
    //[self drawMaskWithHairMask:_maskArrayForHair Width:_PhotoWidth Height:_PhotoHeight];
    [self drawContourWithHairContour:_ContourForHair Width:_PhotoWidth Height:_PhotoHeight];
    delete [] pointsArray;
}
- (void)drawContourWithHairContour:(const HEContour *)hairContour Width:(int)imageWidth Height:(int)imageHeight
{
    int bitmapByteCount;
    int	bitmapBytesPerRow;
    
    bitmapBytesPerRow = (imageWidth * 4);
    bitmapByteCount = (bitmapBytesPerRow * imageHeight);
    void * thecacheBitmap = malloc( bitmapByteCount );
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef thecacheContext = CGBitmapContextCreate (thecacheBitmap, imageWidth, imageHeight, 8, bitmapBytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast);
    CGContextSetBlendMode(thecacheContext, kCGBlendModeNormal);
    CGContextSetStrokeColorWithColor(thecacheContext, [[UIColor redColor] CGColor]);
    float lineWidth = 3.0f / _ScaleFactor;
    CGContextSetLineWidth(thecacheContext, (lineWidth > 3.0f)?lineWidth:3.0f);
    
    CGContextClearRect(thecacheContext, CGRectMake(0, 0, imageWidth, imageHeight));
    HEPointF * pointPtr = hairContour->contourPoints;
    for(int i=0; i<hairContour->contourNum; i++)
    {
        int num = hairContour->contourPointNumArray[i];
        CGContextMoveToPoint(thecacheContext, pointPtr[0].x, imageHeight - pointPtr[0].y);
        for(int j=0; j<num; j++)
        {
            HEPointF nextPoint = pointPtr[(j+1) % num];
            CGContextAddLineToPoint(thecacheContext, nextPoint.x, imageHeight - nextPoint.y);
        }
        CGContextClosePath(thecacheContext);
        CGContextStrokePath(thecacheContext);
        
        pointPtr += num;
    }
    
    CGImageRef imgRef = CGBitmapContextCreateImage(thecacheContext);
    UIImage * img = [UIImage imageWithCGImage:imgRef];
    CGImageRelease(imgRef);
    CGContextRelease(thecacheContext);
    CGColorSpaceRelease(colorSpace);
    free(thecacheBitmap);
    
    self.maskImageView.image = img;
    [self.maskImageView setHidden:NO];
    //[self.maskImageView1 setHidden:YES];
}


#pragma mark - logic method

- (PSPoint *)transformPointsArray:(NSMutableArray *)array
{
    int size = (int)array.count;
    PSPoint * rstArray = new PSPoint[size];
    
    TouchPoint * touchPoint;
    CGPoint cgPoint;
    for(int i=0;i<size;i++)
    {
        touchPoint = (TouchPoint *)[array objectAtIndex:i];
        cgPoint = [touchPoint getTouchPoint];
        rstArray[i].x = (int)(cgPoint.x * _ScaleFactor);
        rstArray[i].y = (int)(cgPoint.y * _ScaleFactor);
    }
    
    return rstArray;
}
-(void)doProcessing
{
    CFAbsoluteTime startTime, endTime;
    startTime = CFAbsoluteTimeGetCurrent();
    
    while(!_AlreadyGenHeadData)
        sleep(5);
    
    if(!_IsGenHeadDataSuccess)
    {
//        [self performSelectorOnMainThread:@selector(showNoFaceDetcted) withObject:nil waitUntilDone:NO];
        return;
    }
    
    printf("start to gen texture.\n");
    
    EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES2;
    _GLContext = [[EAGLContext alloc] initWithAPI:api];
    if (!_GLContext)
    {
        NSLog(@"PS UI:Failed to initialize OpenGLES 2.0 context\n");
        exit(1);
    }
    if (![EAGLContext setCurrentContext:_GLContext])
    {
        NSLog(@"PS UI: Failed to set current OpenGL context\n");
        exit(1);
    }
    
//    float val = [self.textField.text floatValue];
    _hairEngine->finishStrokeStep2(0.0);
    
    endTime = CFAbsoluteTimeGetCurrent();
    printf("finishStroke: %f s\n", endTime - startTime);
    UIImage * snapshot = [self.view imageByRenderingView];
    RenderViewController * renderViewCtrl = [[RenderViewController alloc]initWithNibName:@"RenderViewController" bundle:nil];
    renderViewCtrl.snapshot = snapshot;
//    [self performSelectorOnMainThread:@selector(hideControlBar) withObject:nil waitUntilDone:YES];
//    [self performSelectorOnMainThread:@selector(moveToRenderingModule) withObject:nil waitUntilDone:NO];
    
    [self presentViewController:renderViewCtrl animated:YES completion:nil];
    
}

- (NSString *)photoDirectory {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask ,YES);
    NSString *documentsDirectory = paths[0];
    NSString * drawingsDirectory = [documentsDirectory stringByAppendingPathComponent:kSDFileSelectionDirectory];
    return drawingsDirectory;
}
- (IBAction)next:(id)sender {
    

    [self doProcessing];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
