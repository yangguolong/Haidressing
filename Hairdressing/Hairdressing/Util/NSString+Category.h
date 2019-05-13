//
//  NSString+Category.h
//  COOKBook
//
//  Created by ysp on 14-10-20.
//  Copyright (c) 2014年 YSP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface NSString (Category)



- (NSString *)addUrlPrefix;

+(BOOL)checkEmail:(NSString *)email;

//+(BOOL)checkPhone:(NSString *)phone;

- (BOOL)isPureInt;

- (BOOL)isPureFloat;

// 返回size
- (CGSize)calculateSizeinSettingSize:(CGSize)settingSize withFontSize:(CGFloat)fontSize;

/**
 *  验证邮箱是不是可用
 *
 *  return YES / NO
 */
- (BOOL)isValidateEmail;

/**
 *  验证是不是数字
 *
 *  return YES / NO
 */
- (BOOL)isNumber;

/**
 *  验证是不是英文
 *
 *  return YES / NO
 */
- (BOOL)isEnglish;

/**
 数字英文 组合
 */
- (BOOL)isEnglishOrNumber;

/**
 *  验证是不是汉字
 *
 *  return YES / NO
 */
- (BOOL)isChinese;

/**
 *  验证是不是网络链接地址
 *
 *  return YES / NO
 */
- (BOOL)isInternetUrl;

/**
 *  是不是手机号码
 *
 *  @param mobileNum 手机号
 *
 *  @return YES / NO
 */
- (BOOL)isMobileNumber;

+(BOOL)checkPhone:(NSString *)phone;

/**
 *  字符串 自加或自减
 *
 *  @isAdd  是否是自加
 *  @return 返回的字符串
 */
- (NSString *)changSelfByAddOrReduce:(BOOL)isAdd;

/**
 *
 *  32位MD5加密方式
 *  @return
 */
- (NSString *)md5Str;



@end
