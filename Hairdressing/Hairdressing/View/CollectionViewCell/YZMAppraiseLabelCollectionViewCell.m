//
//  YZMAppraiseLabelCollectionViewCell.m
//  Hairdressing
//
//  Created by Yangjiaolong on 16/6/1.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "YZMAppraiseLabelCollectionViewCell.h"

@interface YZMAppraiseLabelCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation YZMAppraiseLabelCollectionViewCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        

    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        self.selectedBackgroundView = [[UIView alloc]init];
        self.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:1 green:179/255.f blue:43/255.f alpha:1];
        self.layer.cornerRadius = 5;
        self.layer.borderWidth = 2;
        self.layer.borderColor = [UIColor colorWithWhite:211/255.f alpha:1].CGColor;
        self.clipsToBounds = YES;
    }
    return self;
}

-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    _button.selected = selected;
}
-(void)awakeFromNib{
    

}
-(void)updateUIWithModel:(YZMAppraiseLabelModel *)model{
    _button.selected = model.isSelect;
    [_button setTitle:model.label forState:UIControlStateNormal];
    [_button setTitle:model.label forState:UIControlStateSelected];
}


@end
