//
//  LoginViewController.h
//  Hairdressing
//
//  Created by admin on 16/3/26.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewModel.h"
@class IQKeyboardReturnKeyHandler;
@interface LoginViewController : MRCViewController
{


}
//@property(nonatomic,strong)    UIButton *avatarButton;
//@property(strong,nonatomic)UITextField *usernameField;
//@property(strong,nonatomic)UITextField *passwordField;
//@property(strong,nonatomic)UIButton *loadButton;
@property(strong,nonatomic)UIButton *cancelButton;
//@property(strong,nonatomic)UIButton *registerBtn;
//@property(strong,nonatomic)UIButton *forgetPasswordBtn;
//@property (weak, nonatomic) IBOutlet UIButton *avatarButton;

@property (weak, nonatomic) IBOutlet UITextField *usernameField;

@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (weak, nonatomic) IBOutlet UIButton *loadButton;

@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@property (weak, nonatomic) IBOutlet UIButton *forgetPasswordBtn;




@property (nonatomic, strong) IQKeyboardReturnKeyHandler *returnKeyHandler;

@property(nonatomic,assign)BOOL isLoginSucceed;

@property (nonatomic, strong) LoginViewModel *viewModel;


@end
