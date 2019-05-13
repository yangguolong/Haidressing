//
//  ModuleActionSheet.h
//  ModuleActionSheet
//
//  Created by LEA on 16/3/2.
//  Copyright © 2016年 LEA. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ModuleActionSheetDelegate;

@interface ModuleActionSheet : UIView

@property (nonatomic, weak) id<ModuleActionSheetDelegate> delegate;


//- (ModuleActionSheet *)initWithDelegate:(id<ModuleActionSheetDelegate>)delegate
//                             imageNames:(NSArray *)imageNames
//                                 titles:(NSArray *)titles;
- (ModuleActionSheet *)initWithDelegate:(id<ModuleActionSheetDelegate>)delegate cellContent:(NSMutableArray *)serviceArray;
- (void)showInView:(UIView *)view;
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;

@end


@protocol ModuleActionSheetDelegate <NSObject>
@optional

- (void)moduleActionSheet:(ModuleActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
- (ModuleActionSheet *)initWithDelegate:(id<ModuleActionSheetDelegate>)delegate cellContent:(NSMutableArray *)serviceArray;
@end
