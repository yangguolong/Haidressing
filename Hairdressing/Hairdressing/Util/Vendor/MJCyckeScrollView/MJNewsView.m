//
//  MJNewsView.m
//  预习-03-无限滚动
//
//  Created by MJ Lee on 14-5-30.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

// 每一组最大的行数
#define MJNewsTotalRowsInSection (5000 * self.newses.count)
#define MJNewsDefaultRow (NSUInteger)(MJNewsTotalRowsInSection * 0.5)

#import "MJNewsView.h"
#import "MJNewsCell.h"
#import "MRCConstant.h"

static const CGFloat kPageControlHeight = 30.0f;

@interface MJNewsView()  <UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;


@property (nonatomic, strong) UIPageControl *pageControl;
@end

@implementation MJNewsView
//+ (instancetype)newsView
//{
//    return [[[NSBundle mainBundle] loadNibNamed:@"MJNewsView" owner:nil options:nil] lastObject];
//}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
  
    if (self) {
     
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.itemSize = self.frame.size;
        _flowLayout.sectionInset = UIEdgeInsetsZero;
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:_flowLayout];
        
//        [_collectionView setCollectionViewLayout:_flowLayout];
        NSLog(@"%f,%f", self.bounds.size.width,self.bounds.size.height);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        
        [_collectionView registerNib:[UINib nibWithNibName:@"MJNewsCell" bundle:nil] forCellWithReuseIdentifier:@"news"];
        
        [self addSubview:_collectionView];
       
     
        
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - kPageControlHeight, self.bounds.size.width,kPageControlHeight)];
        _pageControl.pageIndicatorTintColor = RGB(213, 204, 209);
        _pageControl.currentPageIndicatorTintColor = MRC_NAV_COLOR;
        [self addSubview:_pageControl];

        [self addTimer];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.itemSize = self.frame.size;
        _flowLayout.sectionInset = UIEdgeInsetsZero;
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:_flowLayout];
        
        //        [_collectionView setCollectionViewLayout:_flowLayout];
        NSLog(@"%f,%f", self.bounds.size.width,self.bounds.size.height);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        
        [_collectionView registerNib:[UINib nibWithNibName:@"MJNewsCell" bundle:nil] forCellWithReuseIdentifier:@"news"];
        
        [self addSubview:_collectionView];
        
        
        
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - kPageControlHeight, self.bounds.size.width,kPageControlHeight)];
        _pageControl.pageIndicatorTintColor = RGB(213, 204, 209);
        _pageControl.currentPageIndicatorTintColor = MRC_NAV_COLOR;
        [self addSubview:_pageControl];
        
        [self addTimer];
    }
    return self;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
//{
//    return self.frame.size;
//}

- (void)removeTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)addTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(nextNews) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)nextNews
{
    NSIndexPath *visiablePath = [[self.collectionView indexPathsForVisibleItems] firstObject];
    
    NSUInteger visiableItem = visiablePath.item;
    if (self.newses.count == 0 ) {
        return;
    }
    if ((visiablePath.item % self.newses.count)  == 0) { // 第0张图片
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:MJNewsDefaultRow inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        visiableItem = MJNewsDefaultRow;
    }
    
    NSUInteger nextItem = visiableItem + 1;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:nextItem inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}


- (void)setNewses:(NSArray *)newses
{
    _newses = newses;
    // 默认组
    if (!newses || newses.count == 0) {
        return;
    }
    // 总页数
    self.pageControl.numberOfPages = self.newses.count;
    // 刷新数据
    [self.collectionView reloadData];
 
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:MJNewsDefaultRow inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}

#pragma mark - 数据源
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return MJNewsTotalRowsInSection;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"news";
    MJNewsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.model = self.newses[indexPath.item % self.newses.count];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *visiablePath = [[collectionView indexPathsForVisibleItems] firstObject];
    self.pageControl.currentPage = visiablePath.item % self.newses.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
//    NSLog(@"MJNewsView Size: %@",NSStringFromCGRect(self.frame));
    return self.bounds.size;
}

- (void)layoutSubviews
{
//    NSLog(@"%@",NSStringFromCGRect(self.frame));
    _collectionView.frame = self.bounds;
    _pageControl.frame = CGRectMake(0, self.bounds.size.height - kPageControlHeight, self.bounds.size.width,kPageControlHeight);
    [_collectionView reloadData];
//     NSLog(@"AFTER:%@",NSStringFromCGRect(self.frame));
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self addTimer];
}

@end
