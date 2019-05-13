//
//  AVCaptureManager.h
//  AVCaptureDemo
//
//  Created by Yangjiaolong on 16/4/5.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AVCamPreviewView.h"
typedef NS_ENUM(NSInteger,DevicePosition){
    DevicePositionback = 1,
    DevicePositionFront,
};

@interface AVCaptureManager : NSObject


-(instancetype)initWithPreviewView:(AVCamPreviewView *)view;

-(void)start;
-(void)stop;

-(void)changeDevicePosition:(DevicePosition)position;

-(void)stillImageWithBlock:(void(^)(UIImage * image))block;

@end
