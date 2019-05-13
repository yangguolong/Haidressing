//
//  LEActionSheet.h
//  LEActionSheet
//
//  Created by LEA on 15/9/28.
//  Copyright © 2015年 LEA. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LEActionSheetDelegate;

@interface LEActionSheet : UIView

@property (nonatomic, weak) id<LEActionSheetDelegate> delegate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic) NSInteger cancelButtonIndex;
@property (nonatomic) NSInteger destructiveButtonIndex;
@property (nonatomic, readonly) NSInteger numberOfButtons;


/** 初始化*/
- (LEActionSheet *)initWithTitle:(NSString *)title delegate:(id<LEActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;

/** 显示*/
- (void)showInView:(UIView *)view;

/** 消失*/
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;

@end


@protocol LEActionSheetDelegate <NSObject>
@optional

- (void)actionSheet:(LEActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

@end
