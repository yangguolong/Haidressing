//
//  ShareManager.h
//  Meou
//
//  Created by  on 15/11/6.
//  Copyright © 2015年 Yangjiaolong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ShareManager : NSObject


+(void)showShareSheetWithImage:(UIImage *)image content:(NSString *)content success:(void(^)(NSString * result))success failure:(void(^)(NSString * reason))failure;

@end
