//
//  UIImageAdditions.h
//  Sample
//
//  Created by Kirby Turner on 2/7/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface UIImage (KTCategory)

/** 等比压缩到某个尺寸*/
- (UIImage *)imageScaleAspectToMaxSize:(CGFloat)newSize;

/** 裁剪某个尺寸*/
- (UIImage *)imageScaleAndCropToMaxSize:(CGSize)newSize;

///* 在图片上添加文字方法实现 照片上添加时间戳*/
//- (UIImage *)addText:(NSString *)text1;

/** 文字水印*/
- (UIImage *)imageWithStringWaterMark:(NSString *)markString
                               inRect:(CGRect)rect
                                color:(UIColor *)color
                                 font:(UIFont *)font;

@end
