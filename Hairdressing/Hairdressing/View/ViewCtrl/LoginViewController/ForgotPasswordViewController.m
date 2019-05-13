//
//  ForgotPasswordViewController.m
//  MTM
//
//  Created by 李昌庆 on 16/2/18.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "ForgotPasswordViewModel.h"
#import "MRCViewModelServicesImpl.h"
//#import "LoginViewModel.h"
@interface ForgotPasswordViewController ()<UITextFieldDelegate>
{
    int seconds;
    NSTimer  *timer;
}
//@property (strong, nonatomic)  UIButton *avatarButton;
//@property (strong, nonatomic)  UITextField *authCodeField;
//
//@property (strong, nonatomic)  UITextField *usernameField;
//@property (strong, nonatomic)  UITextField *passwordField;
//
//@property (strong, nonatomic)  UIButton *getAuthCodeButton;
//
//@property (strong, nonatomic)  UIButton *refindButton;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *getAuthCodeButton;
@property (weak, nonatomic) IBOutlet UITextField *authCodeField;
@property (weak, nonatomic) IBOutlet UIButton *refindButton;

@property (weak, nonatomic) IBOutlet UIButton *backToLoginBtn;

@property (nonatomic, strong) ForgotPasswordViewModel *viewModel;


@end

@implementation ForgotPasswordViewController

@dynamic viewModel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor  = [UIColor whiteColor];
    [self initViews];
    // 监听return健
    @weakify(self)
    [[self rac_signalForSelector:@selector(textFieldShouldReturn:)
                    fromProtocol:@protocol(UITextFieldDelegate)]
     subscribeNext:^(RACTuple *tuple) {
         @strongify(self)
         if (tuple.first == self.passwordField) {
             [self.viewModel.findpasswordButtonCommand execute:nil];
         }
     }];
    self.passwordField.delegate = self;
}
#pragma mark -- 初始化子视图
- (void)initViews
{
    
}

- (void)bindViewModel
{
    [super bindViewModel];
    
//    self.viewModel = [[ForgotPasswordViewModel alloc] initWithServices:[[MRCViewModelServicesImpl alloc] init] params:nil];
    
    RAC(self.viewModel, username) = self.usernameField.rac_textSignal;
    RAC(self.viewModel, password) = self.passwordField.rac_textSignal;
    RAC(self.viewModel, authCode) = self.authCodeField.rac_textSignal;
    
    @weakify(self)
    [[RACSignal merge:@[self.viewModel.findpasswordButtonCommand.executing]]
     subscribeNext:^(NSNumber *executing) {
         if (executing.boolValue) {
             [self.view endEditing:YES];
             [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES].labelText = @"正在加载...";
         }else {
             [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
         }
     }];
    
    // 错误处理
    [[RACSignal merge:@[self.viewModel.findpasswordButtonCommand.errors]]
     subscribeNext:^(NSError *error) {
         //         @strongify(self)
         if ([error isKindOfClass:[NSString class]]) {
             MRCError((NSString *)error);
         }else {
             MRCError(error.localizedDescription);
             
         }
     }];
    
    RAC(self.refindButton, enabled) = self.viewModel.validRegistSignal;
    RAC(self.getAuthCodeButton, enabled) = self.viewModel.validPhoneSignal;
    RAC(self.refindButton,backgroundColor) = [self.viewModel.validPhoneSignal map:^id(NSNumber *getCodeValid) {
        return [getCodeValid boolValue]?[UIColor blackColor]:[UIColor lightGrayColor];
    }];
    [RACObserve(self.getAuthCodeButton, enabled) subscribeNext:^(NSNumber *vaild) {
        if ([vaild boolValue]) {
            [self.getAuthCodeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        else
            [self.getAuthCodeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }];
    // 监听按钮点击
    [[self.refindButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self)
         if (self.authCodeField.text.length !=4) {
             MRCInfo(@"验证码格式错误");
         }
         else if (![Utility vefifyPhoneNumber:self.usernameField.text]) {
             MRCInfo(@"手机号码填写错误!");
             
         }
         else if (self.passwordField.text.length<6 ||self.passwordField.text.length>16 ) {
             MRCInfo(@"密码须不少于6位并且不多于16位");
             
         }
         else
             [self.viewModel.findpasswordButtonCommand execute:nil];
     }];
    
    [[self.getAuthCodeButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self)
         [self.viewModel.getAuthCodeCommand execute:nil];
         //打开定时器计时
         if (!timer) {
             //建立定时器
             timer =[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
             self.getAuthCodeButton.userInteractionEnabled =NO;
             seconds = 60;
             [self.getAuthCodeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
             [self.getAuthCodeButton setTitle:[NSString stringWithFormat:@"%d秒后重发",seconds] forState:UIControlStateNormal];
         }
     }];
    [[self.backToLoginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self.viewModel.services popViewModelAnimated:YES];
    }];
}

-(void)countDown{
    seconds --;
    [self.getAuthCodeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.getAuthCodeButton setTitle:[NSString stringWithFormat:@"%d秒后重发",seconds] forState:UIControlStateNormal];
    if (seconds == 0) {
        [timer invalidate];
        timer = nil;
        [self.getAuthCodeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.getAuthCodeButton setTitle:@"重新获取" forState:UIControlStateNormal];
        self.getAuthCodeButton.userInteractionEnabled =YES;
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (DEVICE_IS_IPHONE5) {
        CGRect rect = self.view.frame;
        if (rect.origin.y < TOP_BAR_HEIGHT) {
            rect.origin.y = rect.origin.y+55;
        }
        
        self.view.frame = rect;

    }
    [self.view endEditing:YES];
}
#pragma mark --uitextfield delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (DEVICE_IS_IPHONE5) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            CGRect rect = self.view.frame;
            if (rect.origin.y==TOP_BAR_HEIGHT) {
                rect.origin.y = rect.origin.y-55;
            }
            
            self.view.frame = rect;
        });
    }
    
    
    return YES;
    
}
@end
