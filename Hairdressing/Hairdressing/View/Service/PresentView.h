//
//  PresentView.h
//  Hairdressing
//
//  Created by Guolong Yang on 16/4/26.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PresentViewDelegate;

@interface PresentView : UIView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView       *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;

@property (nonatomic, weak) id<PresentViewDelegate> delegate;

- (void)initWithDelegate:(id<PresentViewDelegate>)delegate cellContent:(NSMutableArray *)dataArray withFrame:(CGRect)frame;

@end
@protocol PresentViewDelegate <NSObject>
@optional

//- (void)moduleActionSheet:(ModuleActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

@end
