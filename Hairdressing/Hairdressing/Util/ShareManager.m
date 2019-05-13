//
//  ShareManager.m
//  Meou
//
//  Created by  on 15/11/6.
//  Copyright © 2015年 Yangjiaolong. All rights reserved.
//

#import "ShareManager.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDK/SSDKTypeDefine.h>
@implementation ShareManager
/**
 
 QQ空间分享时一定要携带title、titleUrl、site、siteUrl，QQ空间本身不支持分享本地图片，因此如果想分享本地图片，图片会先上传到ShareSDK的文件服务器，得到连接以后才分享此链接。由于本地图片更耗流量，因此imageUrl优先级高于imagePath。
 以上这些字段不可缺少
 
 */

+(void)showShareSheetWithImage:(id)image content:(NSString *)content success:(void (^)(NSString *))success failure:(void (^)(NSString *))failure{

    
    UIImage * shareImage = image;
    if (!shareImage) {
        return;
    }
//     NSArray* imageArray = @[shareImage];
    

     NSMutableArray *activePlatforms = [NSMutableArray arrayWithArray:[ShareSDK activePlatforms]];
 
    
    
    //1、创建分享参数
    if (shareImage) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"分享内容"
                                         images:shareImage
                                            url:[NSURL URLWithString:@"http://www.Yangjiaolong.net"]
                                          title:@"分享标题"
                                           type:SSDKContentTypeImage];
        
//        [shareParams SSDKSetupQQParamsByText:@"分享内容" title:@"分享标题" url:[NSURL URLWithString:@"http:/www.Yangjiaolong.net"] thumbImage:shareImage image:@"http://img0.bdstatic.com/img/image/shouye/bizhi1109.jpg" type:SSDKContentTypeImage forPlatformSubType:SSDKPlatformSubTypeQZone];
        
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        //shareParams
        [ShareSDK showShareActionSheet:[UIApplication sharedApplication].keyWindow items:activePlatforms shareParams:shareParams onShareStateChanged:^(SSDKResponseState state, enum SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
            switch (state) {
                case SSDKResponseStateSuccess:
                {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                        message:nil
                                                                       delegate:nil
                                                              cancelButtonTitle:@"确定"
                                                              otherButtonTitles:nil];
                    [alertView show];
                    break;
                }
                case SSDKResponseStateFail:
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                    message:[NSString stringWithFormat:@"%@",error]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil, nil];
                    [alert show];
                    break;
                }
                default:
                    break;
            }
            
        }];
    }
    
}
@end
