//
//  LoginViewController.m
//  Hairdressing
//
//  Created by admin on 16/3/26.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginViewModel.h"
#import "MRCViewModelServices.h"
//#import "IQKeyboardReturnKeyHandler.h"


@interface LoginViewController ()<UITextFieldDelegate>



@end

@implementation LoginViewController
@dynamic viewModel;
- (void)viewDidLoad {
    [super viewDidLoad];

    [self initNavBar];
    [self initViews];
    // [self bindViewModel];
    self.view.backgroundColor  = [UIColor whiteColor];
}

-(void)initNavBar{
    UIImage *cancelImage = [UIImage imageNamed:@"nav_back"];
    self.cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.height/2-cancelImage.size.height/2, cancelImage.size.width,cancelImage.size.height)];
//    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
//    [self.cancelButton.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
    [self.cancelButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.cancelButton setBackgroundImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    
    [self.view addSubview:self.cancelButton];
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithCustomView:self.cancelButton];
//    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
//                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
//                                       target:nil action:nil];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:cancelItem, nil];
    
}


#pragma mark -- 初始化子视图
- (void)initViews
{
    
    self.usernameField.leftViewMode = UITextFieldViewModeAlways;
    self.usernameField.delegate = self;
    UIImage *userNameLeftImage =[UIImage imageNamed:@"login_pn_n"];
    UIImageView *userNameLeftView = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.usernameField.size.height/2-userNameLeftImage.size.height/2, userNameLeftImage.size.width, userNameLeftImage.size.height)];
    userNameLeftView.image = userNameLeftImage;
    self.usernameField.leftView  = userNameLeftView;
    
    self.passwordField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordField.delegate =self;
    UIImage *userNameRightImage =[UIImage imageNamed:@"login_pw_n"];
    UIImageView *userNameRightView = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.passwordField.size.height/2-userNameRightImage.size.height/2, userNameRightImage.size.width, userNameRightImage.size.height)];
    userNameRightView.image = userNameRightImage;
    self.passwordField.leftView  = userNameRightView;
    
}

-(void)bindViewModel{
    [super bindViewModel];
    @weakify(self)
//    [RACObserve(self.viewModel, avatarURLStr) subscribeNext:^(NSString *avartURLStr) {
//        @strongify(self)
//        dispatch_async(dispatch_get_main_queue(), ^{
//           [self.avatarButton sd_setImageWithURL:[NSURL URLWithString:avartURLStr] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default-avatar"]];
////            [self.avatarButton setImage:[UIImage imageNamed:@"default-avatar"] forState:UIControlStateNormal];
//        });
//
//    }];
    
//    [[self.avatarButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *avatarButton) {
//        @strongify(self)
//        [UIApplication sharedApplication].delegate.window.backgroundColor = [UIColor blackColor]    ;
//        TGRImageViewController *viewController = [[TGRImageViewController alloc] initWithImage:[avatarButton imageForState:UIControlStateNormal]];
//        
//        viewController.view.frame = CGRectMake(0, 0, kWidth, kHeight);
//        viewController.transitioningDelegate = self;
//        
//        [self presentViewController:viewController animated:YES completion:NULL];
//    }];
    
    RAC(self.viewModel,username)= self.usernameField.rac_textSignal;
    RAC(self.viewModel,password) = self.passwordField.rac_textSignal;
    
    //手机号最多输入11位的数字
    RAC(self.usernameField,text) = [self.usernameField.rac_textSignal map:^id(NSString *value) {
        if (value.length>11) {
            return [value substringToIndex:11];
        }
        else
            return value;
    }];
    
    //密码最多输入16位的非特殊字符
    RAC(self.passwordField,text) = [self.passwordField.rac_textSignal map:^id(NSString *value) {
        if (value.length>16) {
            return [value substringToIndex:16];
        }
        else
            return value;
    }];
    
    [self.viewModel.loginCommand.executing
     subscribeNext:^(NSNumber *executing) {
         @strongify(self);
         if (executing.boolValue) {
             
             [self.view endEditing:YES];
             [MBProgressHUD showHUDAddedTo:self.view animated:YES].labelText = @"正在登录...";
         }else{
             [MBProgressHUD hideHUDForView:self.view animated:YES];
         }
     }];
    
    // 错误处理
    [self.viewModel.loginCommand.errors
     subscribeNext:^(NSError *error) {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         NSLog(@"login error:%@",error);
         if ([error isEqual:@"参数错误"]) {
            MRCError(@"用户名或密码错误");
         }
         else
         {
            MRCError(@"登录失败");
         }
         
         
     }];
    
    RAC(self.loadButton,enabled) = self.viewModel.validLoginSignal;
    [[self.loadButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self)
         [self.viewModel.loginCommand execute:nil];
     }];
    
    RAC(self.loadButton,backgroundColor) = [self.viewModel.validLoginSignal map:^id(NSNumber *loginValid) {
        return [loginValid boolValue]?[UIColor blackColor]:[UIColor lightGrayColor];
    }];
    
    [[self.cancelButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *cancelBtn) {
        @strongify(self)
        [self.viewModel.cancelCommand execute:nil];
    }];
    
//    self.registerBtn.rac_command = self.viewModel.registCommand;
//    self.forgetPasswordBtn.rac_command = self.viewModel.forgotPasswordCommand;
    
    [[self.registerBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self.viewModel.registCommand execute:nil];
    }];
    [[self.forgetPasswordBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self.viewModel.forgotPasswordCommand execute:nil];
    }];
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (DEVICE_IS_IPHONE5) {
        CGRect rect = self.view.frame;
        if (rect.origin.y < TOP_BAR_HEIGHT) {
            rect.origin.y = rect.origin.y+50;
        }
        
        self.view.frame = rect;

    }
    [self.view endEditing:YES];
}
#pragma mark --uitextfield delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (DEVICE_IS_IPHONE5) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            CGRect rect = self.view.frame;
            if (rect.origin.y==TOP_BAR_HEIGHT) {
                rect.origin.y = rect.origin.y-50;
            }
            
            self.view.frame = rect;
        });
    }


    return YES;

}

//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleDefault;
//}

//#pragma mark - UIViewControllerTransitioningDelegate
//
//- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
//    if ([presented isKindOfClass:TGRImageViewController.class]) {
//        return [[TGRImageZoomAnimationController alloc] initWithReferenceImageView:self.avatarButton.imageView];
//    }
//    return nil;
//}
//
//- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
//    if ([dismissed isKindOfClass:TGRImageViewController.class]) {
//        return [[TGRImageZoomAnimationController alloc] initWithReferenceImageView:self.avatarButton.imageView];
//    }
//    return nil;
//}

//-(void)verification{
//
//    [self dismissViewControllerAnimated:NO completion:nil];
//}
//-(void)retrievePwd{
//
//}
//-(void)registerUser{
//
//}


@end