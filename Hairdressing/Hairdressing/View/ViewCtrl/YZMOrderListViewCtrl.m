//
//  YZMOrderListViewCtrl.m
//  Hairdressing
//
//  Created by yzm on 16/4/14.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "YZMOrderListViewCtrl.h"
#import "YZMOrderTableViewCell.h"
#import "YZMOrderListFooterView.h"
#import "YZMOrderListHeaderView.h"
#import <Masonry/Masonry.h>
#import "YZMOrderListViewModel.h"
#import "YZMOrderDetailsViewModel.h"
#import "YZMOrderModel.h"
#import "YZMPayTypeSelectView.h"
#import "YZMAppraiseViewModel.h"

//#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#define pageCount 5

@interface YZMOrderListViewCtrl ()

@property (nonatomic, strong) YZMOrderListViewModel *viewModel;

@property (nonatomic, strong) NSMutableArray *buttonsArray;
@property (nonatomic, strong) NSMutableArray *tableViewArray;

//@property (nonatomic , assign) int currentPage;
@property (nonatomic , assign) BOOL pageControlUsed;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *slidIndicatorConstraint;

@property (weak, nonatomic) IBOutlet UIView *scrollContentView;
@property (weak, nonatomic) IBOutlet UIView *tabContentView;
@property (nonatomic, strong) YZMPayTypeSelectView *payTypeSelView;

@end

@implementation YZMOrderListViewCtrl

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, SCREEN_WIDTH, self.view.frame.size.height);
    
    // 2.设置导航栏内容
    [self setupNavBar];
    
    // 3.指示器相关
    [self addBasicView];
    // 4.左右滑动相关
    [self initScrollView];
    
    [self.viewModel.requestRemoteDataCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        self.viewModel.dataSource = x;
        [self reloadData];
    }];
    @weakify(self)
    [[RACObserve(self.viewModel, requestType) skip:0] subscribeNext:^(NSNumber *type) {
        @strongify(self)
        [self.viewModel.requestRemoteDataCommand execute:@(self.viewModel.page)];
        [self changePage:type.intValue];
        
    }];
     RAC(self.viewModel,payType) = RACObserve(self.payTypeSelView, payType);
   
    [self.viewModel.editOrderCommand.executionSignals.switchToLatest subscribeNext:^(id responeData) {
        
        // 成功处理
        
    }];
    

}

/** 左右滑动相关 */
-(void)initScrollView
{
    self.scrollview.pagingEnabled = YES;
    self.scrollview.clipsToBounds = NO;
    self.scrollview.showsHorizontalScrollIndicator =NO ;
    self.scrollview.showsVerticalScrollIndicator =NO;
    self.scrollview.scrollsToTop = NO;
    self.scrollview.delegate = self;
    
    [self.scrollview setContentOffset:CGPointMake(0, 0)];
    
    //公用
//    self.currentPage = 0 ;
//    self.pageControl.numberOfPages = pageCount ;
//    self.pageControl.currentPage = 0 ;
//    self.pageControl.backgroundColor = [UIColor whiteColor];
    [self createAllEmptyPagesForScrollView];
    
}

/** 创建uitableview */
- (void)createAllEmptyPagesForScrollView
{
    // 0.设置tableviewstyle
    for (int i = 0;  i < pageCount; i ++ ) {
       
        UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        
        [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YZMOrderTableViewCell class]) bundle:nil] forCellReuseIdentifier:[YZMOrderTableViewCell indentifier]];
        
        [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YZMOrderListHeaderView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass([YZMOrderListHeaderView class])];
        
        [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YZMOrderListFooterView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass([YZMOrderListFooterView class])];
        

        [tableView setBackgroundColor:HexRGB(0xEDF1F3)];
        
        [self.scrollview addSubview:tableView];
        [self.tableViewArray addObject:tableView];
        
        
        tableView.delegate = self;
        tableView.dataSource = self;
        
        float x = SCREEN_WIDTH * i;
        float w = SCREEN_WIDTH;
        
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(w);
            make.top.equalTo(self.scrollview).with.offset(0);
            make.bottom.equalTo(self.scrollview).with.offset(0);
            make.left.equalTo(self.scrollview).with.offset(x);
        }];
    }
}

