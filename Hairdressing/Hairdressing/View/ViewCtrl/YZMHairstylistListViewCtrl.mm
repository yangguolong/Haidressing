//
//  YZMHairstylistListViewCtrl.m
//  Hairdressing
//
//  Created by yzm on 16/4/12.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "YZMHairstylistListViewCtrl.h"
#import "YZMDropDownMenu.h"
#import "YZMHairstylistTableViewCell.h"
#import "YZMHairstylistListViewModel.h"
#import "MJRefresh.h"
#import "MRCNetworkHeaderView.h"
#import "AppDelegate.h"


typedef enum {
    YZMProductListViewCtrlColumnSort = 0,
    YZMProductListViewCtrlColumnArea,

}YZMProductListViewCtrlColumn;

#define kCellPadding        16
#define kColumn             2

@interface YZMHairstylistListViewCtrl ()<YZMDropDownMenuDataSource,YZMDropDownMenuDelegate>

@property (nonatomic, strong) NSMutableArray *sortData;
@property (nonatomic, strong) NSMutableArray *areaData;

@property (nonatomic ,assign) NSInteger currentSortDataIndex;
@property (nonatomic ,assign) NSInteger currentAreaDataIndex;


@property (nonatomic, strong) YZMDropDownMenu *menu;

@property (nonatomic, strong) YZMHairstylistListViewModel * viewModel;


@end

@implementation YZMHairstylistListViewCtrl


@dynamic viewModel;

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.menu];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YZMHairstylistTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([YZMHairstylistTableViewCell class])];
    
    self.tableView.rowHeight = 200;// UITableViewAutomaticDimension;
//    self.tableView.estimatedRowHeight = 160.0;
     self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.viewModel.requestRemoteDataCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        [self.viewModel.dataSource addObject:x];
        [self reloadData];
    }];
    
    [[RACObserve(self.viewModel, areaId) skip:1] subscribeNext:^(id x) {
        
        [self.tableView.mj_header beginRefreshing];
    }];
    
    [[RACObserve(self.viewModel, sortTypeId) skip:1]  subscribeNext:^(id x) {
        [self.tableView.mj_header beginRefreshing];
    }];
    
    @weakify(self)
    [[RACObserve(self, currentSortDataIndex) skip:1] subscribeNext:^(NSNumber *index) {
        @strongify(self)
        self.viewModel.sortTypeId = @(index.integerValue+1);
    }];
    [[RACObserve(self, currentAreaDataIndex) skip:1]subscribeNext:^(NSNumber *index) {
        @strongify(self)
        self.viewModel.areaId = self.areaData[index.integerValue][@"district_id"];
    }];
    
    [self.viewModel.requestRemoteDataCommand.executing subscribeNext:^(NSNumber *executing) {
        @strongify(self)
        if (executing.boolValue) {
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES].labelText = MBPROGRESSHUD_LABEL_TEXT;
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];
    
    
    [self.viewModel.requestRemoteDataCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        @strongify(self)
        if (self.viewModel.page == 1) {
            [self.viewModel.dataSource removeAllObjects];
        }
        [self.viewModel.dataSource addObject:x];
        [self reloadData];
    }];
    
    // 监听网络状态
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    
    MRCNetworkHeaderView *networkHeaderView = [NSBundle.mainBundle loadNibNamed:@"MRCNetworkHeaderView" owner:nil options:nil].firstObject;
    networkHeaderView.frame = tableHeaderView.bounds;
    networkHeaderView.titleLabel.text = @"当前网络不可用，请检查你的网络";
    [tableHeaderView addSubview:networkHeaderView];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    RAC(self.tableView, tableHeaderView) = [RACObserve(delegate, networkStatus) map:^id(NSNumber *networkStatus) {
        return networkStatus.integerValue == NotReachable ? tableHeaderView : nil;
    }];
  
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated] ;
    self.navigationItem.leftBarButtonItem = nil;
}
- (UIEdgeInsets)contentInset
{
    return UIEdgeInsetsMake(10, 0, 0, 0);
}

#pragma mark -  UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath
{
        YZMHairstylistTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YZMHairstylistTableViewCell class]) forIndexPath:indexPath];
        return cell;
}
- (void)configureCell:(YZMHairstylistTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object
{
    [cell bindViewModel:self.viewModel.dataSource[indexPath.section][indexPath.row]];
}

#pragma mark - YZMDropDownMenuDataSource

- (NSInteger)numberOfColumnsInMenu:(YZMDropDownMenu *)menu
{
    return 2;
}

- (BOOL)displayByCollectionViewInColumn:(NSInteger)column
{
    //    if (column == YZMProductListViewCtrlColumnSort) {
    //        return YES;
    //    }
    
    return NO;
}

- (BOOL)haveRightTableViewInColumn:(NSInteger)column
{
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
        return self.currentSortDataIndex;
    }
    if (column == YZMProductListViewCtrlColumnArea) {
        return self.currentAreaDataIndex;
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
            return  @"区域";
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
    }
    else if (indexPath.column == YZMProductListViewCtrlColumnArea) {
        return self.areaData[indexPath.row][@"district_name"];
    }
    return @"";
}

- (void)menu:(YZMDropDownMenu *)menu didSelectRowAtIndexPath:(YZMIndexPath *)indexPath
{
    if (indexPath.column == YZMProductListViewCtrlColumnSort) {
        self.currentSortDataIndex = indexPath.row;
        
    } else if (indexPath.column == YZMProductListViewCtrlColumnArea) {
        self.currentAreaDataIndex = indexPath.row;
    }
    
}


#pragma mark - setter and getter

- (NSMutableArray *)sortData
{
    if (_sortData == nil) {
        _sortData = [NSMutableArray arrayWithObjects:@"智能排序", @"离我最近", @"人气最高", @"环境最佳", @"服务最佳",  nil];
    }
    return _sortData;
}

- (NSMutableArray *)areaData
{
    if (_areaData == nil) {
        
        NSDictionary *areaData = @{@"district_id" : @"440300", @"district_name": @"全深圳"};
        NSDictionary *areaData0 = @{@"district_id" : @"440303", @"district_name": @"罗湖区"};
        NSDictionary *areaData1 = @{@"district_id" : @"440304", @"district_name": @"福田区"};
        NSDictionary *areaData2 = @{@"district_id" : @"440305", @"district_name": @"南山区"};
        NSDictionary *areaData3 = @{@"district_id" : @"440306", @"district_name": @"宝安区"};
        NSDictionary *areaData4 = @{@"district_id" : @"440307", @"district_name": @"龙岗区"};
        NSDictionary *areaData5 = @{@"district_id" : @"440308", @"district_name": @"盐田区"};
        NSDictionary *areaData6 = @{@"district_id" : @"440320", @"district_name": @"光明新区"};
        NSDictionary *areaData7 = @{@"district_id" : @"440321", @"district_name": @"坪山新区"};
        NSDictionary *areaData8 = @{@"district_id" : @"440322", @"district_name": @"大鹏新区"};
        NSDictionary *areaData9 = @{@"district_id" : @"440323", @"district_name": @"龙华新区"};
        
        _areaData = [NSMutableArray arrayWithObjects: areaData, areaData0, areaData1, areaData2, areaData3, areaData4, areaData5, areaData6, areaData7, areaData8, areaData9,nil];
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
