//
//  PresentView.m
//  Hairdressing
//
//  Created by Guolong Yang on 16/4/26.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "PresentView.h"
#import "ServiceCategories.h"
#import "ServiceCell.h"

@implementation PresentView

- (void)initWithDelegate:(id<PresentViewDelegate>)delegate cellContent:(NSMutableArray *)dataArray withFrame:(CGRect)frame
{
    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor clearColor];
    self.frame = frame;
    
    //传值
    if (delegate) {
        self.delegate = delegate;
    }
    self.dataArray = dataArray;

    //视图
    [self setUpUI];

}


#pragma mark - UI
-(void)setUpUI
{
    //1.添加背景
    [self addSubview:self.tableView];
}
#pragma mark - getter
-(UITableView *)tableView
{
    if (_tableView) {
        return _tableView;
    }
    _tableView = [[UITableView alloc] initWithFrame:self.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.alwaysBounceHorizontal = NO;
    _tableView.alwaysBounceVertical = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorColor = TABLEVIEW_BORDER_COLOR;
    _tableView.tableFooterView = [UIView new];
    _tableView.rowHeight = TABLEVIEW_ROW_HEIGHT;
    _tableView.separatorInset = UIEdgeInsetsZero;
    
    return _tableView;
}

#pragma mark - tableView delegate/dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    ServiceCategories *categories = [self.dataArray objectAtIndex:indexPath.row];
    ServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ServiceCell" owner:self options:nil] lastObject];
    }
    cell.tag = indexPath.row;
  //  cell.delegate = self;
    cell.servicePrice.text = [NSString stringWithFormat:@"%@",categories.price];
    cell.serviceType.text = categories.item_name;

    //    cell.textLabel.text = self.titles[indexPath.row];
    //    cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    //    cell.textLabel.textColor = [UIColor grayColor];
    //    cell.imageView.image = [UIImage imageNamed:self.imageNames[indexPath.row]];
    //    cell.backgroundColor = [UIColor whiteColor];
    //    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if ([self.delegate respondsToSelector:@selector(moduleActionSheet:clickedButtonAtIndex:)]) {
//        [self.delegate moduleActionSheet:self clickedButtonAtIndex:indexPath.row];
//    }
 //   [self tappedCancel];
}


@end