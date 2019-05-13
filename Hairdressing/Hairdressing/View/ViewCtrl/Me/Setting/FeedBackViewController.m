//
//  FeedBackViewController.m
//  Hairdressing
//
//  Created by Guolong Yang on 16/4/29.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "FeedBackViewController.h"
#import "FeedBackViewModel.h"
@interface FeedBackViewController ()
@property(nonatomic,strong,readonly) FeedBackViewModel *viewModel;
@end

@implementation FeedBackViewController
@dynamic viewModel;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    // Do any additional setup after loading the view from its nib.
    self.feedbackTextView.layer.borderColor = [UIColor grayColor].CGColor;
    self.feedbackTextView.layer.borderWidth = 0.5;
    self.feedbackTextView.layer.cornerRadius = 5.0;
    self.feedbackTextView.placeholder = @"想反馈些什么呢？";
    
    [[self.submitButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self.viewModel.feedBackCommand execute:nil];
    }];
}

-(void)bindViewModel{

    RAC(self.viewModel,contact_way)= self.feedbackTextView.rac_textSignal;
    RAC(self.viewModel,content) = self.contactTextField.rac_textSignal;
    
    RAC(self.submitButton,enabled) = self.viewModel.validFeedBackSignal;
    RAC(self.submitButton,backgroundColor) = [self.viewModel.validFeedBackSignal map:^id(NSNumber *feedbackValid) {
        return [feedbackValid boolValue]?[UIColor blackColor]:[UIColor lightGrayColor];
    }];
}




- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}



@end