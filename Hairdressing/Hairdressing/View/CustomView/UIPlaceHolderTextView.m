//
//  UIPlaceHolderTextView.m
//  Hairdressing
//
//  Created by Guolong Yang on 16/4/29.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "UIPlaceHolderTextView.h"

@implementation UIPlaceHolderTextView


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addNotification];
    }
    return self;
}


-(void)awakeFromNib{
    [self addNotification];

}
-(void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidBeginEditing:) name:UITextViewTextDidBeginEditingNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidEndEditing:) name:UITextViewTextDidEndEditingNotification object:self];

}

-(void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidBeginEditingNotification object:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidEndEditingNotification object:self];
}

-(void)textDidBeginEditing:(NSNotification *)notification{
    NSLog(@"textDidBeginEditing");
    if ([super.text isEqualToString:_placeholder]) {
        super.text = @"";
        [super setTextColor:[UIColor blackColor]];
    }
}

-(void)textDidEndEditing:(NSNotification *)notification{
    NSLog(@"textDidEndEditing");
    if (super.text.length == 0) {
        super.text  = _placeholder;
        [super setTextColor:[UIColor lightGrayColor]];
    }
}

-(void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    [self textDidEndEditing:nil];
}

-(NSString *)text{
    NSString *text = [super text];
    if ([text isEqualToString:_placeholder]) {
        return @"";
    }
    return text;
}


@end
