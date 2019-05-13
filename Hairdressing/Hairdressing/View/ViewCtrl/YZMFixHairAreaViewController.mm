//
//  YZMFixHairAreaViewController.m
//  Hairdressing
//
//  Created by Yangjiaolong on 16/4/12.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "YZMFixHairAreaViewController.h"
#include "HairEngine.h"
#import <OpenGLES/EAGL.h>
#import <GLKit/GLKit.h>
#import "AppDelegate.h"
#import "YZMFixHairAreaViewModel.h"
#import "YZMTryHairGuideMask.h"
#import "UIView+MJExtension.h"
#import "YZMHairStyleCell.h"
#import "YZMHairTypeCollectionViewCell.h"
#import "YZMHairTypeModel.h"
#import "YZMCommendCorpCollectionViewCell.h"
#import "UIView+ShowHUD.h"
#import "YZMTryHairShareView.h"
@interface YZMFixHairAreaViewController ()<GLKViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
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
    
    BOOL needrender;
    HairEngine * _hairEngine;

}


@property (strong, nonatomic) EAGLContext *context;
@property (nonatomic, retain) NSArray * hairstyleDirArray;

@property (weak, nonatomic) IBOutlet GLKView *glView;

@property (nonatomic,strong) YZMFixHairAreaViewModel * viewModel;
@property (weak, nonatomic) IBOutlet UIButton *finishButton;
@property (weak, nonatomic) IBOutlet UIView *buttonsView;

@property (weak, nonatomic) IBOutlet UIButton *collectionButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;


@property (weak, nonatomic) IBOutlet UIButton *showCorpButton;

@property (nonatomic,strong) UIImage * imageOfShare;





//################## 发型列表 ###################

@property (weak, nonatomic) IBOutlet UICollectionView *hairTypeCollectionView;

@property (weak, nonatomic) IBOutlet UICollectionView *hairStyleCollectionView;

@property (weak, nonatomic) IBOutlet UICollectionView *corpCollectionView;

//################## 发型列表 ###################


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *corpViewtopConstraint;


@end

@implementation YZMFixHairAreaViewController
@dynamic viewModel;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.hairStyleCollectionView registerNib:[UINib nibWithNibName:@"YZMHairStyleCell" bundle:nil] forCellWithReuseIdentifier:@"YZMHairStyleCell"];
    [self.hairTypeCollectionView registerNib:[UINib nibWithNibName:@"YZMHairTypeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"YZMHairTypeCollectionViewCell"];
    
    [self.corpCollectionView registerNib:[UINib nibWithNibName:@"YZMCommendCorpCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"YZMCommendCorpCollectionViewCell"];
    
    [RACObserve(self.viewModel, hiarStyleList) subscribeNext:^(id x) {
        [self.hairStyleCollectionView reloadData];
    }];
    [RACObserve(self.viewModel, hiarStyleList) subscribeNext:^(id x) {
       
        [self.hairTypeCollectionView reloadData];
    }];
    
    [RACObserve(self.viewModel, corpList) subscribeNext:^(id x) {
        [self.corpCollectionView reloadData];
    }];
    self.finishButton.rac_command = self.viewModel.finishCommand;
    
    
    [self.viewModel.didSelectHairStyleCommand.executionSignals.switchToLatest subscribeNext:^(NSString *  dir) {
       
        DLog(@"xxxxx %@",dir);
        
        _hairEngine->setHairDir([dir fileSystemRepresentation]);
    }];
    [self.viewModel.didSelectHairStyleCommand.errors subscribeNext:^(id x) {
       
        [self.navigationController.view showHUDWith:@"下载失败" hideAfterDelay:1.5];
        
    }];
    
    [[self.showCorpButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton * x) {
        x.selected = !x.selected;
        self.corpViewtopConstraint.constant = self.showCorpButton.selected ? 125 : 0;
        [self.view layoutIfNeeded];
    }];

    [self initHairEngine];
    
    [self setNavigationItems];
    
    [self addGesture];
    
    
    // Do any additional setup after loading the view.
}

#pragma mark - cyclelive
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    needrender = YES;
    _hairEngine->initViewer(self.glView.frame.size.width, self.glView.bounds.size.height);
    
    [self initData];
    
    NSString * hairLibDir = [[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"AppData"] stringByAppendingPathComponent:@"HairstyleLib"];
    NSString * hairStyleDir = [hairLibDir  stringByAppendingPathComponent:[NSString stringWithFormat:@"%d", ((NSNumber *)[self.hairstyleDirArray lastObject]).intValue]];
    const char * hairStyleDirChar = [hairStyleDir UTF8String];
    _hairEngine->setHairDir(hairStyleDirChar);
    
    [YZMTryHairGuideMask show];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage createImageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage createImageWithColor:[UIColor clearColor]]];
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _hairEngine ->closeViewer();
    [EAGLContext setCurrentContext:nil];
    self.context = nil;
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    
}

