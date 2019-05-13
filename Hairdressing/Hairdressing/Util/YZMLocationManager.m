//
//  YZMLocationManager.m
//  Hairdressing
//
//  Created by Yangjiaolong on 16/4/6.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "YZMLocationManager.h"
#import <CoreLocation/CoreLocation.h>

@interface YZMLocationManager ()

@property (nonatomic,strong)CLLocationManager * locationManager;

@end


@implementation YZMLocationManager

+(instancetype)shareInstance{
    static YZMLocationManager * yzmLM;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        yzmLM = [[YZMLocationManager alloc]init];
    });
    return yzmLM;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        if ([CLLocationManager locationServicesEnabled]) {
            self.authorizationStatus = YES;
            _locationManager =  [[CLLocationManager alloc] init];
            _locationManager.delegate = self;
            self.locationManager.distanceFilter = 100.0f;// 多少距离更新一次
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;//精确度
            //如果是ios8设备，需要配置文件，看后面。
            if ([[[UIDevice currentDevice] systemVersion] doubleValue] > 8.0) {
                //设置定位权限 仅ios8有意义
                [self.locationManager requestWhenInUseAuthorization];// 前台定位
                //  [locationManager requestAlwaysAuthorization];// 前后台同时定位
            }
            // 开始定位
        }else{
            self.authorizationStatus = NO;
            self.error = @"没有权限";
        }

    }
    return self;
}


- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_6_0){
    CLLocation *currentLocation = [locations lastObject];
    self.currentCoordinate = currentLocation.coordinate;
    DLog(@"当前定位坐标longitude: %f  latitude: %f",self.currentCoordinate.longitude,self.currentCoordinate.latitude);
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error)
     {
         if (array.count > 0){
             CLPlacemark *placemark = [array objectAtIndex:0];
             //获取位置信息
//             DLog(@"%@",placemark.name);
//            
//             DLog(@"thoroughfare,%@",placemark.thoroughfare); //街道
//             
//             DLog(@"subThoroughfare,%@",placemark.subThoroughfare); //子街道
//             DLog(@"locality,%@",placemark.locality); // 市
//             DLog(@"subLocality,%@",placemark.subLocality);// 区
//             DLog(@"country,%@",placemark.country);// 国家
             //获取城市
             NSString *city = placemark.locality;
             
             
             if (!city) {
                 //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                 city = placemark.administrativeArea;
             }
             
             self.locality = city;
         }
         else if (error == nil && [array count] == 0){
             self.error = @"定位失败";
             DLog(@"No results were returned.");
         }
         else if (error != nil){
           self.error = @"定位失败";
             DLog(@"An error occurred = %@", error);
         }
     }];
    
    
    
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    DLog(@"An error occurred = %@", error);
    self.error = @"";
    self.errorType = ZMLocationManagerErrorTypeCallback;
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    self.authStatus = status;
    
    if (status == kCLAuthorizationStatusNotDetermined) {
        
            DLog(@" 等待用户授权");
    } else if(status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
            DLog(@"授权成功");
    } else {
            DLog(@"授权失败");
        self.authorizationStatus = NO;
        self.error = @"没有权限";
    }
}

-(void)start{
    [self.locationManager startUpdatingLocation];

}
-(void)stop{
    [self.locationManager stopUpdatingHeading];

}
@end
