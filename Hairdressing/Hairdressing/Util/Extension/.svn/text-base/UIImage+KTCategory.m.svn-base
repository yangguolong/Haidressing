//
//  UIImageAdditions.m
//  Sample
//
//  Created by Kirby Turner on 2/7/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import "UIImage+KTCategory.h"

@implementation UIImage (KTCategory)

- (UIImage *)imageScaleAspectToMaxSize:(CGFloat)newSize
{
   CGSize size = [self size];
   CGFloat ratio;
   if (size.width > size.height) {
      ratio = newSize / size.width;
   } else {
      ratio = newSize / size.height;
   }
   CGRect rect = CGRectMake(0.0, 0.0, ratio * size.width, ratio * size.height);
   UIGraphicsBeginImageContext(rect.size);
   [self drawInRect:rect];
   UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
   return scaledImage;
}

- (UIImage *)imageScaleAndCropToMaxSize:(CGSize)newSize
{
   CGFloat largestSize = (newSize.width > newSize.height) ? newSize.width : newSize.height;
   CGSize imageSize = [self size];
   
   CGFloat ratio;
   if (imageSize.width > imageSize.height) {
      ratio = largestSize / imageSize.height;
   } else {
      ratio = largestSize / imageSize.width;
   }
   
   CGRect rect = CGRectMake(0.0, 0.0, ratio * imageSize.width, ratio * imageSize.height);
   UIGraphicsBeginImageContext(rect.size);
   [self drawInRect:rect];
    
   UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
   CGFloat offsetX = 0;
   CGFloat offsetY = 0;
   imageSize = [scaledImage size];
   if (imageSize.width < imageSize.height) {
      offsetY = (imageSize.height / 2) - (imageSize.width / 2);
   } else {
      offsetX = (imageSize.width / 2) - (imageSize.height / 2);
   }
   
   CGRect cropRect = CGRectMake(offsetX, offsetY,
                                imageSize.width - (offsetX * 2),
                                imageSize.height - (offsetY * 2));
   
   CGImageRef croppedImageRef = CGImageCreateWithImageInRect([scaledImage CGImage], cropRect);
   UIImage *newImage = [UIImage imageWithCGImage:croppedImageRef];
   CGImageRelease(croppedImageRef);
   
   return newImage;
}

#pragma mark - 水印
//- (UIImage *)addText:(NSString *)text1
//{
//    int w = self.size.width;
//    int h = self.size.height;
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
//    CGContextDrawImage(context, CGRectMake(0, 0, w, h), self.CGImage);
//    CGContextSetRGBFillColor(context, 0.0, 1.0, 1.0, 1);
//    char* text = (char *)[text1 cStringUsingEncoding:NSASCIIStringEncoding];
//    if (!DEVICE_IS_IPHONE5) {
//        CGContextSelectFont(context, "Arial", 13, kCGEncodingMacRoman);
//    } else {
//        CGContextSelectFont(context, "Arial", 23, kCGEncodingMacRoman);
//    }
//    CGContextSetTextDrawingMode(context, kCGTextFill);
//    CGContextSetRGBFillColor(context, 255, 0, 0, 1);
//    if (!DEVICE_IS_IPHONE5) {
//        CGContextShowTextAtPoint(context, w/2-strlen(text)*3+45, h/12-20, text, strlen(text));
//    }
//    else {
//        CGContextShowTextAtPoint(context, w/2-strlen(text)*3-5, h/12-20, text, strlen(text));
//    }
//    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
//    CGContextRelease(context);
//    CGColorSpaceRelease(colorSpace);
//    UIImage *resultImage = [UIImage imageWithCGImage:imageMasked scale:[[UIScreen mainScreen] scale] orientation:UIImageOrientationUp];
//    CGImageRelease(imageMasked);
//    return resultImage;
//}


/**文字水印*/
- (UIImage *)imageWithStringWaterMark:(NSString *)markString inRect:(CGRect)rect color:(UIColor *)color font:(UIFont *)font
{
    UIGraphicsBeginImageContextWithOptions([self size], NO, [[UIScreen mainScreen] scale]);
    //1.原图
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    //2.水印文字
    NSMutableParagraphStyle *stype = [[NSMutableParagraphStyle alloc] init];
    stype.lineSpacing = 3;
    stype.alignment = NSTextAlignmentRight;
    
    NSRange range = [markString rangeOfString:@"\n"];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:markString];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:stype range:NSMakeRange(0,[markString length])];
    [attributedString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0,[markString length])];
    [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0,[markString length])];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Thonburi" size:15.0] range:NSMakeRange(0,range.location)];

    [attributedString drawInRect:rect];
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newPic;
}

@end