-(void)setNavigationItems{
    
   
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
    [rightItembt setImage:[UIImage imageNamed:@"sf_btn_share"] forState:UIControlStateNormal];
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightItembt];
    self.navigationItem.rightBarButtonItem = rightItem;
    [[rightItembt rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [YZMTryHairShareView show];

    }];
    //    rightItembt.rac_command = self.viewModel.nextStepCommamd;
    
}
-(UIImage * )hairEngineSnapshot{
    unsigned char * imageData;
    int width, height;
    imageData = _hairEngine->takeScreenShot(width, height);
    if(imageData == NULL)
    {
        DLog(@"截屏失败");
    }
    else
    {
        int bytesPerPixel = 4;
        int bitsPerComponent = 8;
        int bytesPerRow = bytesPerPixel * width;
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = CGBitmapContextCreate(imageData, width, height, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
        
        UIImage * img;
        CGImageRef rstImgRef = CGBitmapContextCreateImage(context);
        img = [UIImage imageWithCGImage:rstImgRef];
    
//        NSData * pictureData = UIImagePNGRepresentation(img);
        
//        [self saveImageToLibararyWithImageData:pictureData];
        
        CGColorSpaceRelease(colorSpace);
        CGImageRelease(rstImgRef);
        CGContextRelease(context);
    
        return img;
    }
    return nil;
}
-(void)initHairEngine{
    [self getHairstyleLibrary];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    if (![EAGLContext setCurrentContext:self.context])
    {
        NSLog(@"Rendering: Failed to set current OpenGL context\n");
        
    }
    
    
    
    
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
    
}
#pragma mark - CADisplayLink

-(void)drawFrame{
    [self.glView setNeedsDisplay];
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
    _IsInAdjustHairMode = YES;
    
    _CurrentModelIndex = -1;
    
    _hairEngine->setTransform(_RotateX, _RotateY, _Scale);
}

#pragma mark - GLViewDelegate
-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    if (needrender) {
        
        _hairEngine->render();
    }

    
}
- (float)distanceFromPoint:(CGPoint)pointA toPoint:(CGPoint)pointB
{
    float dx = pointA.x - pointB.x;
    float dy = pointA.y - pointB.y;
    return sqrtf(dx * dx + dy * dy);
}


#pragma mark - touchMethod
-(void)addGesture{
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]init];
    pan.maximumNumberOfTouches = 2;
    pan.minimumNumberOfTouches = 1;

  __block  CGPoint pointA,pointB;
    [self.glView addGestureRecognizer:pan];
    [[pan rac_gestureSignal] subscribeNext:^(UIPanGestureRecognizer * aPan) {

        if (aPan.state == UIGestureRecognizerStateBegan) {
            pointB = [aPan locationOfTouch:0 inView:self.view];
            
        }else if (aPan.state == UIGestureRecognizerStateChanged){


            pointA = [aPan locationOfTouch:0 inView:self.view];
            float xDistance = pointA.x - pointB.x;
            float yDistance = pointA.y - pointB.y;
            if (aPan.numberOfTouches == 1) {
                _RotateX += 0.003 * xDistance / M_PI * 180;
                _RotateY += 0.003 * yDistance / M_PI * 180;
                _hairEngine->setTransform(_RotateX, _RotateY, _Scale);

                
            }else if (aPan.numberOfTouches == 2){
                _HairPositionAdjustX += 0.05 * xDistance;
                _HairPositionAdjustY -= 0.05 * yDistance;
                _hairEngine->adjustHairPosition(_HairPositionAdjustX, _HairPositionAdjustY, _HairPositionAdjustZ, _HairScale);
    
            }
            pointB = pointA;
            
        }else if (aPan.state == UIGestureRecognizerStateEnded){
            
        }
        
    }];
    
    UIPinchGestureRecognizer * pinch = [[UIPinchGestureRecognizer alloc]init];
    [self.glView addGestureRecognizer:pinch];
    [[pinch rac_gestureSignal] subscribeNext:^(UIPinchGestureRecognizer * xpinch) {
        if (xpinch.state == UIGestureRecognizerStateBegan) {
            
        }else if (xpinch.state == UIGestureRecognizerStateChanged){
            
            _HairScale += 0.0008 * MIN(( xpinch.scale - (xpinch.scale < 1 ? 2 : 1)),1);
            _hairEngine->adjustHairPosition(_HairPositionAdjustX, _HairPositionAdjustY, _HairPositionAdjustZ, _HairScale);

        }else if (xpinch.state == UIGestureRecognizerStateEnded){
        
        }
    }];
    
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    needrender = YES;

}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    needrender = NO;
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
-(void)dealloc{
    
}


#pragma mark - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
  
    if (collectionView == self.hairTypeCollectionView) {
        return self.viewModel.hairTypeNameList.count;
    }else if (collectionView == self.hairStyleCollectionView){//发型列表
        return self.viewModel.hiarStyleList.count;
    }else if (collectionView == self.corpCollectionView){
        return self.viewModel.corpList.count;
    }
    return 0;
}
-(UICollectionViewCell * )collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView == self.hairTypeCollectionView) {
        YZMHairTypeCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YZMHairTypeCollectionViewCell" forIndexPath:indexPath];
       YZMHairTypeModel * model = self.viewModel.hairTypeNameList[indexPath.row];
        cell.titleLabel.text = model.name;
    
        return cell;
    }else if (collectionView == self.hairStyleCollectionView){//发型列表
        YZMHairStyleCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YZMHairStyleCell" forIndexPath:indexPath];
        [cell configWithModel:self.viewModel.hiarStyleList[indexPath.row]];
        return cell;
    }else if (collectionView == self.corpCollectionView){
        YZMCommendCorpCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YZMCommendCorpCollectionViewCell" forIndexPath:indexPath];
        [cell updateUIWithModel:self.viewModel.corpList[indexPath.row]];
        return cell;
    }
    
    return nil;
}
#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.hairTypeCollectionView) {
        [self.viewModel.didSelecthairTypeCommand execute:indexPath];
    }else if (collectionView == self.hairStyleCollectionView){//发型列表
        [self.viewModel.didSelectHairStyleCommand execute:indexPath];
    }

}
#pragma mark - UICollectionViewDelegateFlowLayout

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    //发型类型列表
    if (collectionView == self.hairTypeCollectionView) {
        return CGSizeMake(100, 30);
    }else if (collectionView == self.hairStyleCollectionView){//发型列表
        return CGSizeMake(60, 60);
    }else if (collectionView == self.corpCollectionView){
        return CGSizeMake(150, 70);
    }
    
    return CGSizeZero;
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