/** 滑动scrollview时调用 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.scrollview.frame.size.width;
    int page = floor((self.scrollview.contentOffset.x - pageWidth / 2) /pageWidth) +1 ;
    
//    self.pageControl.currentPage = page;
//    self.currentPage = page;
//    self.pageControlUsed = NO;
//    [self changePage:page];
    self.viewModel.requestType = page;
    
}

- (void)addBasicView
{
    
    [self.buttonsArray addObject:self.button0];
    [self.buttonsArray addObject:self.button1];
    [self.buttonsArray addObject:self.button2];
    [self.buttonsArray addObject:self.button3];
    [self.buttonsArray addObject:self.button4];
    
    @weakify(self)
    for (int i = 0 ; i < self.buttonsArray.count ; i ++) {
        
        UIButton * btn = self.buttonsArray[i];
        btn.showsTouchWhenHighlighted = YES;
        
        btn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input){
            @strongify(self)
            
//            [self changePage:i];
            self.viewModel.requestType = i;
            
            return [RACSignal empty];
        }];
    }
    
}

/** 跳转页面  */
- (void)changePage:(int)page
{
//    self.currentPage = page;
    
    CGFloat x = SCREEN_WIDTH / pageCount * page;
     self.slidIndicatorConstraint.constant = x ;
    //
 
    [UIView animateWithDuration:0.3 animations:^{
        
        [self.view layoutIfNeeded];
        
        [self.scrollview setContentOffset:CGPointMake(self.view.frame.size.width * page, 0)];
        
    } completion:^(BOOL finished) {
        
    }];
 
}

/**
 *  设置导航栏内容
 */
- (void)setupNavBar
{

}

- (void)reloadData {
    
    [self.tableView reloadData];
    
    for (UITableView * tableView in self.tableViewArray) {
        [tableView reloadData];
    }
    
}

#pragma mark -- UITableViewDelegate UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.tableViewArray[self.viewModel.requestType] == tableView) {
        return self.viewModel.dataSource.count;
    }else {
        return 0;
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    YZMOrderModel *orderModel = self.viewModel.dataSource[section];
//    return orderModel.items.count;
    return 1;
}


/** cell 尾的高 */
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return [YZMOrderListFooterView footerHeight] + 30;
}

/** cell头的高 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [YZMOrderListHeaderView headerHeight];
}

/** cell的高 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
      return [YZMOrderTableViewCell cellHeight];
}

/** cell的尾 */
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    
    YZMOrderModel *orderModel = self.viewModel.dataSource[section];
    YZMOrderListFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([YZMOrderListFooterView class])];

    @weakify(self)
