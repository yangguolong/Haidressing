//
//  YZMCategoryButton.m
//  Hairdressing
//
//  Created by 杨国龙 on 16/3/4.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "YZMCategoryButton.h"

@implementation YZMCategoryButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
//        self.view.backgroundColor = [UIColor blackColor];
//        self = [UIButton buttonWithType:UIButtonTypeCustom];//button的类型
//        self.frame = CGRectMake(100, 100,90, 90);//button的<d>frame</d>
        self.backgroundColor = [UIColor cyanColor];//button的背景颜色
        //  [button setBackgroundImage:[UIImage imageNamed:@"man_64.png"] forState:UIControlStateNormal];
        //  在UIButton中有三个对EdgeInsets的设置：ContentEdgeInsets、titleEdgeInsets、imageEdgeInsets
        [self setImage:[UIImage imageNamed:@"test3"] forState:UIControlStateNormal];//给button添加image
        self.imageEdgeInsets = UIEdgeInsetsMake(5,13,21,self.titleLabel.bounds.size.width);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
        [self setTitle:@"首页" forState:UIControlStateNormal];//设置button的title
        self.titleLabel.font = [UIFont systemFontOfSize:16];//title字体大小
        self.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];//设置title在一般情况下为白色字体
        [self setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];//设置title在button被选中情况下为灰色字体
        self.titleEdgeInsets = UIEdgeInsetsMake(71, -self.titleLabel.bounds.size.width-50, 0, 0);//设置title在button上的位置（上top，左left，下bottom，右right）
        //  [button setContentEdgeInsets:UIEdgeInsetsMake(70, 0, 0, 0)];//
        //  button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//设置button的内容横向居中。。设置content是title和image一起变化
//        [self addTarget:self action:@selector(tap) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:button];

    }
    
    return self;
}



//button相应的事件
-(void)tap {
    NSLog(@"tap a button");
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"hello" message:@"willingseal" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
    [alertView show];
}

@end
