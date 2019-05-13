//
//  AVCaptureManager.m
//  AVCaptureDemo
//
//  Created by Yangjiaolong on 16/4/5.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "AVCaptureManager.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIImage+GK.h"
@interface AVCaptureManager ()

@property (nonatomic,strong) AVCamPreviewView *  previewView;


// Session management.
@property (nonatomic) dispatch_queue_t sessionQueue; // Communicate with the session and other session objects on this queue.
@property (nonatomic) AVCaptureSession *session;
@property (nonatomic) AVCaptureDeviceInput *videoDeviceInput;
@property (nonatomic) AVCaptureMovieFileOutput *movieFileOutput;
@property (nonatomic) AVCaptureStillImageOutput *stillImageOutput;


@property (nonatomic) UIBackgroundTaskIdentifier backgroundRecordingID;

@property (nonatomic, getter = isDeviceAuthorized) BOOL deviceAuthorized;

@property (nonatomic,assign)BOOL vaildCamera;
@end


@implementation AVCaptureManager

-(instancetype)initWithPreviewView:(AVCamPreviewView *)view{
    self = [super init];
    if (self) {
        // Create the AVCaptureSession
        AVCaptureSession *session = [[AVCaptureSession alloc] init];
        [self setSession:session];
        self.previewView = view;
//        self.session = [[AVCaptureSession alloc]init];
//
        self.vaildCamera = [UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera];
        
        [view setSession:self.session];
        AVCaptureVideoPreviewLayer * l= (AVCaptureVideoPreviewLayer *)view.layer;
        l.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [self checkDeviceAuthorizationStatus];
//        l.contentsGravity = kCAGravityResizeAspectFill;
        dispatch_queue_t sessionQueue = dispatch_queue_create("session queue", DISPATCH_QUEUE_SERIAL);
        [self setSessionQueue:sessionQueue];
        dispatch_async(sessionQueue, ^{
            [self setBackgroundRecordingID:UIBackgroundTaskInvalid];
            
            NSError *error = nil;
            
            AVCaptureDevice *videoDevice = [AVCaptureManager deviceWithMediaType:AVMediaTypeVideo preferringPosition:AVCaptureDevicePositionFront];
            AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
            
            if (error)
            {
                NSLog(@"%@", error);
            }
            
            if ([_session canAddInput:videoDeviceInput])
            {
                [_session addInput:videoDeviceInput];
                [self setVideoDeviceInput:videoDeviceInput];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // Why are we dispatching this to the main queue?
                    // Because AVCaptureVideoPreviewLayer is the backing layer for AVCamPreviewView and UIView can only be manipulated on main thread.
                    // Note: As an exception to the above rule, it is not necessary to serialize video orientation changes on the AVCaptureVideoPreviewLayer’s connection with other session manipulation.
                    
                    [[(AVCaptureVideoPreviewLayer *)[view layer] connection] setVideoOrientation:AVCaptureVideoOrientationPortrait];
                    //(AVCaptureVideoOrientation)[self interfaceOrientation]];
                });
            }
            
//            AVCaptureDevice *audioDevice = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];
//            AVCaptureDeviceInput *audioDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:&error];
            
//            if (error)
//            {
//                NSLog(@"%@", error);
//            }
            
//            if ([_session canAddInput:audioDeviceInput])
//            {
//                [_session addInput:audioDeviceInput];
//            }
            
            AVCaptureMovieFileOutput *movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
            if ([_session canAddOutput:movieFileOutput])
            {
                [_session addOutput:movieFileOutput];
                AVCaptureConnection *connection = [movieFileOutput connectionWithMediaType:AVMediaTypeVideo];
                if ([connection isVideoStabilizationSupported])
//                    [connection setEnablesVideoStabilizationWhenAvailable:YES];
                [connection setPreferredVideoStabilizationMode:AVCaptureVideoStabilizationModeAuto];
                [self setMovieFileOutput:movieFileOutput];
            }
            
            AVCaptureStillImageOutput *stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
            if ([_session canAddOutput:stillImageOutput])
            {
                [stillImageOutput setOutputSettings:@{AVVideoCodecKey : AVVideoCodecJPEG}];
                [_session addOutput:stillImageOutput];
                [self setStillImageOutput:stillImageOutput];
            }
        });

    }
    
    return self;
    
}
+ (AVCaptureDevice *)deviceWithMediaType:(NSString *)mediaType preferringPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:mediaType];
    AVCaptureDevice *captureDevice = [devices firstObject];
    
    for (AVCaptureDevice *device in devices)
    {
        if ([device position] == position)
        {
            captureDevice = device;
            break;
        }
    }
    
    return captureDevice;
}
+ (void)setFlashMode:(AVCaptureFlashMode)flashMode forDevice:(AVCaptureDevice *)device
{
    if ([device hasFlash] && [device isFlashModeSupported:flashMode])
    {
        NSError *error = nil;
        if ([device lockForConfiguration:&error])
        {
            [device setFlashMode:flashMode];
            [device unlockForConfiguration];
        }
        else
        {
            NSLog(@"%@", error);
        }
    }
}
-(void)start{
//    	__weak AVCaptureManager *weakSelf = self;
    if (![self.session isRunning]) {
        
        dispatch_async([self sessionQueue], ^{
            // Manually restarting the session since it must have been stopped due to an error.
            [[self session] startRunning];
            
        });
    }
    
}
-(void)stop{

    if ([self.session isRunning]) {
        
        dispatch_async([self sessionQueue], ^{
            // Manually restarting the session since it must have been stopped due to an error.
            [[self session] stopRunning];
            
        });
    }
    
}

