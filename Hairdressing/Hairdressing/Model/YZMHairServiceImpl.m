//
//  YZMHairServiceImpl.m
//  Hairdressing
//
//  Created by yzm on 5/9/16.
//  Copyright © 2016 Yangjiaolong. All rights reserved.
//

#import "YZMHairServiceImpl.h"
#import "YZMLocationManager.h"

@implementation YZMHairServiceImpl

- (RACSignal *)getArea
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"jsonrpc"] = @"2.0";
    parameters[@"params"] = @[ @{@"provinceId" : @"440000", @"cityId": @"440300", @"type" : @"3"} ];
    
    return [super requestDataFromNetWithParams:parameters withAction:@"getArea"];
}

- (RACSignal *)getHairstylistWithSortType:(NSNumber *)sortType
                               districtId:(NSString *)districtId
                                   townId:(NSString *)townId
                                 distance:(long long)distance
                                      pNo:(long long)pNo
                                    pSize:(long long)pSize
                                longitude:(double)longitude
                                 latitude:(double)latitude;
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"jsonrpc"] = @"2.0";
    
    if(!districtId || [districtId isEqualToString:@"440300"]){
        districtId = @"0";
    }
    
    longitude = [YZMLocationManager shareInstance].currentCoordinate.longitude;
    latitude = [YZMLocationManager shareInstance].currentCoordinate.latitude;
    parameters[@"params"] = @[ @{@"cityId" : @"440300", @"sortType": sortType? sortType : @(1), @"districtId" : districtId, @"townId" : @"0", @"longitude": [NSString stringWithFormat:@"%ld", longitude ], @"latitude":  [NSString stringWithFormat:@"%ld", latitude], @"distance": @"0", @"pNo": @(pNo), @"pSize": @(pSize) } ];
    
    return [super requestDataFromNetWithParams:parameters withAction:@"getHairstylist"];
    
    
}

- (RACSignal *)getCorplistWithSortType:(NSNumber *)sortType
                            districtId:(NSString *)districtId
                                townId:(NSString *)townId
                              distance:(long long)distance
                                   pNo:(long long)pNo
                                 pSize:(long long)pSize
                             longitude:(double)longitude
                              latitude:(double)latitude
                           corporation:(NSString *)corporation
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"jsonrpc"] = @"2.0";
    
    if(!districtId || [districtId isEqualToString:@"440300"]){
        districtId = @"0";
    }

    longitude = [YZMLocationManager shareInstance].currentCoordinate.longitude;
    latitude = [YZMLocationManager shareInstance].currentCoordinate.latitude;
    parameters[@"params"] = @[ @{@"cityId" : @"440300", @"sortType": sortType? sortType : @(1), @"districtId" : districtId, @"townId" : @"0", @"longitude": [NSString stringWithFormat:@"%f", longitude ], @"latitude":  [NSString stringWithFormat:@"%f", latitude], @"distance": @"0", @"pNo": @(pNo), @"pSize": @(pSize), @"corporation": corporation?corporation : @""} ];
    
    return [super requestDataFromNetWithParams:parameters withAction:@"getCorplist"];
}



@end
