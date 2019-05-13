//
//  MediaPickerController.m
//  110terminal
//
//  Created by zx_02 on 15/5/27.
//  Copyright (c) 2015年 Careers. All rights reserved.
//

#import "MediaPickerController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@implementation MediaPickerController
@synthesize delegate;


-(UIImagePickerController *)imagePicker
{
    if (imagePicker) {
        return imagePicker;
    }
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.view.backgroundColor = [UIColor blackColor];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = NO;
    imagePicker.navigationBar.tintColor = [UIColor blackColor];
//    [imagePicker.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar"]forBarMetrics:UIBarMetricsDefault];
    imagePicker.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor],
                                                      NSFontAttributeName:[UIFont boldSystemFontOfSize:19]};
    
    return imagePicker;
}

- (void)showImagePicker
{
    if ([self.delegate respondsToSelector:@selector(presentViewController:animated:completion:)]) {
        [[self.delegate navigationController] presentViewController:imagePicker animated:YES completion:nil];
    }
}

#pragma mark - 操作处理
-(void)showWithCamera
{
    isFromCamera = YES;
    mediaType = IMAGETYPE;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [[self imagePicker] setSourceType:UIImagePickerControllerSourceTypeCamera];
        [[self imagePicker] setMediaTypes:[NSArray arrayWithObject:@"public.image"]];
        [[self imagePicker] setShowsCameraControls:YES];
        [self showImagePicker];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"对不起，该设备没有摄像头"
                                                           message:nil
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
        [alertView show];
    }
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus != AVAuthorizationStatusAuthorized)
    {
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:[NSString stringWithFormat:@"请为【%@】开启相机权限",kTargetName]
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"确定",nil];
        [alterView show];
    }
}

- (void)showWithVideo
{
    mediaType = VIDEOTYPE;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [[self imagePicker] setSourceType:UIImagePickerControllerSourceTypeCamera];
        [[self imagePicker] setAllowsEditing:YES];
        [[self imagePicker] setVideoQuality:UIImagePickerControllerQualityTypeMedium];
        [[self imagePicker] setMediaTypes:[NSArray arrayWithObject:@"public.movie"]];
        [self showImagePicker];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"对不起，该设备没有摄像头"
                                                           message:nil
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
        [alertView show];
    }
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus != AVAuthorizationStatusAuthorized)
    {
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:[NSString stringWithFormat:@"请为【%@】开启相机权限",kTargetName]
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"确定",nil];
        [alterView show];
    }
}

- (void)showWithPhotosAlbum
{
    isFromCamera = NO;
    mediaType = IMAGETYPE;
    [[self imagePicker] setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    [[self imagePicker] setMediaTypes:[NSArray arrayWithObject:@"public.image"]];
    [self showImagePicker];
    
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author != ALAuthorizationStatusAuthorized)
    {
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:[NSString stringWithFormat:@"请为【%@】开启相机权限",kTargetName]
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"确定",nil];
        [alterView show];
    }
}

- (void)showWithPhotoLibrary
{
    isFromCamera = NO;
    mediaType = IMAGETYPE;
    [[self imagePicker] setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [[self imagePicker] setAllowsEditing:NO];
    [[self imagePicker] setToolbarHidden:YES];
    [self showImagePicker];
    
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author != ALAuthorizationStatusAuthorized)
    {
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:[NSString stringWithFormat:@"请为【%@】开启相机权限",kTargetName]                                                               
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"确定",nil];
        [alterView show];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([self.delegate respondsToSelector:@selector(finishPickingMediaWithInfo:mediaType:isFromCamera:)]) {
        [self.delegate finishPickingMediaWithInfo:info mediaType:mediaType isFromCamera:isFromCamera];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
