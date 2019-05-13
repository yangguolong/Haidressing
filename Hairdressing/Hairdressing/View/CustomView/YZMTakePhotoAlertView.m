//
//  YZMTakePhotoAlertView.m
//  Hairdressing
//
//  Created by Yangjiaolong on 16/5/19.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "YZMTakePhotoAlertView.h"

@interface YZMTakePhotoAlertView ()
@property (weak, nonatomic) IBOutlet UILabel *oneStepLabel;

@property (weak, nonatomic) IBOutlet UILabel *twoStepLabel;

@property (weak, nonatomic) IBOutlet UIImageView *animationImageView;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *maskImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

static  NSString  * kDontNoticeAlertViewForYZMTakePhotoAlertForTake = @"kDontNoticeAlertViewForYZMTakePhotoAlertForTake";
static NSString * kDontNoticeAlertViewForYZMTakePhotoAlertForPain = @"kDontNoticeAlertViewForYZMTakePhotoAlertForPain";
@implementation YZMTakePhotoAlertView



+(void)showWithType:(YZMTakePhotoAlertType)type{
    
    NSString * key = type == YZMTakePhotoAlertForPain ? kDontNoticeAlertViewForYZMTakePhotoAlertForPain:kDontNoticeAlertViewForYZMTakePhotoAlertForTake;
    BOOL dontShow = [[NSUserDefaults standardUserDefaults]boolForKey:key];
    if (dontShow) {
        return;
    }
    
    
    YZMTakePhotoAlertView * alertView = [[[NSBundle mainBundle]loadNibNamed:@"YZMTakePhotoAlertView" owner:self options:nil]lastObject];
    
    
    [alertView changeUIWithType:type];
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    alertView.frame = window.bounds;
    
    [window addSubview:alertView];
}

#pragma mark - Method
-(void)changeUIWithType:(YZMTakePhotoAlertType)type{
    self.currentType = type;

    if (type == YZMTakePhotoAlertForTake) {
        _animationImageView.hidden = YES;
        _maskImageView.hidden = NO;
    }else if (YZMTakePhotoAlertForPain){
        _animationImageView.hidden = NO;
        _maskImageView.hidden = YES;
        
        NSMutableArray * images = [NSMutableArray array];
        for (int i =1 ; i<=16; i++) {
            UIImage * img = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i]];
            [images addObject:img];
        }
        [_animationImageView setAnimationImages:images];
        [_animationImageView setAnimationDuration:3];
        [_animationImageView startAnimating];
        
        _titleLabel.text = @"框选头发区域";
        _oneStepLabel.text = @"1.手指在头发区域划线，系统将自动识别头发区域。";
        _twoStepLabel.text = @"2.使用下方撤销按钮可返回上一步";
        
        
    }
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)iKnowButtonClick:(UIButton *)sender {
    [self removeFromSuperview];
    
}
- (IBAction)dontNoticeButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    NSString * key = _currentType == YZMTakePhotoAlertForPain ? kDontNoticeAlertViewForYZMTakePhotoAlertForPain:kDontNoticeAlertViewForYZMTakePhotoAlertForTake;
    [[NSUserDefaults standardUserDefaults] setBool:sender.selected forKey:key];
    
}

@end