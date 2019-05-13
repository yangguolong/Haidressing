//
//  YZMShopListViewCtrl.m
//  Hairdressing
//
//  Created by yzm on 16/4/12.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "YZMShopListViewCtrl.h"
#import "YZMShopListViewModel.h"
#import "YZMAreaBarButton.h"
#import "YZMMessageListViewModel.h"
#import "YZMProductTableViewCell.h"

#import "YZMProductListViewCtrl.h"
#import "YZMDropDownMenu.h"
#import "YZMProductTableViewCell.h"
#import "YZMFilterView.h"
#import "YZMProductDetailsViewCtrl.h"
#import "StudioDetailViewModel.h"
#import "YZMShopModel.h"
#import "YZMLocationManager.h"
#import "MJRefresh.h"
#import "AppDelegate.h"
#import "MRCNetworkHeaderView.h"
#import "YZMSearchShopListViewModel.h"


typedef enum {
    YZMProductListViewCtrlColumnSort = 0,
    YZMProductListViewCtrlColumnArea,
}YZMProductListViewCtrlColumn;


@interface YZMShopListViewCtrl () <YZMDropDownMenuDataSource,YZMDropDownMenuDelegate,UISearchBarDelegate,UISearchControllerDelegate,UISearchResultsUpdating>


@property (nonatomic, strong) NSMutableArray *sortData;
@property (nonatomic, strong) NSMutableArray *areaData;

@property (nonatomic ,assign) NSInteger currentSortDataIndex;
@property (nonatomic ,assign) NSInteger currentAreaDataIndex;

@property (nonatomic, strong) YZMDropDownMenu *menu;

@property (nonatomic, strong) YZMShopListViewModel *viewModel;

@property (nonatomic, strong) YZMAreaBarButton *areaBarButton;
@property (nonatomic, strong) UISearchController *searchController;


@property (nonatomic, assign) BOOL isShowLocationError;

@end

@implementation YZMShopListViewCtrl

@dynamic viewModel;

- (instancetype)initWithViewModel:(MRCViewModel *)viewModel
{
    self = [super init];
    if (self) {
        
        self.viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);

    
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YZMProductTableViewCell class]) bundle:nil] forCellReuseIdentifier:[YZMProductTableViewCell indentifier]];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    [self.view addSubview:self.menu];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_search_n"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClick:)];
      self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc] initWithCustomView:self.areaBarButton];

    
