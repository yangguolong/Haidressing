//
//  ImgScrollView.h
//  ismarter2.0_sz
//
//  Created by liuqian on 14-8-13.
//
//

#import <UIKit/UIKit.h>

#import "ImgScrollView.h"
@protocol ImgScrollViewDelegate <NSObject>

- (void)tapImageViewTappedWithObject:(id ) sender;
- (void)hidePreviewView;

@end

@interface ImgScrollView : UIScrollView <UIScrollViewDelegate>
{
    UIImageView                 *imgView;           // 主图片视图
    CGRect                      scaleOriginRect;    //记录自己的位置
    CGSize                      imgSize;            //图片的大小
    CGRect                      initRect;           //缩放前大小
    UIActivityIndicatorView     *spinner;
    int                         userId;
    int                         boardType;
    NSString                    *filePath;
    NSString                    *thumbnailPath;
    NSString                    *blackboardId;
    
    NSArray                     *qrContent;         //图片中二维码信息
}
@property (nonatomic, retain) UIImageView *loadImageV;//加载提示视图
@property (nonatomic, retain) NSString *imgPath;
@property (nonatomic, retain) UIImage * thumbnailImage;
@property (nonatomic, retain) id<ImgScrollViewDelegate> parent;

- (void) setImage:(UIImage *)image AndViewTimes:(int)times;
- (void) setContentWithFrame:(CGRect) rect;
- (void) setImagePath:(NSString *)imagePath;
- (void) setAnimationRect;
- (void) rechangeInitRect;

@end
