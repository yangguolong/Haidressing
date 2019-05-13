//
//  Utility.h
//  Hairdressing
//
//  Created by Guolong Yang on 16/3/28.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject

+ (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage ;
+ (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize;

+ (BOOL)isHaveIllegalChar:(NSString *)str;

+(NSString *)getHairModelDir;


+ (int)getCurrentTimestamp;

+ (NSString *)getDateByTimestamp:(NSInteger)timestamp type:(NSInteger)timeType;

+ (NSInteger)timestampToDate:(NSString *)times type:(NSInteger)timeType;

+(NSUInteger)compareHoursWithDate:(NSString *)inputDate;
//头像缩略图路径
+(NSString*)getHeadImageDocDir;
//试发模型下载
+(BOOL)getHairStyleModel;

+(BOOL)isFileExistInHairModelDir:(NSString*)modelName;

+(NSString*)getHairModelDirWithName:(NSString*)modelName;

// Generates alpha-numeric-random string
+ (NSString *)genRandStringLength:(int)len;

+ (void)addLinearGradientToView:(UIView *)theView withColor:(UIColor *)theColor transparentToOpaque:(BOOL)transparentToOpaque;

+ (BOOL)vefifyPhoneNumber:(NSString *)num;
@end