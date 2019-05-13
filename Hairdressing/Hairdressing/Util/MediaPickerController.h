//
//  MediaPickerController.h
//  110terminal
//
//  Created by zx_02 on 15/5/27.
//  Copyright (c) 2015年 Careers. All rights reserved.
//
//  对于源生UIImagePickerController的简单封装，业务逻辑在控制器中进行
//

#import <Foundation/Foundation.h>

typedef enum {
    IMAGETYPE = 0,
    VIDEOTYPE,
    
} MediaType;

@protocol MediaPickerControllerDelegate <NSObject>

//获取媒体文件
- (void)finishPickingMediaWithInfo:(NSDictionary *)info mediaType:(MediaType)mediaType isFromCamera:(BOOL)isFromCamera;

@end;

@interface MediaPickerController : NSObject<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UIImagePickerController     *imagePicker;
    MediaType                   mediaType;
    BOOL                        isFromCamera;
}

@property (nonatomic,assign) id delegate;

- (UIImagePickerController *)imagePicker;


/*
 @method
 @author        liuqian
 @date          2015-05-27
 @description   拍照
 @param
 @result
 */
- (void)showWithCamera;

/*
 @method
 @author        liuqian
 @date          2015-05-27
 @description   拍摄视频
 @param
 @result
 */
- (void)showWithVideo;

/*
 @method
 @author        liuqian
 @date          2015-05-27
 @description   图片库
 @param
 @result
 */
- (void)showWithPhotosAlbum;

/*
 @method
 @author        liuqian
 @date          2015-05-27
 @description   相册
 @param
 @result
 */
- (void)showWithPhotoLibrary;

@end
