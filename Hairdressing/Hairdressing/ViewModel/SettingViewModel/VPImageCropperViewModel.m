//
//  VPImageCropperViewModel.m
//  Hairdressing
//
//  Created by Guolong Yang on 16/5/24.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "VPImageCropperViewModel.h"
@interface VPImageCropperViewModel()
{
    UIImage *getImage;
}
//@property(nonatomic,strong,readwrite)UIImage *originalImage;
//@property(nonatomic,assign,readwrite)CGRect cropFrame;
//@property(nonatomic,assign,readwrite)NSInteger limitRatio;
@end
@implementation VPImageCropperViewModel

//- (instancetype)initWithServices:(id<MRCViewModelServices>)services params:(UIImage *)image {
//    self = [super init];
//    if (self) {
//       // self.userEditItem = [params objectForKey:@"type"];
//        getImage = image;
//    }
//    return self;
//}


-(void)initialize{
    CGFloat Y = DEVICE_IS_IPHONE5?80:50;
    //    VPImageCropperViewController *VC = [[VPImageCropperViewController alloc] initWithImage:portraitImg
    //                                                                                 cropFrame:CGRectMake(0, Y, kWidth, kWidth)
    //                                                                           limitScaleRatio:3.0];
    self.cropFrame = CGRectMake(0, Y, kWidth, kWidth);
    self.originalImage = getImage;
    self.limitRatio = 3.0;

}




@end
