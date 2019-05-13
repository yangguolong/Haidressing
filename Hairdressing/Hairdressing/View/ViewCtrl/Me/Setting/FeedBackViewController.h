//
//  FeedBackViewController.h
//  Hairdressing
//
//  Created by Guolong Yang on 16/4/29.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPlaceHolderTextView.h"
@interface FeedBackViewController : MRCViewController

@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *feedbackTextView;
@property (weak, nonatomic) IBOutlet UITextField *contactTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@end
