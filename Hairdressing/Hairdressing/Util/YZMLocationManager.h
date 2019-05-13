//
//  YZMLocationManager.h
//  Hairdressing
//
//  Created by Yangjiaolong on 16/4/6.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,YZMLocationManagerErrorType) {
    
    ZMLocationManagerErrorTypeCallback = 1,
};


@interface YZMLocationManager : NSObject <CLLocationManagerDelegate>

/**
 *  市
 */
@property(nonatomic,copy)NSString * locality;
/**
 *  定位失败原因
 */
@property(nonatomic,copy)NSString * error;
/**
 *  当前定位坐标
 */
@property(nonatomic,assign)CLLocationCoordinate2D currentCoordinate;

/**
 *  是否有权限定位
 */
@property(nonatomic,assign)BOOL authorizationStatus;

@property(nonatomic,assign)CLAuthorizationStatus authStatus;
@property(nonatomic,assign)YZMLocationManagerErrorType errorType;

+(instancetype)shareInstance;

-(void)start;
-(void)stop;

@end
