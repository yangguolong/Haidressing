//
//  RenderViewController.m
//  HairTest
//
//  Created by Yangjiaolong on 16/4/8.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "RenderViewController.h"
#import "HairEngine.h"
#import <OpenGLES/EAGL.h>
#import <GLKit/GLKit.h>
#import "AppDelegate.h"
@interface RenderViewController ()
{
    float _RotateX;
    float _RotateY;
    float _Scale;
    
    float _HairPositionAdjustX;
    float _HairPositionAdjustY;
    float _HairPositionAdjustZ;
    float _HairScale;
    bool  _IsInAdjustHairMode;
    
    int _CurrentModelIndex; // start from 1
    
    
    HairEngine * _hairEngine;
}



@property (strong, nonatomic) EAGLContext *context;
@property (nonatomic, retain) NSArray * hairstyleDirArray;

@end

@implementation RenderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    [self.view setFrame:screenBound];
    clock_t startTime, endTime, subStartTime, subEndTime;
    startTime = subStartTime = clock();
    printf("Enter viewDidLoad.\n");

    
    [self getHairstyleLibrary];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    if (![EAGLContext setCurrentContext:self.context])
    {
        NSLog(@"Rendering: Failed to set current OpenGL context\n");
        exit(1);
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    [view setMultipleTouchEnabled:YES];
    self.preferredFramesPerSecond = 60;
    view.enableSetNeedsDisplay = YES;
//    view.drawableMultisample = GLKViewDrawableMultisample4X;
//    view.contentScaleFactor = 2.0f;
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.image = self.snapshot;
    imageView.tag = 123;
//    [self.view addSubview:imageView];
//    _IsSnapshotShowing = 0xff;
    
    subEndTime = clock();
    printf("    step 1: %f s\n", ((float)(subEndTime - subStartTime)) / CLOCKS_PER_SEC);
    
    subStartTime = clock();
    AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _hairEngine = [appDelegate getHairEngine];
    _hairEngine->initViewer(self.view.bounds.size.width, self.view.bounds.size.height);
    
    subEndTime = clock();
    printf("    init renderer: %f s\n", ((float)(subEndTime - subStartTime)) / CLOCKS_PER_SEC);
    
    [self initData];
    // Do any additional setup after loading the view.
}
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{

    _hairEngine->render();

}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
//    if(_IsSnapshotShowing != 0x00)
//        return;
    
    UITouch *touchA, *touchB;
    CGPoint pointA,pointB;
    
    if(touches.count == 1)
    {
        touchA = [[touches allObjects] objectAtIndex:0];
        pointA = [touchA locationInView:self.view];
        pointB = [touchA previousLocationInView:self.view];
        
        float xDistance = pointA.x - pointB.x;
        float yDistance = pointA.y - pointB.y;
        
        if(_IsInAdjustHairMode)
        {
            _HairPositionAdjustX += 0.05 * xDistance;
            _HairPositionAdjustY -= 0.05 * yDistance;
            _hairEngine->adjustHairPosition(_HairPositionAdjustX, _HairPositionAdjustY, _HairPositionAdjustZ, _HairScale);
        }
        else
        {
            _RotateX += 0.003 * xDistance / M_PI * 180;
            _RotateY += 0.003 * yDistance / M_PI * 180;
            _hairEngine->setTransform(_RotateX, _RotateY, _Scale);
        }
    }
    else if(touches.count == 2)
    {
        
        touchA = [[touches allObjects] objectAtIndex:0];
        touchB = [[touches allObjects] objectAtIndex:1];
        
        pointA = [touchA locationInView:self.view];
        pointB = [touchB locationInView:self.view];
        float curDistance = [self distanceFromPoint:pointA toPoint:pointB];
        
        pointA = [touchA previousLocationInView:self.view];
        pointB = [touchB previousLocationInView:self.view];
        float lastDistance = [self distanceFromPoint:pointA toPoint:pointB];
        
        if(_IsInAdjustHairMode)
        {
            _HairScale += 0.0008 * (curDistance - lastDistance);
            _hairEngine->adjustHairPosition(_HairPositionAdjustX, _HairPositionAdjustY, _HairPositionAdjustZ, _HairScale);
        }
        else
        {
            _Scale += 0.002 * (curDistance - lastDistance);
            _hairEngine->setTransform(_RotateX, _RotateY, _Scale);
        }
    }
}
- (float)distanceFromPoint:(CGPoint)pointA toPoint:(CGPoint)pointB
{
    float dx = pointA.x - pointB.x;
    float dy = pointA.y - pointB.y;
    return sqrtf(dx * dx + dy * dy);
}

- (void)initData
{
    _RotateX = 0.0f;
    _RotateY = 0.0f;
    _Scale = 1.0f;
    
    _HairPositionAdjustX = 0.0f;
    _HairPositionAdjustY = 0.0f;
    _HairPositionAdjustZ = 0.0f;
    _HairScale = 1.0f;
    _IsInAdjustHairMode = NO;
    
    _CurrentModelIndex = -1;
    
    _hairEngine->setTransform(_RotateX, _RotateY, _Scale);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
  
}

- (void)getHairstyleLibrary
{
    self.hairstyleDirArray = nil;
    
    NSString * hairLibDir = [[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"AppData"] stringByAppendingPathComponent:@"HairstyleLib"];
    
    NSArray * tmpArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:hairLibDir error:NULL];
    NSMutableArray * container = [[NSMutableArray alloc] init];
    for(NSString * path in tmpArray)
    {
        NSString * fullPath = [hairLibDir stringByAppendingPathComponent:path];
        BOOL isDir = NO;
        if([[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDir])
        {
            
            int index = [path intValue];
            if(index >0)
                [container addObject:[NSNumber numberWithInt:index]];
        }
    }
    self.hairstyleDirArray = [container sortedArrayUsingSelector:@selector(compare:)];
    
}

- (IBAction)buttonClick:(id)sender {
    NSString * hairLibDir = [[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"AppData"] stringByAppendingPathComponent:@"HairstyleLib"];
    NSString * hairStyleDir = [hairLibDir  stringByAppendingPathComponent:[NSString stringWithFormat:@"%d", ((NSNumber *)[self.hairstyleDirArray objectAtIndex:1]).intValue]];
    const char * hairStyleDirChar = [hairStyleDir UTF8String];
    _hairEngine->setHairDir(hairStyleDirChar);

    
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