-(void)stillImageWithBlock:(void (^)(UIImage *))block{
//  __block  UIImage *image;
    if (!self.vaildCamera) {
        return;
    }
    dispatch_async([self sessionQueue], ^{
        // Update the orientation on the still image output video connection before capturing.
        [[[self stillImageOutput] connectionWithMediaType:AVMediaTypeVideo] setVideoOrientation:[[(AVCaptureVideoPreviewLayer *)[[self previewView] layer] connection] videoOrientation]];
        
        // Flash set to Auto for Still Capture
        [AVCaptureManager setFlashMode:AVCaptureFlashModeAuto forDevice:[[self videoDeviceInput] device]];
        
        // Capture a still image.
        [[self stillImageOutput] captureStillImageAsynchronouslyFromConnection:[[self stillImageOutput] connectionWithMediaType:AVMediaTypeVideo] completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
            
            if (imageDataSampleBuffer)
            {
                NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
             UIImage *  image = [[UIImage alloc] initWithData:imageData];
                UIImageOrientation imageOrientation=image.imageOrientation;
                if(imageOrientation!=UIImageOrientationUp)
                {
                    // 原始图片可以根据照相时的角度来显示，但UIImage无法判定，于是出现获取的图片会向左转９０度的现象。
                    // 以下为调整图片角度的部分
                    UIGraphicsBeginImageContext(image.size);
                    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
                    image = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    // 调整图片角度完毕
                    CGFloat width = image.size.width;
                    CGFloat height = width * self.previewView.frame.size.height / self.previewView.frame.size.width;
                    
                    image = [UIImage imageWithImage:image cutToRect:CGRectMake(0, (image.size.height - height) / 2, width, height)];
                    
                }
                if (block) {
                    block(image);
                }
                //
                
//                [[[ALAssetsLibrary alloc] init] writeImageToSavedPhotosAlbum:[image CGImage] orientation:(ALAssetOrientation)[image imageOrientation] completionBlock:nil];
                
                
            }
        }];
    });

    
}

-(void)changeDevicePosition:(DevicePosition)position{
    dispatch_async([self sessionQueue], ^{
//        AVCaptureDevice *currentVideoDevice = [[self videoDeviceInput] device];
        AVCaptureDevicePosition preferredPosition = AVCaptureDevicePositionUnspecified;
//        AVCaptureDevicePosition currentPosition = [currentVideoDevice position];
        
        switch (position)
        {
            case DevicePositionback:
                preferredPosition = AVCaptureDevicePositionBack;
                break;
            case DevicePositionFront:
                preferredPosition = AVCaptureDevicePositionFront;
                break;
            break;
        }
        
        AVCaptureDevice *videoDevice = [AVCaptureManager deviceWithMediaType:AVMediaTypeVideo preferringPosition:preferredPosition];
        AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:nil];
        
        [[self session] beginConfiguration];
        
        [[self session] removeInput:[self videoDeviceInput]];
        if ([[self session] canAddInput:videoDeviceInput])
        {
//            [[NSNotificationCenter defaultCenter] removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:currentVideoDevice];
            
            [AVCaptureManager setFlashMode:AVCaptureFlashModeAuto forDevice:videoDevice];
//            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subjectAreaDidChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:videoDevice];
            
            [[self session] addInput:videoDeviceInput];
            [self setVideoDeviceInput:videoDeviceInput];
        }
        else if([[self session] canAddInput:[self videoDeviceInput]])
        {
            [[self session] addInput:[self videoDeviceInput]];
        }
        
        [[self session] commitConfiguration];
        
   
    });
}


- (void)checkDeviceAuthorizationStatus
{
    NSString *mediaType = AVMediaTypeVideo;
    
    [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
        if (granted)
        {
            //Granted access to mediaType
            [self setDeviceAuthorized:YES];
        }
        else
        {
            //Not granted access to mediaType
            dispatch_async(dispatch_get_main_queue(), ^{

                [self setDeviceAuthorized:NO];
            });
        }
    }];
    
}
@end
