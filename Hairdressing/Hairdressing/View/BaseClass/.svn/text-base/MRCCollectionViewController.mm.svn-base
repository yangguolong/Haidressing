//
//  MRCCollectionViewController.m
//  MTM
//
//  Created by 李昌庆 on 16/2/1.
//  Copyright © 2016年 cloudream. All rights reserved.
//

#import "MRCCollectionViewController.h"
#import "MRCCollectionViewModel.h"
#import <SVPullToRefresh/SVPullToRefresh.h>
#import <ReactiveCocoa/RACSignal+Operations.h>
#import "AppDelegate.h"
#include <ReactiveCocoa/RACSignal+Operations.h>
#import <MJRefresh/MJRefresh.h>

@interface MRCCollectionViewController ()

@property (nonatomic,weak,readwrite)IBOutlet UICollectionView * collectionView;

@property (nonatomic,strong,readonly)MRCCollectionViewModel * viewModel;



@end

@implementation MRCCollectionViewController

@dynamic viewModel;

- (instancetype)initWithViewModel:(MRCViewModel *)viewModel {
    self = [super initWithViewModel:viewModel];
    if (self) {
        if ([viewModel shouldRequestRemoteDataOnViewDidLoad]) {
            @weakify(self)
            [[self rac_signalForSelector:@selector(viewDidLoad)] subscribeNext:^(id x) {
                @strongify(self)
                [self.viewModel.requestRemoteDataCommand execute:@1];
            }];
        }
    }
    return self;
}

- (void)setView:(UIView *)view
{
    [super setView:view];
    if ([view isKindOfClass:UICollectionView.class]) {
        self.collectionView = (UICollectionView *)view;
    }
}

- (void)bindViewModel
{
    @weakify(self)
    [[[RACObserve(self.viewModel, dataSource)
       distinctUntilChanged]
      deliverOnMainThread]
     subscribeNext:^(id x) {
         @strongify(self)
         [self reloadData];
     }];
    [self.viewModel.requestRemoteDataCommand.executing subscribeNext:^(NSNumber *executing) {
        @strongify(self)
        UIView *emptyDataSetView = [self.collectionView.subviews.rac_sequence objectPassingTest:^(UIView *view) {
            return [NSStringFromClass(view.class) isEqualToString:@"DZNEmptyDataSetView"];
        }];
        emptyDataSetView.alpha = 1.0 - executing.floatValue;
    }];
    RAC(self,title) = RACObserve(self.viewModel, title);
}


- (void)viewDidLoad {
    [super viewDidLoad];
//    self.collectionView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
   
    @weakify(self)
    if (self.viewModel.shouldPullToRefresh) {
        self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            // 进入刷新状态后会自动调用这个block
            [self refreshTriggered:nil];
        }];

    }

    
    if (self.viewModel.shouldInfiniteScrolling) {
    self.collectionView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        @strongify(self)
        [[[self.viewModel.requestRemoteDataCommand
           execute:@(self.viewModel.page + 1)]
          deliverOnMainThread]
            subscribeNext:^(NSArray *results) {
                @strongify(self)
                self.viewModel.page += 1;
            } error:^(NSError *error) {
                @strongify(self)
                [self.collectionView.mj_footer endRefreshing];
            } completed:^{
                @strongify(self)
                [self.collectionView.mj_footer endRefreshing];
            }];

    }];
        }
    
    
    // Do any additional setup after loading the view.
}
#pragma mark - Listening for the user to trigger a refresh

- (void)refreshTriggered:(id)sender {
     self.viewModel.page = 1;
    @weakify(self)
    [[[self.viewModel.requestRemoteDataCommand
       execute:@1]
      deliverOnMainThread]
    	subscribeNext:^(id x) {
//            @strongify(self)
//            self.viewModel.page = 1;
        } error:^(NSError *error) {
            @strongify(self)
//            [self.refreshControl finishingLoading];
            [self.collectionView.mj_header endRefreshing];
        } completed:^{
            @strongify(self)
            [self.collectionView.mj_header endRefreshing];
//            [self.refreshControl finishingLoading];
        }];
}

#pragma mark - UIScrollViewDelegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [self.refreshControl scrollViewDidScroll];
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    [self.refreshControl scrollViewDidEndDragging];
//}

-(void)reloadData{
    
    [self.collectionView reloadData];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath
{
    return [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
}

- (void)configureCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object{}

#pragma mark - UICollectionViewDataSoure
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
     return self.viewModel.dataSource ? self.viewModel.dataSource.count : 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    NSLog(@"%"[self.viewModel.dataSource count]);
    return [self.viewModel.dataSource count];
}



-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
//     id object = self.viewModel.dataSource[indexPath.section][indexPath.row];
//    [self configureCell:cell atIndexPath:indexPath withObject:(id)object]
    return nil;
}
#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.viewModel.didSelectCommand execute:indexPath];
}


#pragma mark - DZNEmptyDataSetSource

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    return [[NSAttributedString alloc] initWithString:@"No Data"];
}

#pragma mark - DZNEmptyDataSetDelegate

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return self.viewModel.dataSource == nil;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

- (CGPoint)offsetForEmptyDataSet:(UIScrollView *)scrollView {
    return CGPointMake(0, -(self.collectionView.contentInset.top - self.collectionView.contentInset.bottom) / 2);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
