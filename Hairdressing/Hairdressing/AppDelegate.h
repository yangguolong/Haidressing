//
//  AppDelegate.h
//  collectionViewDemo
//
//  Created by 李昌庆 on 16/1/14.
//  Copyright © 2016年 李昌庆. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRCNavigationControllerStack.h"
#import "HairEngine.h"
#import <Reachability/Reachability.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (nonatomic, assign, readonly) NetworkStatus networkStatus;
@property (strong, nonatomic) UIWindow *window;
- (HairEngine *)getHairEngine;

@property (nonatomic, strong,readonly) MRCNavigationControllerStack *navigationControllerStack;

@end

