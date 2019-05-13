//
//  YZMProductDetailsViewCtrl.m
//  Hairdressing
//
//  Created by 杨国龙 on 16/3/15.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "YZMProductDetailsViewCtrl.h"
#import "YZMProductDetailsHeaderView.h"
#import "YZMProductDetailsTabView.h"
#import "YZMShopInfoFooter.h"
#import "YZMCommentNullDataFooter.h"
#import "YZMCommentTableViewCell.h"

@interface YZMProductDetailsViewCtrl () <UIWebViewDelegate>

@property (nonatomic, strong) YZMProductDetailsHeaderView *tableHeaderView;
@property (nonatomic, strong) YZMProductDetailsTabView *tabbarView;
@property (nonatomic, strong) YZMShopInfoFooter *shopInfoFooter;
@property (nonatomic, strong) YZMCommentNullDataFooter *commentNullDataFooter;

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, assign) YZMProductDetailsTabViewSelectState selectState;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

/**  用来判断是否加载了webview */
@property (nonatomic , assign) BOOL isLoadWebView;

@end

@implementation YZMProductDetailsViewCtrl

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableHeaderView = self.tableHeaderView;
    [[RACObserve(self, selectState) distinctUntilChanged]subscribeNext:^(id x) {
        [self.tableView reloadData];
    }];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YZMCommentTableViewCell class]) bundle:nil] forCellReuseIdentifier:[YZMCommentTableViewCell indentifier]];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 100, 0, 0);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


#pragma mark - TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [YZMProductDetailsTabView viewHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.selectState == YZMProductDetailsTabViewSelectStateServiceDetail) {
        return self.webView.frame.size.height;
    } else if (self.selectState == YZMProductDetailsTabViewSelectStateShopInfo ) {
        return [YZMShopInfoFooter viewHeight];
    } else if (self.selectState == YZMProductDetailsTabViewSelectStateComment) {
        return [YZMCommentNullDataFooter viewHeight];
    }
    
    return 0;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.tabbarView;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (self.selectState == YZMProductDetailsTabViewSelectStateServiceDetail) {
       
        if (!_isLoadWebView) { // url有效判断
            [self.webView loadHTMLString:_priceLabel.text baseURL:nil];
            _isLoadWebView = !_isLoadWebView;
        }
        
        return self.webView;
 
    } else if (self.selectState == YZMProductDetailsTabViewSelectStateShopInfo) {
        return self.shopInfoFooter;
    } else if (self.selectState == YZMProductDetailsTabViewSelectStateComment) {
        return self.commentNullDataFooter;
    }
    
    return nil;
}

#pragma mark - TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark - UIWebView delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // 重新计算frame
    CGRect frame = webView.frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    webView.frame = frame;
    [self.tableView reloadData];
}


#pragma mark - getter setter 

- (YZMProductDetailsTabView *)tabbarView
{
    if (_tabbarView == nil) {
        _tabbarView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([YZMProductDetailsTabView class]) owner:nil options:nil].firstObject;
        
      RAC(self, selectState ) = RACObserve(self.tabbarView, state);
    }
    return _tabbarView;
}

- (YZMProductDetailsHeaderView *)tableHeaderView
{
    if (_tableHeaderView == nil) {
        _tableHeaderView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([YZMProductDetailsHeaderView class]) owner:nil options:nil].firstObject;
    }
    return _tableHeaderView;
}

- (UIWebView *)webView
{
    if (_webView == nil) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
        
        [[[_webView subviews] lastObject] setScrollEnabled:NO];
        _webView.scalesPageToFit = YES;
        _webView.delegate = self;
    }
    return _webView;
}

- (YZMShopInfoFooter *)shopInfoFooter
{
    if (_shopInfoFooter == nil) {
        _shopInfoFooter = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([YZMShopInfoFooter class]) owner:nil options:nil].firstObject;
    }
    return _shopInfoFooter;
}

- (YZMCommentNullDataFooter *)commentNullDataFooter
{
    if (_commentNullDataFooter == nil) {
        _commentNullDataFooter = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([YZMCommentNullDataFooter class]) owner:nil options:nil].firstObject;
    }
    return _commentNullDataFooter;
}

@end