//    [[self.viewModel.services.hairService getArea] subscribeNext:^(id x) {
//        self.areaData = x[@"district"];
//        
//    }];
    [[RACObserve(self.viewModel, areaId) skip:1] subscribeNext:^(id x) {
        
                 [self.tableView.mj_header beginRefreshing];
    }];
    
    [[RACObserve(self.viewModel, sortTypeId) skip:1]  subscribeNext:^(id x) {
        
                 [self.tableView.mj_header beginRefreshing];
        
    }];
    [[RACObserve(self.viewModel, corporation) skip:1]  subscribeNext:^(id x) {
        
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
//            if (self.viewModel.dataSource.count !=0)
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
    networkHeaderView.titleLabel.text = @"网络异常";
    [tableHeaderView addSubview:networkHeaderView];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    RAC(self.tableView, tableHeaderView) = [RACObserve(delegate, networkStatus) map:^id(NSNumber *networkStatus) {
         return networkStatus.integerValue == NotReachable ? tableHeaderView : nil;
    }];
    

    [self handleLocation];

}

- (void)handleLocation
{
    @weakify(self)
    // 1. 监听状态改变，如果选择了拒绝，则提示无法获取地理位置，默认深圳市
    [[[RACObserve([YZMLocationManager shareInstance], currentCoordinate) skip:1] distinctUntilChanged]subscribeNext:^(id x) {
        @strongify(self)
        //        self.viewModel.page = 1;
//        [self.tableView.mj_header beginRefreshing];
        [self.viewModel.requestRemoteDataCommand execute:nil];
    }];

    [RACObserve([YZMLocationManager shareInstance], authStatus) subscribeNext:^(NSNumber *status) {
        
        if ([status integerValue] == kCLAuthorizationStatusNotDetermined) {
           
            DLog(@" 等待用户授权");
        } else if([status integerValue] == kCLAuthorizationStatusAuthorizedAlways || [status integerValue] == kCLAuthorizationStatusAuthorizedWhenInUse) {
            DLog(@"授权成功");
            
        } else {
            DLog(@"授权失败");
            
//              [[[UIAlertView alloc] initWithTitle:@"提示" message:@"无法获取地理位置" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];

        }
    }];
    
    [[RACObserve([YZMLocationManager shareInstance], locality) distinctUntilChanged] subscribeNext:^(NSString *locality) {
        
        if(locality && locality.length > 0 && ![locality isEqualToString:@"深圳市"]) {
            
                 [[[UIAlertView alloc] initWithTitle:@"提示" message:@"目前尚不支持您所在的区域，系统已自动切换至深圳市南山区" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
             [self.viewModel.requestRemoteDataCommand execute:nil];
        }
        
    }];

    // 定位失败，系统已自动定位至深圳市
//    [RACObserve([YZMLocationManager shareInstance], errorType) subscribeNext:^(NSNumber *type) {
//       
//        if (type.integerValue == ZMLocationManagerErrorTypeCallback) {
//            
//            
//        }
//    }];
    
    [[[YZMLocationManager shareInstance]
      rac_signalForSelector:@selector(locationManager:didFailWithError:)]
    	subscribeNext:^(id x) {
            if(!_isShowLocationError) {
              [[[UIAlertView alloc] initWithTitle:@"提示" message:@"定位失败，系统已自动定位至深圳市" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                _isShowLocationError =  !_isShowLocationError;
                 [self.viewModel.requestRemoteDataCommand execute:nil];
            }
            
        }];
    
//        [[YZMLocationManager shareInstance] start];

}

- (UIEdgeInsets)contentInset
{
    return UIEdgeInsetsMake(40, 0, 40, 0);
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
   YZMShopModel *model = self.viewModel.dataSource[indexPath.section][indexPath.row];
    StudioDetailViewModel *viewModel = [[StudioDetailViewModel alloc] initWithServices:self.viewModel.services params:@{@"corp_id" : model.corp_id }];
    
    [self.viewModel.services pushViewModel:viewModel animated:YES];
}

//- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath
//{    YZMProductTableViewCell *cell = (YZMProductTableViewCell *)[super tableView:tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YZMProductTableViewCell class]) forIndexPath:indexPath];
//    return cell;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YZMProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YZMProductTableViewCell class]) forIndexPath:indexPath];
    id object = self.viewModel.dataSource[indexPath.section][indexPath.row];
    [cell bindViewModel:self.viewModel.dataSource[indexPath.section][indexPath.row]];
    
    return cell;
}

//- (void)configureCell:(YZMProductTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object
//{
//    [cell bindViewModel:self.viewModel.dataSource[indexPath.section][indexPath.row]];
//}


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


#pragma mark - Event
- (void)rightBarButtonItemClick:(UIBarButtonItem *)item
{

    [self.tabBarController presentViewController:self.searchController animated:YES completion:nil];
    [self.searchController.searchBar becomeFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
//    [searchBar resignFirstResponder];
    // Do the search...
     NSLog(@"searchBarSearchButtonClicked");
//    self.viewModel.corporation = searchBar.text;
    // 1.跳转到新的控制器
    YZMSearchShopListViewModel *searchViewModel = [[YZMSearchShopListViewModel alloc] initWithServices:self.viewModel.services params:@{@"corporation" : searchBar.text}];
    [self.viewModel.services pushViewModel:searchViewModel animated:YES];
    
    
    // 2.新控制器的属性
    // 2.1 继承自ShoplistViewCtrl
    // 2.2 searchBar cancel UI
    
    
    // 3. 添加一个header 用来显示搜索结果条目
    // 添加
    
    
    [self.searchController dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - getter and setter

- (YZMAreaBarButton *)areaBarButton
{
    if (_areaBarButton == nil) {
        // 左边按钮
        _areaBarButton = [YZMAreaBarButton areaBarButton];
        // 图标
        [_areaBarButton setImage:[UIImage imageWithName:@"nav_area_n.png"] forState:UIControlStateNormal];
        // 文字
        [_areaBarButton setTitle:@"深圳" forState:UIControlStateNormal];
        // 位置和尺寸
        _areaBarButton.frame = CGRectMake(0, 0, 60, 40);

    }
    return _areaBarButton;
}


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



- (UISearchController *)searchController
{
    if (_searchController == nil) {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        _searchController.searchBar.delegate = self;
        _searchController.searchBar.placeholder = @"请输入门店名称";

//        [_searchController.searchBar setTintColor:[UIColor blackColor]];
        [_searchController.searchBar setBarTintColor:[UIColor whiteColor]];
//        [_searchController.searchBar setBackgroundColor:[UIColor redColor]];
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
            [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTitle:@"取消"];

        } else {
            [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitle:@"取消"];

        }
        
        [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                                      HexRGB(0xE50011),NSForegroundColorAttributeName,
                                                                                                      //[UIColor whiteColor],UITextAttributeTextShadowColor,
                                                                                                      //[NSValue valueWithUIOffset:UIOffsetMake(0, 1)],UITextAttributeTextShadowOffset,
                                                                                                      nil]
                                                                                            forState:UIControlStateNormal];

        
        
        UITextField *searchField = [_searchController.searchBar valueForKey:@"searchField"];
        
        // To change background color
        searchField.backgroundColor = HexRGB(0xF2F2F2);
        
        // To change text color
//        searchField.textColor = [UIColor redColor];
        
        // To change placeholder text color
//        searchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Some Text"];
        UILabel *placeholderLabel = [searchField valueForKey:@"placeholderLabel"];
        placeholderLabel.textColor = HexRGB(0xcbcbcb);
    }
    return _searchController;
}



@end