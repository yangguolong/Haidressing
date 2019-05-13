//
//  ThirdCollectionView.m
//  3张图片滚动demo
//
//  Created by admin on 16/4/10.
//  Copyright © 2016年 flybearTech. All rights reserved.
//

#import "ThirdCollectionView.h"
#import <Masonry/Masonry.h>
@interface ThirdCollectionView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) UICollectionView *collectionView;

//@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@end

@implementation ThirdCollectionView
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.cellSize = CGSizeMake((kWidth-14*2-1.5*8)/4, (kWidth-14*2-1.5*8)/4);
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.itemSize = self.cellSize;
        _flowLayout.sectionInset = UIEdgeInsetsZero;
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.size.width, self.size.height) collectionViewLayout:_flowLayout];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"ThirdCollectionCell"];

        [self addSubview:_collectionView];
        
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).with.offset(0);
            make.top.equalTo(self).with.offset(0);
            make.bottom.equalTo(self).with.offset(0);
            make.left.equalTo(self).with.offset(0);
        }];
        
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.cellSize = CGSizeMake((self.bounds.size.width-1.5*8-13.5*2)/4, (self.bounds.size.width-1.5*8-13.5*2)/4);
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.itemSize = self.cellSize;
        _flowLayout.sectionInset = UIEdgeInsetsZero;
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:_flowLayout];
        
        //        [_collectionView setCollectionViewLayout:_flowLayout];
        //    NSLog(@"%f,%f", self.bounds.size.width,self.bounds.size.height);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"ThirdCollectionCell"];
        //        [_collectionView registerNib:[UINib nibWithNibName:@"ThirdCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"news"];
        
        [self addSubview:_collectionView];
        
        
    }
    return self;


}

#pragma mark -collectionview delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * CellIdentifier = @"ThirdCollectionCell";
    UICollectionViewCell *cell;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    //    if (!cell) {
    //        cell = [[UICollectionViewCell alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    cell.backgroundColor = [UIColor clearColor];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.cellSize.width, self.cellSize.height)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[self.imageViewArray objectAtIndex:indexPath.section]] placeholderImage:nil];
    [cell.contentView addSubview:imageView];
    //    }
    return cell;
}



- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.sectionNum;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.cellSize;
    
    
}
////定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{

    NSUInteger insetLeftRight = (self.bounds.size.width-(4 * self.cellSize.width))/8;
//    CGFloat cellWidth= (kWidth-1.5*8-13.5*2)/4;
    NSUInteger insetUpDown = (self.bounds.size.height-self.cellSize.height)/2;
    if (section ==0) {
        return UIEdgeInsetsMake(insetUpDown, 1.5+1, insetUpDown, 1.5);
    }
//    else if(section ==3)
//        return UIEdgeInsetsMake(insetUpDown, 1.5, insetUpDown, 1.5+insetLeftRight);

    return UIEdgeInsetsMake(insetUpDown, 1.5, insetUpDown, 1.5);

 //   return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    if ([self.delegate respondsToSelector:@selector(collectionViewdidSelectItemAtIndexPath:)]) {
        [self.delegate collectionViewdidSelectItemAtIndexPath:indexPath.section];
    }
    
}
@end
