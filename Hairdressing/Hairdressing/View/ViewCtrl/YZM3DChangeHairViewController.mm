//
//  YZM3DChangeHairViewController.m
//  Hairdressing
//
//  Created by Yangjiaolong on 16/4/12.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "YZM3DChangeHairViewController.h"
#include "HairEngine.h"
#import <OpenGLES/EAGL.h>
#import <GLKit/GLKit.h>
#import "AppDelegate.h"
#import "YZM3DChangeHairViewModel.h"
@interface YZM3DChangeHairViewController ()<GLKViewDelegate>{
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

@property (weak, nonatomic) IBOutlet GLKView *glView;

@property (nonatomic,strong)YZM3DChangeHairViewModel * viewModel;
@end

@implementation YZM3DChangeHairViewController
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self getHairstyleLibrary];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    if (![EAGLContext setCurrentContext:self.context])
    {
        NSLog(@"Rendering: Failed to set current OpenGL context\n");
        
    }
    
    _IsInAdjustHairMode = YES;
    
    
    self.glView.context = self.context;
    self.glView.delegate = self;
    self.glView.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    [self.glView setMultipleTouchEnabled:YES];
    
    
    //    self.preferredFramesPerSecond = 60;
    
    CADisplayLink * displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(drawFrame)];
    // with the frameInterval 0 = max speed , 100 = slow
    displayLink.frameInterval = 2;
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _hairEngine = [appDelegate getHairEngine];
    
    self.glView.enableSetNeedsDisplay = YES;
    DLog(@"viewDidLoad   %@",self.view);

    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    DLog(@"viewWillAppear   %@",self.view);
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    DLog(@"viewDidAppear    %@",self.view);
    _hairEngine->initViewer(self.glView.frame.size.width, self.glView.bounds.size.height);
    
    [self initData];
    
    NSString * hairLibDir = [[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"AppData"] stringByAppendingPathComponent:@"HairstyleLib"];
    NSString * hairStyleDir = [hairLibDir  stringByAppendingPathComponent:[NSString stringWithFormat:@"%d", ((NSNumber *)[self.hairstyleDirArray objectAtIndex:1]).intValue]];
    const char * hairStyleDirChar = [hairStyleDir UTF8String];
    _hairEngine->setHairDir(hairStyleDirChar);
    
}
-(void)drawFrame{
    [self.glView setNeedsDisplay];
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    
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

#pragma mark - GLViewDelegate
-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    
    _hairEngine->render();
    
    
}
- (float)distanceFromPoint:(CGPoint)pointA toPoint:(CGPoint)pointB
{
    float dx = pointA.x - pointB.x;
    float dy = pointA.y - pointB.y;
    return sqrtf(dx * dx + dy * dy);
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
        
        //        if(_IsInAdjustHairMode)
        //        {
//        _HairPositionAdjustX += 0.05 * xDistance;
//        _HairPositionAdjustY -= 0.05 * yDistance;
//        _hairEngine->adjustHairPosition(_HairPositionAdjustX, _HairPositionAdjustY, _HairPositionAdjustZ, _HairScale);
        //        }
        //        else
        //        {
                    _RotateX += 0.003 * xDistance / M_PI * 180;
                    _RotateY += 0.003 * yDistance / M_PI * 180;
                    _hairEngine->setTransform(_RotateX, _RotateY, _Scale);
        //        }
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
        
        //        if(_IsInAdjustHairMode)
        //        {
//        _HairScale += 0.0008 * (curDistance - lastDistance);
//        _hairEngine->adjustHairPosition(_HairPositionAdjustX, _HairPositionAdjustY, _HairPositionAdjustZ, _HairScale);
        //        }
        //        else
        //        {
                    _Scale += 0.002 * (curDistance - lastDistance);
                    _hairEngine->setTransform(_RotateX, _RotateY, _Scale);
        //        }
    }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
