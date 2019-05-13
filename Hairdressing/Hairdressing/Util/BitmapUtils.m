//
//  BitmapUtils.m
//  cloudCrack
//
//  Created by ygl on 14-11-20.
//  Copyright (c) 2014年 goking. All rights reserved.
//

#import "BitmapUtils.h"
//#import "NSString+Category.h"
#import <Foundation/NSNull.h>
#import "UIImage+GK.h"
//#import "AppMacro.h"

@implementation BitmapUtils

//UIColor 转UIImage
+ (UIImage*) createImageWithColor:(UIColor*)color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

//UIImage转UIColor
//[UIColor colorWithPatternImage:[UIImage imageNamed:@"EmailBackground.png"]]

/**
 *  加载网络图片的方法
 *
 *  @param imageView
 *  @param URLString
 *  @param imagePath 默认图片路径
 */
+ (void)setImageWithImageView:(UIImageView *)imageView URLString:(NSString *)URLString placeholderImagePath:(NSString *)imagePath
{
    if ([URLString length] == 0) {
        [imageView setImage:[UIImage imageWithName:imagePath]];
        return;
    }
   
    [imageView sd_setImageWithURL:[NSURL URLWithString:URLString]placeholderImage:[UIImage imageWithName:imagePath]];
}

/**
 *  加载网络图片的方法
 *
 *  @param imageView
 *  @param URLString
 */
+ (void)setImageWithImageView:(UIImageView *)imageView URLString:(NSString *)URLString
{
    if ([URLString isKindOfClass:[NSNull class]] ||URLString == nil || [URLString length] == 0) {
        [imageView setImage:[UIImage imageWithName:@"load_error_img"]];
        return;
    }
    
    if ([URLString hasPrefix:@"http"]) {
    
         [imageView sd_setImageWithURL:[NSURL URLWithString:URLString]placeholderImage:[UIImage imageWithName:@"load_error_img"]];
    }else {
//        if ([[NSFileManager defaultManager] fileExistsAtPath:[CachePath stringByAppendingString:URLString]]) {
//            [imageView setImage:[UIImage imageWithName:[CachePath stringByAppendingString:URLString]]];
//            
//        }else {
         [imageView setImage:[UIImage imageWithName:URLString]];
//        }
    }
}

/**
 *  加载网络图片的方法
 *
 *  @param imageView
 *  @param URLString
 */
+ (void)setImageWithImageView:(UIImageView *)imageView URLString:(NSString *)URLString completed:(SDWebImageCompletionBlock)completedBlock
{
    if ([URLString length] == 0) {
        [imageView setImage:[UIImage imageWithName:@"load_error_img"]];
        return;
    }
//    if ([URLString isInternetUrl]) {
//        URLString = [NSString stringWithFormat:@"%@%@",@"",URLString];
//    }
    [imageView sd_setImageWithURL:[NSURL URLWithString:URLString]placeholderImage:[UIImage imageWithName:@"load_error_img"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image , error, cacheType, imageURL);
        }
    }];
}


/**
 *  获取网络图片的Size, 先通过文件头来获取图片大小
 如果失败 会下载完整的图片Data 来计算大小 所以最好别放在主线程
 如果你有使用SDWebImage就会先看下 SDWebImage有缓存过改图片没有
 支持文件头大小的格式 png、gif、jpg http://www.cocoachina.com/bbs/read.php?tid=165823
 *
 *  @param imageURL
 *
 *  @return
 */
+ (CGSize)downloadImageSizeWithURL:(id)imageURL
{
    NSURL* URL = nil;
    if([imageURL isKindOfClass:[NSURL class]]){
        URL = imageURL;
    }
    if([imageURL isKindOfClass:[NSString class]]){
        URL = [NSURL URLWithString:imageURL];
    }
    if(URL == nil)
        return CGSizeZero;
    NSString* absoluteString = URL.absoluteString;
#ifdef dispatch_main_sync_safe
    if([[SDImageCache sharedImageCache] diskImageExistsWithKey:absoluteString])
    {
        UIImage* image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:absoluteString];
        if(!image)
        {
            NSData* data = [[SDImageCache sharedImageCache] performSelector:@selector(diskImageDataBySearchingAllPathsForKey:) withObject:URL.absoluteString];
            image = [UIImage imageWithData:data];
        }
        if(!image)
        {
            return image.size;
        }
    }
#endif
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
    NSString* pathExtendsion = [URL.pathExtension lowercaseString];
    CGSize size = CGSizeZero;
    if([pathExtendsion isEqualToString:@"png"]){
        size =  [self downloadPNGImageSizeWithRequest:request];
    }
    else if([pathExtendsion isEqual:@"gif"])
    {
        size =  [self downloadGIFImageSizeWithRequest:request];
    }
    else{
        size = [self downloadJPGImageSizeWithRequest:request];
    }
    if(CGSizeEqualToSize(CGSizeZero, size))
    {
        NSData* data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:URL] returningResponse:nil error:nil];
        UIImage* image = [UIImage imageWithData:data];
        if(image)
        {
#ifdef dispatch_main_sync_safe
            [[SDImageCache sharedImageCache] storeImage:image recalculateFromImage:YES imageData:data forKey:URL.absoluteString toDisk:YES];
#endif
            size = image.size;
        }
    }
    return size;
}


/**
 *  下载png类型的data 获取图片size
 *
 *  @param request
 *
 *  @return
 */
+(CGSize)downloadPNGImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=16-23" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(data.length == 8)
    {
        int w1 = 0, w2 = 0, w3 = 0, w4 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        [data getBytes:&w3 range:NSMakeRange(2, 1)];
        [data getBytes:&w4 range:NSMakeRange(3, 1)];
        int w = (w1 << 24) + (w2 << 16) + (w3 << 8) + w4;
        int h1 = 0, h2 = 0, h3 = 0, h4 = 0;
        [data getBytes:&h1 range:NSMakeRange(4, 1)];
        [data getBytes:&h2 range:NSMakeRange(5, 1)];
        [data getBytes:&h3 range:NSMakeRange(6, 1)];
        [data getBytes:&h4 range:NSMakeRange(7, 1)];
        int h = (h1 << 24) + (h2 << 16) + (h3 << 8) + h4;
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}

/**
 *  下载gif类型的data 获取图片size
 *
 *  @param request request description
 *
 *  @return return value description
 */
+(CGSize)downloadGIFImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=6-9" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(data.length == 4)
    {
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        short w = w1 + (w2 << 8);
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(2, 1)];
        [data getBytes:&h2 range:NSMakeRange(3, 1)];
        short h = h1 + (h2 << 8);
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}

/**
 *  下载jpg类型的data 获取图片size
 *
 *  @param request request description
 *
 *  @return return value description
 */
+(CGSize)downloadJPGImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=0-209" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if ([data length] <= 0x58) {
        return CGSizeZero;
    }
    if ([data length] < 210) {// 肯定只有一个DQT字段
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
        [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
        short w = (w1 << 8) + w2;
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
        [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
        short h = (h1 << 8) + h2;
        return CGSizeMake(w, h);
    } else {
        short word = 0x0;
        [data getBytes:&word range:NSMakeRange(0x15, 0x1)];
        if (word == 0xdb) {
            [data getBytes:&word range:NSMakeRange(0x5a, 0x1)];
            if (word == 0xdb) {// 两个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0xa5, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0xa6, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0xa3, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0xa4, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            } else {// 一个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            }
        } else {
            return CGSizeZero;
        }
    }
}


//讨厌警告
- (id)diskImageDataBySearchingAllPathsForKey:(id)key{return nil;}
@end
