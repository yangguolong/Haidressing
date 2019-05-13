//
//  WXTabBarController.h
//  WXTabBarController
//
//  Created by leichunfeng on 15/11/20.
//  Copyright © 2015年 leichunfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WXTabBarControllerDelegate <NSObject>
@optional;

-(void)didSelectIndex:(NSInteger) index;

@end

@interface WXTabBarController : UITabBarController <UITabBarControllerDelegate>


@property (nonatomic,weak) id<WXTabBarControllerDelegate> wXdelegate;

@end
