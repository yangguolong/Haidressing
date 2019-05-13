//
//  YZMTakePhotoAlertView.h
//  Hairdressing
//
//  Created by Yangjiaolong on 16/5/19.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,YZMTakePhotoAlertType){
    YZMTakePhotoAlertForTake = 1,
    YZMTakePhotoAlertForPain,
};


@interface YZMTakePhotoAlertView : UIView
@property (nonatomic,assign) YZMTakePhotoAlertType currentType;


+(void)showWithType:(YZMTakePhotoAlertType)type;

@end