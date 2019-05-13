//
//  RegistViewController.m
//  MTM
//
//  Created by 杨国龙 on 16/1/27.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "RegistViewController.h"
#import "TWMessageBarManager.h"
#import "MRCViewModelServicesImpl.h"
#import "RegistViewModel.h"

@interface RegistViewController () <UITextFieldDelegate>
{
    int seconds;
    NSTimer  *timer;
}



@property (nonatomic, strong) RegistViewModel *viewModel;


//@property (strong, nonatomic)  UIButton *avatarButton;
//@property (strong, nonatomic)  UITextField *authCodeField;
//
//@property (strong, nonatomic)  UITextField *usernameField;
//@property (strong, nonatomic)  UITextField *passwordField;
//
//@property (strong, nonatomic)  UIButton *getAuthCodeButton;
//
//@property (strong, nonatomic)  UIButton *registButton;

@property (weak, nonatomic) IBOutlet UITextField *usernameField;

@property (weak, nonatomic) IBOutlet UITextField *authCodeField;

@property (weak, nonatomic) IBOutlet UIButton *getAuthCodeButton;

@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (weak, nonatomic) IBOutlet UIButton *registButton;

@property (weak, nonatomic) IBOutlet UIButton *backToLoginBtn;
@end


@implementation RegistViewController
@dynamic viewModel;


- (void)viewDidLoad
{
    [super viewDidLoad];
     self.view.backgroundColor  =[UIColor whiteColor];
    [self initViews];
    // 监听return健
    @weakify(self)
    [[self rac_signalForSelector:@selector(textFieldShouldReturn:)
                    fromProtocol:@protocol(UITextFieldDelegate)]
     subscribeNext:^(RACTuple *tuple) {
         @strongify(self)
         if (tuple.first == self.passwordField) {
             [self.viewModel.registCommand execute:nil];
         }
     }];
    self.passwordField.delegate = self;
//    [[self.agreementButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton * btn) {
//        btn.selected = !btn.selected;
//    }];
    [self.getAuthCodeButton setTintColor:[UIColor blueColor]];
    

    
    
}
#pragma mark -- 初始化子视图
- (void)initViews
{
    
}


- (void)bindViewModel
{
    [super bindViewModel];

    RAC(self.viewModel, username) = self.usernameField.rac_textSignal;
    RAC(self.viewModel, password) = self.passwordField.rac_textSignal;
    RAC(self.viewModel, authCode) = self.authCodeField.rac_textSignal;
    @weakify(self)
    
    [[RACSignal merge:@[self.viewModel.registCommand.executing]]
                subscribeNext:^(NSNumber *executing) {
                    if (executing.boolValue) {
                        [self.view endEditing:YES];
                        [MBProgressHUD showHUDAddedTo:self.view animated:YES].labelText = @"正在注册...";
                    }else {
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                    }
                }];
    
    // 错误处理
    [[RACSignal merge:@[self.viewModel.registCommand.errors]]
     subscribeNext:^(NSError *error) {
//         @strongify(self)
         if ([error isKindOfClass:[NSString class]]) {
             MRCError((NSString *)error);
         }else {
             MRCError(error.localizedDescription);
             
         }
     }];
    
    RAC(self.registButton, enabled) = self.viewModel.validRegistSignal;
    RAC(self.getAuthCodeButton, enabled) = self.viewModel.validPhoneSignal;
    RAC(self.registButton,backgroundColor) = [self.viewModel.validPhoneSignal map:^id(NSNumber *getCodeValid) {
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
    [[self.registButton rac_signalForControlEvents:UIControlEventTouchUpInside]
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
             [self.viewModel.registCommand execute:nil];
     }];

    [[self.getAuthCodeButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self)
         //暂时关闭
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
@end
