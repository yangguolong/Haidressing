//
//  CDSteper.m
//  Fitroom3D
//
//  Created by 李昌庆 on 15/5/21.
//  Copyright (c) 2015年 Yangjiaolong. All rights reserved.
//

#import "CDSteper.h"

CGFloat const height = 30;
CGFloat const width = 140;
CGFloat const offset = 20;

@interface CDSteper ()<UITextFieldDelegate>

@property (nonatomic,strong) UITextField * contentTextField;

@property (nonatomic,strong) UIButton * leftButton;
@property (nonatomic,strong) UIButton * rightButton;



@end

@implementation CDSteper

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initSome];
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initSome];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initSome];
    }
    return self;
}

-(void)initSome{
    self.frame = CGRectMake(0, 0, width, height);
    
    _contentTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 40, height)];
    
    _contentTextField.borderStyle = UITextBorderStyleNone;
    _contentTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self addSubview:_contentTextField];
    _contentTextField.textAlignment = NSTextAlignmentCenter;
    _contentTextField.delegate = self;
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(contentTextFieldChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    _contentTextField.center = self.center;
    
    self.leftButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, 30, 30)];
    
    [self.leftButton setImage:[UIImage imageNamed:@"icon_subtraction"] forState:UIControlStateNormal];
    
    self.rightButton = [[UIButton alloc]initWithFrame:CGRectMake(width - 40, 0, 30, 30)];
    [self.rightButton setImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateNormal];
    
    [self.leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _leftButton.backgroundColor = [UIColor grayColor];
    _rightButton.backgroundColor = [UIColor grayColor];
    [self addSubview:self.leftButton];
    [self addSubview:self.rightButton];
    [self setupFrame];
}

-(void)setupFrame{
    _contentTextField.center = self.center;
    _leftButton.frame = CGRectMake(offset, offset, _buttonsWidth, _buttonsHeight);
    _rightButton.frame = CGRectMake(self.frame.size.width - offset + _buttonsWidth, offset, _buttonsWidth, _buttonsHeight);
    
}
-(void)setButtonsWidth:(CGFloat)buttonsWidth{
    [self setupFrame];
}
-(void)setButtonsHeight:(CGFloat)buttonsHeight{
    [self setupFrame];
}

-(void)setCurrentValues:(NSInteger)currentValues{
//    _currentValues = currentValues;
    _contentTextField.text = [NSString stringWithFormat:@"%zd",currentValues];
}
-(NSInteger)currentValues{
    return [_contentTextField.text integerValue];
}

-(void)setTextLabelBackgrandColor:(UIColor *)textLabelBackgrandColor{
    _contentTextField.backgroundColor = textLabelBackgrandColor;
}
-(void)leftButtonClick:(UIButton *)bt{
    NSInteger tempValues = [_contentTextField.text integerValue];
    tempValues --;
    if (tempValues < self.minValues) {
        return;
    }
    _contentTextField.text = [NSString stringWithFormat:@"%zd",tempValues];
}
-(void)rightButtonClick:(UIButton *)bt{
    NSInteger tempValues = [_contentTextField.text integerValue];
    tempValues ++;
    if (tempValues > self.maxValues) {
        return;
    }
    _contentTextField.text = [NSString stringWithFormat:@"%zd",tempValues];

}


-(void)contentTextFieldChange:(NSNotification *)noti{
    NSInteger temp = [_contentTextField.text integerValue];
    if (temp > self.maxValues) {
        
        _contentTextField.text = [NSString stringWithFormat:@"%zd",self.maxValues];
    }else if (temp < self.minValues){
        _contentTextField.text = [NSString stringWithFormat:@"%zd",self.minValues];
    }
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSInteger temp = [_contentTextField.text integerValue];
    if (temp > self.maxValues) {
        
        _contentTextField.text = [NSString stringWithFormat:@"%zd",self.maxValues];
    }else if (temp < self.minValues){
        _contentTextField.text = [NSString stringWithFormat:@"%zd",self.minValues];
    }
    

}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self setupFrame];
    
}
//-(void)willMoveToSuperview:(UIView *)newSuperview{
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
