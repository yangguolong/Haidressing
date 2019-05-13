//
//  NSString+Extension.h
//  i3-platform-sdk
//
//  Created by Sun Yu on 13-3-22.
//
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)


#pragma mark - JSON解析
///**
// *  JSON解析
// *
// *  @return 解析后的字典
// */
//- (id)JSONValue;

#pragma mark - 字符扩展
/**
 *  获取子串
 *
 *  @param a 起点
 *  @param b 终点
 *
 *  @return 子串
 */
- (NSString *)substringFrom:(NSInteger)a to:(NSInteger)b;

/**
 *  子串的位置
 *
 *  @param
 *  @param
 *
 *  @return
 */
- (NSInteger)indexOf:(NSString*)substring from:(NSInteger)starts;

/**
 *  是否包含子串
 *
 *  @param
 *  @param
 *
 *  @return
 */
- (BOOL)containsString:(NSString*)aString;

/**
 *  除去空格
 *
 *  @param
 *  @param
 *
 *  @return
 */
- (NSString *)trim;

/**
 *  判空
 *
 *  @param
 *  @param
 *
 *  @return
 */
- (BOOL)empty;

/**
 *  判空
 *
 *  @param
 *  @param
 *
 *  @return
 */
- (BOOL)notEmpty;

/**
 *  获取字符的所有字母
 *
 *  @param
 *  @param
 *
 *  @return
 */
- (NSString *)letters;

/**
 *  获取字符的首字母
 *
 *  @param
 *  @param
 *
 *  @return
 */
- (NSString *)getFirstLetter;

/**
 *  计算文本占用的宽高
 *
 *  @param font    显示的字体
 *  @param maxSize 最大的显示范围
 *
 *  @return 占用的宽高
 */
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

/**
 *  将特殊字符转换为图片
 *
 *  @param string    待转换的字符
 *  @param imageName 图片名字
 *
 *  @return 一个lable可以直接显示的attributeString
 */
- (NSMutableAttributedString *)exchangeString:(NSString *)string imageName:(NSString *)imageName;


#pragma mark - md5加密
/**
 *  md5加密
 *
 *  @param
 *  @param
 *
 *  @return
 */
- (NSString *)md5HashDigest;

/**
 *  md5加密
 *
 *  @param
 *  @param
 *
 *  @return
 */
//- (NSString*)mixEncryption;

@end