//    orderModel.status = YZMOrderModelStatusEvaluate;
    switch (orderModel.status) {
        case YZMOrderModelStatusUnpaid:{// 未付款
            @strongify(self)
            
            footerView.rightFirstButton.hidden = NO;
            [footerView.rightFirstButton setTitle:@"立即付款" forState:UIControlStateNormal];
           
            footerView.rightFirstButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
                 @strongify(self)
                 // 立即付款
                self.payTypeSelView.confirmButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
                    
                    @strongify(self)
                    [self.viewModel.payOrderCommand execute:orderModel.order_id];
                    [self.payTypeSelView hideView];
                    
                    return [RACSignal empty];
                }];
                self.payTypeSelView.orderId = orderModel.order_id;
                self.payTypeSelView.price = orderModel.settle_price;
                
                [self.payTypeSelView showInView:[UIApplication sharedApplication].keyWindow];
                return [RACSignal empty];
            }];
            
            footerView.rightSecondButton.hidden = NO;
            [footerView.rightSecondButton setTitle:@"取消订单" forState:UIControlStateNormal];
            footerView.rightSecondButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
                // 取消订单
                self.viewModel.editStatus = YZMOrderEditStatusCancleOrder;
                [self.viewModel.editOrderCommand execute:orderModel.order_id];
                
                return [RACSignal empty];
            }];
    }
            break;
       
        case YZMOrderModelStatusPaid: {// 待消费
            footerView.rightFirstButton.hidden = NO;
            [footerView.rightFirstButton setTitle:@"联系客服" forState:UIControlStateNormal];
            footerView.rightFirstButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
                
                NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",orderModel.hotline];
                UIWebView * callWebview = [[UIWebView alloc] init];
                [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                [self.view addSubview:callWebview];
                
                
                return [RACSignal empty];
            }];
            
            footerView.rightSecondButton.hidden = NO;
            [footerView.rightSecondButton setTitle:@"申请退款" forState:UIControlStateNormal];
            footerView.rightSecondButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
                
                self.viewModel.editStatus = YZMOrderEditStatusApplyBack;
                [self.viewModel.editOrderCommand execute:orderModel.order_id];
                
                return [RACSignal empty];
            }];

            break;
    }
        case YZMOrderModelStatusRefusedRefund: {// 待消费
            footerView.rightFirstButton.hidden = NO;
            [footerView.rightFirstButton setTitle:@"联系客服" forState:UIControlStateNormal];
            footerView.rightFirstButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
                
                NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",orderModel.hotline];
                UIWebView * callWebview = [[UIWebView alloc] init];
                [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                [self.view addSubview:callWebview];
                
                return [RACSignal empty];
            }];
            
            footerView.rightSecondButton.hidden = NO;
            [footerView.rightSecondButton setTitle:@"申请退款" forState:UIControlStateNormal];
            footerView.rightSecondButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
                
                self.viewModel.editStatus = YZMOrderEditStatusApplyBack;
                [self.viewModel.editOrderCommand execute:orderModel.order_id];
                
                return [RACSignal empty];
            }];
            
            break;
        }
            
        case YZMOrderModelStatusEvaluate:{// 待评价
            footerView.rightFirstButton.hidden = NO;
            [footerView.rightFirstButton setTitle:@"去评价" forState:UIControlStateNormal];
            footerView.rightFirstButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
                YZMAppraiseViewModel *appraiseViewModel = [[YZMAppraiseViewModel alloc] initWithServices:self.viewModel.services params:@{@"order_id":orderModel.order_id}];
                [self.viewModel.services pushViewModel:appraiseViewModel animated:YES];
                return [RACSignal empty];
            }];
            
            footerView.rightSecondButton.hidden = YES;

            break;
        }
            
        case YZMOrderModelStatusRefunding:{// 退款中
            footerView.rightFirstButton.hidden = NO;
            [footerView.rightFirstButton setTitle:@"取消退款" forState:UIControlStateNormal];
            footerView.rightFirstButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
                
                self.viewModel.editStatus = YZMOrderEditStatusCancleBack;
                [self.viewModel.editOrderCommand execute:orderModel.order_id];
                
                return [RACSignal empty];
            }];
            
            footerView.rightSecondButton.hidden = YES;

            break;
    }
        default:
            
            footerView.rightFirstButton.hidden = YES;
            footerView.rightSecondButton.hidden = YES;

            break;
    }
    footerView.orderPriceLabel.text = [NSString stringWithFormat:@"实付：￥%@",orderModel.settle_price];
    
    return footerView;
}


/** cell头 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    YZMOrderModel *orderModel = self.viewModel.dataSource[section];
    YZMOrderListHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([YZMOrderListHeaderView class])];
    headerView.orderNumberLabel.text = [NSString stringWithFormat:@"%@",orderModel.corporation];
    headerView.statusLabel.text = [NSString stringWithFormat:@"%@",[YZMOrderModel stringfromStatusEnum:orderModel.status]];
    headerView.contentView.backgroundColor = [UIColor whiteColor];
    return headerView;
}


/**   选中cell的时候调用 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /** 取消选中状态 */
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YZMOrderModel *model = self.viewModel.dataSource[indexPath.section];
    // 1.跳转到订单详情
    YZMOrderDetailsViewModel *detailsViewModel = [[YZMOrderDetailsViewModel alloc] initWithServices:self.viewModel.services params:@{@"orderNo" : model.orderno }];
    [self.viewModel.services pushViewModel:detailsViewModel animated:YES];
    
    
}


/** 视图*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     YZMOrderTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:[YZMOrderTableViewCell indentifier] forIndexPath:indexPath];
    YZMOrderModel *orderModel = self.viewModel.dataSource[indexPath.section];
    [cell bindViewModel:orderModel];
    return cell;
}

- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view
{
    return YES;
}
- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    return NO;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //暂不处理 - 其实左右滑动还有包含开始等等操作，这里不做介绍
}


#pragma mark - setter getter



- (NSMutableArray *)buttonsArray
{
    if (_buttonsArray== nil) {
        _buttonsArray = [NSMutableArray array];
        
    }
    return _buttonsArray;
}

- (NSMutableArray *)tableViewArray
{
    if (!_tableViewArray) {
        _tableViewArray = [NSMutableArray array];
    }
    return _tableViewArray;
}

- (YZMPayTypeSelectView *)payTypeSelView
{
    if (_payTypeSelView == nil)
    {
        _payTypeSelView = [YZMPayTypeSelectView instance];
   
    }
    return _payTypeSelView;
}

@end
