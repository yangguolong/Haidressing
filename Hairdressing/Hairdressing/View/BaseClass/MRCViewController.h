//
//  MRCViewController.h
//  MVVMReactiveCocoa
//
//  Created by leichunfeng on 14/12/27.
//  Copyright (c) 2014年 leichunfeng. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MRCViewController.h"
#import "MRCViewModel.h"
#import <ReactiveCocoa/RACEXTScope.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

#import <MBProgressHUD/MBProgressHUD.h>
#import "UIImage+GK.h"

@interface MRCViewController : UIViewController

/// The `viewModel` parameter in `-initWithViewModel:` method.
@property (nonatomic, strong, readonly) MRCViewModel *viewModel;
@property (nonatomic, strong, readonly) UIPercentDrivenInteractiveTransition *interactivePopTransition;
@property (nonatomic, strong) UIView *snapshot;

/// Initialization method. This is the preferred way to create a new view.
///
/// viewModel - corresponding view model
///
/// Returns a new view.
- (instancetype)initWithViewModel:(MRCViewModel *)viewModel;

/// Binds the corresponding view model to the view.
- (void)bindViewModel;

@end
