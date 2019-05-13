//
//  NSString+Extension.m
//  i3-platform-sdk
//
//  Created by Sun Yu on 13-3-22.
//
//

#import <CommonCrypto/CommonDigest.h>
#import "NSString+Extension.h"
//#import "JPinYinUtil.h"

@implementation NSString (Extension)

//#pragma mark - JSON解析
//- (id)JSONValue
//{
//    NSRange ran = [self rangeOfString:@"\n"];
//    if (ran.length > 0) {
//        self = [self stringByReplacingOccurrencesOfString:@"\n" withString:@"\\\\n"];
//    }
//    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
//    NSError *err;
//    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
//                                                        options:NSJSONReadingMutableContainers
//                                                          error:&err];
//    return dic;
//}

#pragma mark - 字符扩展
- (NSString*)substringFrom:(NSInteger)a to:(NSInteger)b
{
	NSRange r;
	r.location = a;
	r.length = b - a;
	return [self substringWithRange:r];
}

- (NSInteger)indexOf:(NSString*)substring from:(NSInteger)starts
{
	NSRange r;
	r.location = starts;
	r.length = [self length] - r.location;
	
	NSRange index = [self rangeOfString:substring options:NSLiteralSearch range:r];
	if (index.location == NSNotFound) {
		return -1;
	}
	return index.location + index.length;
}

- (BOOL)containsString:(NSString *)aString
{
	NSRange range = [[self lowercaseString] rangeOfString:[aString lowercaseString]];
	return range.location != NSNotFound;
}

- (BOOL)empty
{
	return [self length] > 0 ? NO : YES;
}

- (BOOL)notEmpty
{
	return [self length] > 0 ? YES : NO;
}

- (NSString *)trim
{
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

//- (NSString *)letters
//{
//    NSMutableString *letterString = [NSMutableString string];
//    int len = (int)[self length];
//    for (int i = 0;i < len;i++)
//    {
//        NSString *oneChar = [[self substringFromIndex:i] substringToIndex:1];
//        if (![oneChar canBeConvertedToEncoding:NSASCIIStringEncoding]) {
//            NSArray *temA = makePinYin2([oneChar characterAtIndex:0]);
//            if ([temA count]>0) {
//                oneChar = [temA objectAtIndex:0];
//            }
//        }
//        [letterString appendString:oneChar];
//    }
//    return letterString;
//}


- (NSString *)getFirstLetter
{
    NSString *ret = @"";
    if (![self canBeConvertedToEncoding: NSASCIIStringEncoding]) {//如果是英语
        if ([[self letters] length]>2) {
            ret = [[self letters] substringToIndex:1];
        }
        else
        {
            char code = [[self letters] characterAtIndex:0];
            if((code>=65 && code<=90) || (code>=97 && code<=122))
            {
                ret = [self letters];
            }
        }
    }
    else {
        ret = [NSString stringWithFormat:@"%c",[self characterAtIndex:0]];
    }
    return ret;
}

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *dict = @{NSFontAttributeName: font};
    CGSize textSize = [self boundingRectWithSize:maxSize
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:dict
                                         context:nil].size;
    return textSize;
}

#pragma mark - 数据加密
- (NSString *)md5HashDigest
{
    const char *original = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original, (CC_LONG)strlen(original), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}

//-(NSString*)mixEncryption
//{
//    NSString *mixString = [NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] objectForKey:USER_ACCOUT],self];
//    NSString *oneEncryption = [mixString md5HashDigest];//第一次加密
//    //拆分成两组
//    NSString *leftString = [oneEncryption substringWithRange:NSMakeRange(0, 16)];
////    DLog(@"leftstring  lenth== %d",[leftString length]);
////    DLog(@"leftString == %@",leftString);
//    NSString *rightString = [oneEncryption substringWithRange:NSMakeRange(16, 16)];
////    DLog(@"rightString length == %d",[rightString length]);
////    DLog(@"right === %@",rightString);
//    //把每组都逆序排列
//    NSMutableString *leftNewString = [[NSMutableString alloc] init];
//    NSMutableString *rightNewString = [[NSMutableString alloc] init];
//    for (int i = (int)[leftString length]-1; i >=0; i--)
//    {
//        [leftNewString appendString:[leftString substringWithRange:NSMakeRange(i, 1)]];
//        [rightNewString appendString:[rightString substringWithRange:NSMakeRange(i, 1)]];
//    }
////    DLog(@"left new string == %@",leftNewString);
////    DLog(@"right new string == %@",rightNewString);
//    //每组全变大写
//    leftString = [leftNewString uppercaseString];
//    rightString = [rightNewString uppercaseString];
//    //分别加密，拼成最终结果
//    NSString *resultString = [NSString stringWithFormat:@"%@%@",[leftString md5HashDigest],[rightString md5HashDigest]];
////    DLog(@"resultString == %@",resultString);
////    DLog(@"shi fou xiangtong == %d",[resultString isEqualToString:@"bd7cb3d815d668d77004c689753f21dfa799f07aafaf95f61c150ab6787de158"]);
//    return resultString;
//}

//- (NSMutableAttributedString *)exchangeString:(NSString *)string imageName:(NSString *)imageName
//{
//    //转码
//    self = [EmojiUnicode stringContainsUnicode:self];
//    //1、创建一个可变的属性字符串
//    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:self];
//    
//    //2、匹配字符串
//    NSError *error = nil;
//    NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:string options:NSRegularExpressionCaseInsensitive error:&error];
//    if (!re) {
//        NSLog(@"%@", [error localizedDescription]);
//        return attributeString;
//    }
//    
//    NSArray *resultArray = [re matchesInString:self options:0 range:NSMakeRange(0, self.length)];
//    //3、获取所有的图片以及位置
//    //用来存放字典，字典中存储的是图片和图片对应的位置
//    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:resultArray.count];
//    //根据匹配范围来用图片进行相应的替换
//    for(NSTextCheckingResult *match in resultArray) {
//        //获取数组元素中得到range
//        NSRange range = [match range];
//        //新建文字附件来存放我们的图片(iOS7才新加的对象)
//        NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
//        //给附件添加图片
//        textAttachment.image = [UIImage imageNamed:imageName];
//        //修改一下图片的位置,y为负值，表示向下移动
//        textAttachment.bounds = CGRectMake(0, -2, textAttachment.image.size.width, textAttachment.image.size.height);
//        //把附件转换成可变字符串，用于替换掉源字符串中的表情文字
//        NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
//        //把图片和图片对应的位置存入字典中
//        NSMutableDictionary *imageDic = [NSMutableDictionary dictionaryWithCapacity:2];
//        [imageDic setObject:imageStr forKey:@"image"];
//        [imageDic setObject:[NSValue valueWithRange:range] forKey:@"range"];
//        //把字典存入数组中
//        [imageArray addObject:imageDic];
//    }
//    
//    //4、从后往前替换，否则会引起位置问题
//    for (int i = (int)imageArray.count -1; i >= 0; i--) {
//        NSRange range;
//        [imageArray[i][@"range"] getValue:&range];
//        //进行替换
//        [attributeString replaceCharactersInRange:range withAttributedString:imageArray[i][@"image"]];
//    }
//
//    return attributeString;
//}


@end
