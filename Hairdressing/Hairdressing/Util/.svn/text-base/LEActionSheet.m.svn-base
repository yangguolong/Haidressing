//
//  LEActionSheet.m
//  LEActionSheet
//
//  Created by LEA on 15/9/28.
//  Copyright © 2015年 LEA. All rights reserved.
//

#import "LEActionSheet.h"

#define KWIDTH                      [UIScreen mainScreen].bounds.size.width
#define KHEIGHT                     [UIScreen mainScreen].bounds.size.height
#define BASE_COLOR                  RGBColor(242.0, 242.0, 242.0, 1.0)
#define ROW_HEIGHT                  50

@interface LEActionSheet () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView       *tableView;
@property (nonatomic, strong) UIView            *sheetView;
@property (nonatomic, strong) UIView            *alphaView;
@property (nonatomic, strong) NSMutableArray    *titles;
@property (nonatomic, copy) NSString            *cancelButtonTitle;
@property (nonatomic, copy) NSString            *destructiveButtonTitle;

@end

@implementation LEActionSheet


- (LEActionSheet *)initWithTitle:(NSString *)title delegate:(id<LEActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    self = [super init];
    if (self)
    {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(0, 0, KWIDTH, KHEIGHT);
        
        if (delegate) {
            self.delegate = delegate;
        }
        _title = title;
        _cancelButtonTitle = cancelButtonTitle;
        _destructiveButtonTitle = destructiveButtonTitle;
        
        va_list ap;
        NSString *other = nil;
        if(otherButtonTitles)
        {
            [self.titles addObject:otherButtonTitles];
            va_start(ap, otherButtonTitles);
            while((other = va_arg(ap, NSString*))){
                [self.titles addObject:other];
            }
            va_end(ap);
        }
        if ([destructiveButtonTitle length]) {
            [self.titles insertObject:destructiveButtonTitle atIndex:0];
            self.destructiveButtonIndex = 0;
        }
        if ([cancelButtonTitle length]) {
            [self.titles addObject:cancelButtonTitle];
            self.cancelButtonIndex = [self.titles count]-1;
        }
        
        [self setupUI];
    }
    return self;
}

- (void)tappedCancel
{
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.alphaView.alpha = 0;
                         [self.sheetView setFrame:CGRectMake(0, KHEIGHT, KWIDTH, self.sheetView.frame.size.height)];
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

- (void)showInView:(UIView *)view
{
    [view addSubview:self];
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.alphaView.alpha = 0.5;
                         [self.sheetView setFrame:CGRectMake(0, KHEIGHT-self.sheetView.frame.size.height, KWIDTH, self.sheetView.frame.size.height)];
                     }];
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:buttonIndex inSection:0];
    [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark - UI
-(void)setupUI
{
    //1.add background
    [self addSubview:self.alphaView];
    [self sendSubviewToBack:self.alphaView];
    //2.add cancel gesture
    UITapGestureRecognizer *_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
    [self.alphaView addGestureRecognizer:_tap];
    //3.add handle View
    [self addSubview:self.sheetView];
    [self.sheetView addSubview:self.tableView];
}

#pragma mark - getter
-(UITableView *)tableView
{
    if (_tableView) {
        return _tableView;
    }
    
    _tableView = [[UITableView alloc] initWithFrame:_sheetView.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.alwaysBounceHorizontal = NO;
    _tableView.alwaysBounceVertical = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorColor = TABLEVIEW_BORDER_COLOR;
    _tableView.tableFooterView = [UIView new];
    _tableView.separatorInset = UIEdgeInsetsZero;
    [self addTableHead];
    return _tableView;
}

-(UIView *)alphaView
{
    if (_alphaView) {
        return _alphaView;
    }
    _alphaView = [[UIView alloc] initWithFrame:self.bounds];
    _alphaView.backgroundColor = [UIColor blackColor];
    _alphaView.alpha = 0.0;
    return _alphaView;
}

-(UIView *)sheetView
{
    if (_sheetView) {
        return _sheetView;
    }
    CGFloat addH = [_cancelButtonTitle length]?5:0;
    CGFloat viewH = [self getHeadHeight]+ROW_HEIGHT*[self.titles count]+addH;
    
    _sheetView = [[UIView alloc] initWithFrame:CGRectMake(0, KHEIGHT, KWIDTH, viewH)];
    _sheetView.backgroundColor = BASE_COLOR;
    return _sheetView;
}

-(NSMutableArray *)titles
{
    if (_titles) {
        return _titles;
    }
    _titles = [[NSMutableArray alloc] init];
    return _titles;
}

#pragma mark - methods
-(void)addTableHead
{
    UIView *_head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, [self getHeadHeight])];
    _head.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = _head;
    
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0]};
    CGSize textSize = [_title boundingRectWithSize:CGSizeMake(KWIDTH-40, MAXFLOAT)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:dict
                                           context:nil].size;
    
    UILabel *_lab = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, KWIDTH-40, textSize.height)];
    _lab.text = _title;
    _lab.textAlignment = NSTextAlignmentCenter;
    _lab.textColor = [UIColor grayColor];
    _lab.font = [UIFont systemFontOfSize:14.0];
    _lab.numberOfLines = 0;
    [_head addSubview:_lab];
    
    UIView *_line = [[UIView alloc] initWithFrame:CGRectMake(0, _head.frame.size.height, KWIDTH, 0.5)];
    _line.backgroundColor = TABLEVIEW_BORDER_COLOR;
    [_head addSubview:_line];
}

-(CGFloat)getHeadHeight
{
    CGFloat height = 0;
    if ([_title length])
    {
        NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0]};
        CGSize textSize = [_title boundingRectWithSize:CGSizeMake(KWIDTH-40, MAXFLOAT)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:dict
                                               context:nil].size;
        height += textSize.height+40;
    }
    return height;
}

#pragma mark - tableView delegate/dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titles count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_cancelButtonTitle length] && indexPath.row == [self.titles count]-1) {
        return 55;
    }
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    UILabel *_lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, ROW_HEIGHT)];
    _lab.textColor = [UIColor blackColor];
    _lab.font = [UIFont systemFontOfSize:18.0];
    _lab.textAlignment = NSTextAlignmentCenter;
    _lab.text = [NSString stringWithFormat:@"%@",[self.titles objectAtIndex:indexPath.row]];
    _lab.backgroundColor = [UIColor whiteColor];
    [cell addSubview:_lab];
    
    if ([_destructiveButtonTitle length] && indexPath.row == 0) {
        _lab.textColor = [UIColor redColor];
    }
    if ([_cancelButtonTitle length] && indexPath.row == [self.titles count]-1) {
        _lab.frame = CGRectMake(0, 5, KWIDTH, ROW_HEIGHT);
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)]) {
        [self.delegate actionSheet:self clickedButtonAtIndex:indexPath.row];
    }
    [self tappedCancel];
}

@end
