//
//  YZMProductListViewCtrl.m
//  Hairdressing
//
//  Created by 杨国龙 on 16/3/7.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "YZMProductListViewCtrl.h"
#import "YZMDropDownMenu.h"
#import "YZMProductTableViewCell.h"
#import "YZMFilterView.h"
#import "YZMProductDetailsViewCtrl.h"

typedef enum {
    YZMProductListViewCtrlColumnSort = 0,
    YZMProductListViewCtrlColumnArea,
}YZMProductListViewCtrlColumn;

@interface YZMProductListViewCtrl () <YZMDropDownMenuDataSource,YZMDropDownMenuDelegate>
{
    NSInteger _currentSortDataIndex;
    NSInteger _currentAreaDataIndex;
}

@property (nonatomic, strong) NSMutableArray *sortData;
@property (nonatomic, strong) NSMutableArray *areaData;

@property (nonatomic, strong) YZMDropDownMenu *menu;

@end

@implementation YZMProductListViewCtrl

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
   
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}


#pragma mark - UITableViewDelegate 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZMProductDetailsViewCtrl *vc = [[YZMProductDetailsViewCtrl alloc] initWithNibName:NSStringFromClass([YZMProductDetailsViewCtrl class]) bundle:[NSBundle mainBundle]];
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YZMProductTableViewCell *cell = [self tableView:tableView dequeueReusableCellWithIdentifier:[YZMProductTableViewCell indentifier] forIndexPath:indexPath];
    
//    id object = self.viewModel.dataSource[indexPath.section][indexPath.row];
//    [self configureCell:cell atIndexPath:indexPath withObject:(id)object];
//    [[UIImage imageNamed:@""] resizableImageWithCapInsets:(UIEdgeInsets)]
    
    return cell;
}




#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 15;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [YZMProductTableViewCell cellHeight];
}

#pragma mark - YZMDropDownMenuDataSource

- (NSInteger)numberOfColumnsInMenu:(YZMDropDownMenu *)menu
{
    return 2;
}

- (BOOL)displayByCollectionViewInColumn:(NSInteger)column
{
    if (column == YZMProductListViewCtrlColumnSort) {
        return YES;
    }
    
    return NO;
}

- (BOOL)haveRightTableViewInColumn:(NSInteger)column
{
//    if (column == YZMProductListViewCtrlColumnService || column == YZMProductListViewCtrlColumnArea) {
//        return YES;
//    }
    return NO;
}

- (CGFloat)widthRatioOfLeftColumn:(NSInteger)column
{
//    if (column == YZMProductListViewCtrlColumnService || column == YZMProductListViewCtrlColumnArea) {
//        return 0.35;
//    }
    return 1;
}

- (NSInteger)currentLeftSelectedRow:(NSInteger)column
{
    if (column == YZMProductListViewCtrlColumnSort) {
        return _currentSortDataIndex;
    }
    if (column == YZMProductListViewCtrlColumnArea) {
        return _currentAreaDataIndex;
    }
    
    return 0;
}

- (NSInteger)menu:(YZMDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow
{
    if (column == YZMProductListViewCtrlColumnSort) {
        
            return self.sortData.count;
   
    } else if (column == YZMProductListViewCtrlColumnArea ) {
        
        if ( leftOrRight == 0 ) {
            
            return self.areaData.count;
        } else {
            
            NSDictionary *areaData = [self.areaData objectAtIndex:leftRow];
            return [[areaData objectForKey:@"data"] count];
        }
        
    }
    
    return 0;
}

/**
 *  设置行标题
 *
 *  @param menu
 *  @param column
 *
 *  @return
 */
- (NSString *)menu:(YZMDropDownMenu *)menu titleForColumn:(NSInteger)column
{
    switch (column) {
        case YZMProductListViewCtrlColumnArea:
            return [[self.areaData[0] objectForKey:@"data"] objectAtIndex:0];
            break;
            

        case YZMProductListViewCtrlColumnSort:
            return self.sortData[0];
            break;

        default:
            return nil;
            break;
    }
}

/**
 *  设置顶部按钮的title
 *
 *  @param menu
 *  @param indexPath
 *
 *  @return
 */
- (NSString *)menu:(YZMDropDownMenu *)menu titleForRowAtIndexPath:(YZMIndexPath *)indexPath
{
    if (indexPath.column == YZMProductListViewCtrlColumnSort) {
        return self.sortData[indexPath.row];
    
    } else if (indexPath.column == YZMProductListViewCtrlColumnArea) {
        if (indexPath.leftOrRight == 0) {
            NSDictionary *menuDic = [self.areaData objectAtIndex:indexPath.row];
            return menuDic[@"title"];
        } else {
            NSInteger leftRow = indexPath.leftRow;
            NSDictionary *menuDic = [self.areaData objectAtIndex:leftRow];
            return [menuDic[@"data"] objectAtIndex:indexPath.row];
        }
    }

    return @"";
}

- (void)menu:(YZMDropDownMenu *)menu didSelectRowAtIndexPath:(YZMIndexPath *)indexPath
{
    if (indexPath.column == YZMProductListViewCtrlColumnSort) {
        _currentSortDataIndex = indexPath.row;

    } else if (indexPath.row == YZMProductListViewCtrlColumnArea) {
        if (indexPath.leftOrRight == 0) {
            
            _currentAreaDataIndex = indexPath.row;
        }
    }

}


#pragma mark - setter and getter

- (NSMutableArray *)sortData
{
    if (_sortData == nil) {
        _sortData = [NSMutableArray arrayWithObjects:@"智能排序", @"离我最近", @"人气最高", @"环境最佳", @"服务最佳", @"价格最低", nil];
    }
    return _sortData;
}


- (NSMutableArray *)areaData
{
    if (_areaData == nil) {
        NSArray *ShenZhenArea = @[@"罗湖区", @"福田区", @"南山区", @"宝安区", @"龙岗区", @"盐田区"];
        NSArray *GuangZhouArea = @[@"越秀区", @"海珠区", @"荔湾区", @"天河区", @"白云区", @"等等"];
        _areaData = [NSMutableArray arrayWithObjects:@{@"title" : @"深圳", @"data":ShenZhenArea} , @{@"title" : @"广州", @"data":GuangZhouArea}, nil];
    }
    return _areaData;
}

- (YZMDropDownMenu *)menu
{
    if (_menu == nil) {
        _menu = [[YZMDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:45];
        _menu.indicatorColor = [UIColor redColor];
        _menu.separatorColor = [UIColor blackColor];
        _menu.textColor = [UIColor blackColor];
        _menu.dataSource = self;
        _menu.delegate = self;
    }
    
    return _menu;
}


@end
