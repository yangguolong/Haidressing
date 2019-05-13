//
//  YZMOrderListViewCtrl.h
//  Hairdressing
//
//  Created by yzm on 16/4/14.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "MRCTableViewController.h"

@interface YZMOrderListViewCtrl : MRCTableViewController <UITableViewDataSource , UITableViewDelegate ,UIScrollViewDelegate>


//左右滑动部分
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;


@property (weak, nonatomic) IBOutlet UIButton *button0;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UIButton *button4;

/** 指示作用 */
@property (weak, nonatomic) IBOutlet UILabel *slidLabel;


@end
