//
//  NSString+Category.m
//  COOKBook
//
//  Created by ysp on 14-10-20.
//  Copyright (c) 2014年 YSP. All rights reserved.
//

#import "NSString+Category.h"
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>

#define REGULAR_FILE_NAME @"Regular"

// 判断邮件格式正则表达式
#define EMAIL_REGEX_NAME @"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b"

// 判断数字正则表达式
#define NUMBER_REGEX_NAME @"^[0-9]*$"

//判断数字和字母组合
#define NUMBERORENGLISH_REGEX_NAME @"^[A-Za-z0-9]*$"

// 判断英文正则表达式
#define ENGLISH_REGEX_NAME @"^[A-Za-z]+$"

// 判断中文正则表达式
#define CHINESE_REGEX_NAME @"^[\u4e00-\u9fa5],{0,}$"

// 判断网址正则表达式
//#define INTERNET_URL_REGEX_NAME @"^http://([\\w-]+\\.)+[\\w-]+(/[\\w-./?%&=]*)?$ ;^[a-zA-z]+://(w+(-w+)*)(.(w+(-w+)*))*(?S*)?$"

@implementation NSString (Category)

- (NSString *)addUrlPrefix
{
    if ([self hasPrefix:@"http"]) {
        return self;
    }else{
        return [NSString stringWithFormat:@"http://%@",self];
    }
}

+ (BOOL)checkEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
    
}

// 返回size
- (CGSize)calculateSizeinSettingSize:(CGSize)settingSize withFontSize:(CGFloat)fontSize
{
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        
        NSMutableParagraphStyle *parag=[[NSMutableParagraphStyle alloc] init];
        parag.lineBreakMode = NSLineBreakByCharWrapping;
        
//        UIFont *font=[UIFont systemFontOfSize:fontSize];
//        NSDictionary *attrib=@{NSFontAttributeName:font,NSParagraphStyleAttributeName:parag.copy};
//        
//        CGSize getSize=[self boundingRectWithSize:settingSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrib context:nil].size;
//        
//        return getSize;
    
        NSDictionary *attribute = @{NSFontAttributeName           : font,
                                    NSParagraphStyleAttributeName : parag.copy};
        CGSize size = [self boundingRectWithSize:settingSize options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        return size;
        /*
         NSStringDrawingTruncatesLastVisibleLine如果文本内容超出指定的矩形限制，文本将被截去并在最后一个字符后加上省略号。 如果指定了NSStringDrawingUsesLineFragmentOrigin选项，则该选项被忽略 NSStringDrawingUsesFontLeading计算行高时使用行间距。（注：字体大小+行间距=行高
         */
    } else {
        CGSize size = [self sizeWithFont:font constrainedToSize:settingSize lineBreakMode:NSLineBreakByWordWrapping];
        return size;
        /*
         UILineBreakModeWordWrap = 0,
         以单词为单位换行，以单位为单位截断。
         UILineBreakModeCharacterWrap,
         以字符为单位换行，以字符为单位截断。
         UILineBreakModeClip,
         以单词为单位换行。以字符为单位截断。
         UILineBreakModeHeadTruncation,
         以单词为单位换行。如果是单行，则开始部分有省略号。如果是多行，则中间有省略号，省略号后面有4个字符。
         UILineBreakModeTailTruncation,
         以单词为单位换行。无论是单行还是多行，都是末尾有省略号。
         UILineBreakModeMiddleTruncation,
         以单词为单位换行。无论是单行还是多行，都是中间有省略号，省略号后面只有2个字符。
         */
    }
}


//// md5 32位 加密
- (NSString *)md5Str
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (int)strlen(cStr), result);
    return [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]];
}

// 判断是否为整形：
- (BOOL)isPureInt
{
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

// 判断是否为浮点形：
- (BOOL)isPureFloat
{
    NSScanner* scan = [NSScanner scannerWithString:self];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

// 邮件
- (BOOL)isValidateEmail
{
    NSPredicate *regex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", EMAIL_REGEX_NAME];
    return [regex evaluateWithObject:self];
}

// 数字
- (BOOL)isNumber
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", NUMBER_REGEX_NAME];
    return [predicate evaluateWithObject:self];
}

// 英文
- (BOOL)isEnglish
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", ENGLISH_REGEX_NAME];
    return [predicate evaluateWithObject:self];
}

// 数字英文 组合
- (BOOL)isEnglishOrNumber
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", NUMBERORENGLISH_REGEX_NAME];
    return [predicate evaluateWithObject:self];
    
}

// 汉字
- (BOOL)isChinese
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CHINESE_REGEX_NAME];
    return [predicate evaluateWithObject:self];
}

// 网址
//- (BOOL)isInternetUrl
//{
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", INTERNET_URL_REGEX_NAME];
//    return [predicate evaluateWithObject:self];
//}

// 正则判断手机号码格式
- (BOOL)isMobileNumber
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[1278])\\d)\\d{7}$";
    /**
     * 中国联通：China Unicom
     * 130,131,132,152,155,156,185,186
     */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     * 中国电信：China Telecom
     * 133,1349,153,180,189
     */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     * 大陆地区固话及小灵通
     * 区号：010,020,021,022,023,024,025,027,028,029
     * 号码：七位或八位
     */
    //NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:self] == YES)
        || ([regextestcm evaluateWithObject:self] == YES)
        || ([regextestct evaluateWithObject:self] == YES)
        || ([regextestcu evaluateWithObject:self] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+(BOOL)checkPhone:(NSString *)phone
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     * 中国联通：China Unicom
     * 130,131,132,152,155,156,185,186
     */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     * 中国电信：China Telecom
     * 133,1349,153,180,189
     */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     * 大陆地区固话及小灵通
     * 区号：010,020,021,022,023,024,025,027,028,029
     * 号码：七位或八位
     */
    //NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:phone] == YES)
        || ([regextestcm evaluateWithObject:phone] == YES)
        || ([regextestct evaluateWithObject:phone] == YES)
        || ([regextestcu evaluateWithObject:phone] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
    
}

- (NSString *)changSelfByAddOrReduce:(BOOL)isAdd
{
    int stringValue = [self intValue];
    NSString *newStr = nil;
    if (isAdd) {
        
       newStr = [NSString stringWithFormat:@"%d",++stringValue];
    }else{
       newStr = [NSString stringWithFormat:@"%d",--stringValue];
    }

    return newStr;
}



@end
