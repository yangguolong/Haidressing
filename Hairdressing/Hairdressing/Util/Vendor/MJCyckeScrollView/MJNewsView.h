//
//  MJNewsView.h
//  预习-03-无限滚动
//
//  Created by MJ Lee on 14-5-30.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJNewsModel.h"

@interface MJNewsView : UIView
@property (strong, nonatomic) NSArray<MJNewsModel *> *newses;

//+ (instancetype)newsView;
@end
