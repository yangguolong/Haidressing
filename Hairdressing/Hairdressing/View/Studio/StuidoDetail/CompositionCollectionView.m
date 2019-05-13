//
//  CompositionCollectionView.m
//  Hairdressing
//
//  Created by Guolong Yang on 16/4/20.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "CompositionCollectionView.h"
#import "ImgScrollView.h"
#import "TapImageView.h"

@interface CompositionCollectionView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) UICollectionView *collectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@end

@implementation CompositionCollectionView
static NSString *const reuseIdentifier = @"DesignerMasterpiece";

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.itemSize = self.cellSize;
        _flowLayout.sectionInset = UIEdgeInsetsZero;
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:_flowLayout];
        _collectionView.backgroundColor = [UIColor orangeColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
        [self addSubview:_collectionView];
        
        [self initDispalyView];
        
    }
    return self;
}

//显示图片
-(void)initDispalyView
{
    scrollPanel = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    scrollPanel.backgroundColor = [UIColor clearColor];
    scrollPanel.alpha = 0;
    [[[UIApplication sharedApplication].windows objectAtIndex:0] addSubview:scrollPanel];
    [[[UIApplication sharedApplication].windows objectAtIndex:0] bringSubviewToFront:scrollPanel];
    
    alphaView = [[UIView alloc] initWithFrame:scrollPanel.bounds];
    alphaView.backgroundColor = [UIColor blackColor];
    alphaView.alpha = 0;
    [scrollPanel addSubview:alphaView];
    
    scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.scrollEnabled = YES;
    scrollView.userInteractionEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [scrollPanel addSubview:scrollView];
    
//    UILabel *alertLabel = [[UILabel alloc] initWithFrame:CGRectMake((kWidth-60)/2, kHeight-15, 60, 12)];
//    alertLabel.textColor = [UIColor whiteColor];
//    alertLabel.font = [UIFont systemFontOfSize:10];
//    alertLabel.textAlignment = NSTextAlignmentCenter;
//    alertLabel.text = @"长按保存图片";
//    [scrollPanel addSubview:alertLabel];
}
#pragma mark -collectionview delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    TapImageView *imageView = [[TapImageView alloc]initWithFrame:CGRectMake(0, 0, self.cellSize.width, self.cellSize.height)];
    imageView.image = [UIImage imageNamed:@"comment_dianxiaoping"];
    imageView.delegate = self;
    [cell addSubview:imageView];
//    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 50)];
//    button.backgroundColor = [UIColor blackColor];
//    [button addTarget:self action:@selector(helloAction) forControlEvents:UIControlEventTouchUpInside];
//    [cell addSubview:button];
    return cell;
}

//-(void)helloAction{
//    NSLog(@"helloActoin");
//}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.sectionNum;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.cellSize;
    
}
////定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
//    NSUInteger insetLeftRight = (self.bounds.size.width-(3 * self.cellSize.width))/6;
//    NSUInteger insetUpDown = (self.bounds.size.height-self.cellSize.height)/2;
//    return UIEdgeInsetsMake(insetUpDown, insetLeftRight, insetUpDown, insetLeftRight);
    
       return UIEdgeInsetsMake(20, 20, 20, 20);
}
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//
//    if ([self.delegate respondsToSelector:@selector(collectionViewdidSelectItemAtIndexPath:)]) {
//        [self.delegate collectionViewdidSelectItemAtIndexPath:indexPath.section];
//    }
//
//}

#pragma mark - TapImageViewDelegate
- (void)tappedWithObject:(TapImageView *)imageView
{
    //修改背景
    [[[UIApplication sharedApplication].windows objectAtIndex:0] bringSubviewToFront:scrollPanel];
    scrollPanel.alpha = 1.0;
    
    CGRect convertRect = [[imageView superview] convertRect:imageView.frame toView:[[UIApplication sharedApplication].windows objectAtIndex:0]];
    ImgScrollView *imgScrollView = [[ImgScrollView alloc] initWithFrame:scrollView.bounds];
    imgScrollView.tag = 99;
    imgScrollView.parent = self;
    //imgScrollView.imgPath = myCollect.filePath;
    [imgScrollView setContentWithFrame:convertRect];
    [imgScrollView setImage:imageView.image AndViewTimes:1];
    imgScrollView.maximumZoomScale = 2.0;
    [scrollView addSubview:imgScrollView];
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         [imgScrollView setAnimationRect];
                         alphaView.alpha = 1.0;
                     }
                     completion:^(BOOL finished){
                         imgScrollView.loadImageV.hidden = NO;
                         [imgScrollView setImagePath:imgScrollView.imgPath];
                     }];
}
#pragma mark --ImageScrollView Delegate
- (void)tapImageViewTappedWithObject:(ImgScrollView *) sender
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         alphaView.alpha = 0;
                         [sender rechangeInitRect];
                         if (sender.loadImageV.hidden == NO) {
                             sender.loadImageV.hidden = YES;
                         }
                     }
                     completion:^(BOOL finished) {
                         scrollPanel.alpha = 0;
                         if ([scrollView viewWithTag:99]) {
                             [[scrollView viewWithTag:99] removeFromSuperview];
                         }
                     }];
}

- (void)hidePreviewView
{
    scrollPanel.alpha = 0;
    if ([scrollView viewWithTag:99]) {
        [[scrollView viewWithTag:99] removeFromSuperview];
    }
}


@end

