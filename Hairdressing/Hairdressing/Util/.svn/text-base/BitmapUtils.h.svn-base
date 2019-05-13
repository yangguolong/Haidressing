//
//  BitmapUtils.h
//  cloudCrack
//
//  Created by ygl on 14-11-20.
//  Copyright (c) 2014年 goking. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImageView+WebCache.h"
//#import "UIImage+GL.h"



@interface BitmapUtils : NSObject

+ (UIImage*) createImageWithColor: (UIColor*) color; 

/**
 *  加载网络图片的方法
 *
 *  @param imageView
 *  @param URLString
 */
+ (void)setImageWithImageView:(UIImageView *)imageView URLString:(NSString *)URLString;

/**
 *  加载网络图片的方法
 *
 *  @param imageView
 *  @param URLString
 *  @param imagePath 默认图片路径
 */
+ (void)setImageWithImageView:(UIImageView *)imageView URLString:(NSString *)URLString placeholderImagePath:(NSString *)imagePath;
/**
 *  加载网络图片的方法
 *
 *  @param imageView
 *  @param URLString
 */
+ (void)setImageWithImageView:(UIImageView *)imageView URLString:(NSString *)URLString completed:(SDWebImageCompletionBlock)completedBlock;

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
+ (CGSize)downloadImageSizeWithURL:(id)imageURL;


/**
 *  UIColor 转UIImage
 *
 *  @param color
 *
 *  @return
 */
+ (UIImage*) createImageWithColor:(UIColor*)color;

/**
 *  下载png类型的data 获取图片size
 *
 *  @param request request description
 *
 *  @return return value description
 */
+ (CGSize)downloadPNGImageSizeWithRequest:(NSMutableURLRequest*)request;


/**
 *  下载GIF类型的data 获取图片size
 *
 *  @param request request description
 *
 *  @return return value description
 */
+ (CGSize)downloadGIFImageSizeWithRequest:(NSMutableURLRequest*)request;


/**
 *  下载jpg类型的data 获取图片size
 *
 *  @param request request description
 *
 *  @return return value description
 */
+ (CGSize)downloadJPGImageSizeWithRequest:(NSMutableURLRequest*)request;



@end
