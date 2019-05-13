//
//  ModuleActionSheet.m
//  ModuleActionSheet
//
//  Created by LEA on 16/3/2.
//  Copyright © 2016年 LEA. All rights reserved.
//

#import "ModuleActionSheet.h"
#import "ServiceCell.h"
#import "ServiceCategories.h"
#define KWIDTH                      [UIScreen mainScreen].bounds.size.width
#define KHEIGHT                     [UIScreen mainScreen].bounds.size.height
#define RGBColor(r,g,b,a)           ([UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a])
#define BASE_COLOR                  RGBColor(242.0, 242.0, 242.0, 1.0)
#define TABLEVIEW_BORDER_COLOR      RGBColor(231.0, 231.0, 231.0, 1.0)
#define ROW_HEIGHT                  50

@interface ModuleActionSheet ()<UITableViewDataSource,UITableViewDelegate,ServiceCellDelegate>
{


}
@property (nonatomic, strong) NSMutableArray *serviceArray;
@property (nonatomic, strong) UITableView       *tableView;
@property (nonatomic, strong) UIView            *sheetView;
@property (nonatomic, strong) UIView            *alphaView;
@property (nonatomic, strong) NSMutableArray    *titles;
@property (nonatomic, strong) NSMutableArray    *imageNames;

@end

@implementation ModuleActionSheet


- (ModuleActionSheet *)initWithDelegate:(id<ModuleActionSheetDelegate>)delegate imageNames:(NSArray *)imageNames titles:(NSArray *)titles
{
    self = [super init];
    if (self)
    {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(0, 0, KWIDTH, KHEIGHT);
        
        //传值
        if (delegate) {
            self.delegate = delegate;
        }
        [self.titles addObjectsFromArray:titles];
        [self.imageNames addObjectsFromArray:imageNames];
        
        //视图
        [self setUpUI];
    }
    return self;
}
- (ModuleActionSheet *)initWithDelegate:(id<ModuleActionSheetDelegate>)delegate cellContent:(NSMutableArray *)serviceArray
{
    self = [super init];
    if (self)
    {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(0, 0, KWIDTH, KHEIGHT);
        
        //传值
        if (delegate) {
            self.delegate = delegate;
        }
        self.serviceArray = serviceArray;
//        [self.titles addObjectsFromArray:titles];
//        [self.imageNames addObjectsFromArray:imageNames];
        
        //视图
        [self setUpUI];
    }
    return self;
}

- (void)tappedCancel
{
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.alphaView.alpha = 0;
                         [self.sheetView setFrame:CGRectMake(0, KHEIGHT-50, KWIDTH, self.sheetView.frame.size.height)];
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
                         [self.sheetView setFrame:CGRectMake(0, KHEIGHT-self.sheetView.frame.size.height-50, KWIDTH, self.sheetView.frame.size.height)];
                     }];
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:buttonIndex inSection:0];
    [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark - UI
-(void)setUpUI
{
    //1.添加背景
    [self addSubview:self.alphaView];
    [self sendSubviewToBack:self.alphaView];
    
    //2.添加取消手势
    UITapGestureRecognizer *_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
    [self.alphaView addGestureRecognizer:_tap];
    
    //3.添加sheetView
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
    _tableView.rowHeight = ROW_HEIGHT;
    _tableView.separatorInset = UIEdgeInsetsZero;

    return _tableView;
}

-(UIView *)alphaView
{
    if (!_alphaView) {
        _alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWIDTH, KHEIGHT-50)];
        _alphaView.backgroundColor = [UIColor blackColor];
        _alphaView.alpha = 0.0;
    }
    return _alphaView;
}

-(UIView *)sheetView
{
    if (!_sheetView) {
        _sheetView = [[UIView alloc] initWithFrame:CGRectMake(0,KHEIGHT - 100, KWIDTH, ROW_HEIGHT*[self.serviceArray count])];
        _sheetView.backgroundColor = BASE_COLOR;
    }
    return _sheetView;
}

-(NSMutableArray *)titles
{
    if (!_titles) {
        _titles = [[NSMutableArray alloc] init];
    }
    return _titles;
}

-(NSMutableArray *)imageNames
{
    if (!_imageNames) {
        _imageNames = [[NSMutableArray alloc] init];
    }
    return _imageNames;
}

#pragma mark - tableView delegate/dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.serviceArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    ServiceCategories *categories = [self.serviceArray objectAtIndex:indexPath.row];
    ServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ServiceCell" owner:self options:nil] lastObject];
    }
    cell.tag = indexPath.row;
    cell.delegate = self;
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
    if ([self.delegate respondsToSelector:@selector(moduleActionSheet:clickedButtonAtIndex:)]) {
        [self.delegate moduleActionSheet:self clickedButtonAtIndex:indexPath.row];
    }
    [self tappedCancel];
}

//-(void)ChangeCountOfCell:(ServiceCell *)cell{
//    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:cell.tag];
//    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
//    
//}
@end
