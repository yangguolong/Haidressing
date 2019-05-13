//
//  YZMHairstylistTableViewCell.m
//  Hairdressing
//
//  Created by yzm on 5/6/16.
//  Copyright © 2016 Yangjiaolong. All rights reserved.
//

#import "YZMHairstylistTableViewCell.h"
#import "TLTagsControl.h"
#import "YZMSimpleImageViewCollectionViewCell.h"
#import "YZMHairstyModel.h"
#import "BitmapUtils.h"

@interface YZMHairstylistTableViewCell () <UICollectionViewDataSource, UICollectionViewDelegate ,TLTagsControlDelegate>
{
    TLTagsControl *tagsControl;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
//@property (nonatomic, strong) TLTagsControl *tagControl;

@property (weak, nonatomic) IBOutlet UIView *tagView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UIButton *reserveButton;

@property (strong, nonatomic) YZMHairstyModel *viewModel;


@end

@implementation YZMHairstylistTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.iconImageView.layer.cornerRadius =  self.iconImageView.frame.size.width / 2;
    self.iconImageView.layer.borderWidth = 0.5;
    self.iconImageView.layer.borderColor = [UIColor grayColor].CGColor;
    self.iconImageView.layer.masksToBounds = YES;
    
    self.reserveButton.layer.cornerRadius = 2;
    self.reserveButton.layer.borderWidth = 1;
    self.reserveButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.reserveButton.layer.masksToBounds = YES;
    
    tagsControl = [[TLTagsControl alloc]initWithFrame:CGRectMake(0, 0, self.tagView.size.width , self.tagView.size.height)
                                                  andTags:@[@"These", @"Tags", @"Are", @"Tapable"]
                                      withTagsControlMode:TLTagsControlModeList];
    tagsControl.tagsBackgroundColor = [UIColor whiteColor];
    tagsControl.tagsTextColor = [UIColor blackColor];
    
    [tagsControl reloadTagSubviews];
    [tagsControl setTapDelegate:self];
    [self.tagView addSubview:tagsControl];
    
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([YZMSimpleImageViewCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([YZMSimpleImageViewCollectionViewCell class])];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    
    
}

- (void)bindViewModel:(YZMHairstyModel *)viewModel
{
    self.viewModel = viewModel;
    self.titleLabel.text = [NSString stringWithFormat:@"%@",viewModel.hairstylist_name];
    self.subtitleLabel.text = [NSString stringWithFormat:@"%@ | %@ ", viewModel.corporation, viewModel.district_name];
    [ BitmapUtils setImageWithImageView:self.iconImageView URLString:viewModel.photo_url];
    
    
    
    NSMutableArray *tags = [[NSMutableArray alloc] init];
    tagsControl.tags = viewModel.hairsty_label;
    
    long count = viewModel.hairsty_label.count - 1;
    for (long i = count; i >= 0 ;i--) {
        NSString *str = viewModel.hairsty_label[i];
        if(str && str.length >0 && tags.count <2) {
            [tags addObject:str];
        }
    }
    tagsControl.tags = tags;
    
    [tagsControl reloadTagSubviews];
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.viewModel ? self.viewModel.portfolio.count : 0;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YZMSimpleImageViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([YZMSimpleImageViewCollectionViewCell class]) forIndexPath:indexPath];
    
    cell.image_url = self.viewModel.portfolio[indexPath.row][@"img"];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    CGFloat width = (SCREEN_WIDTH - 16 - 20) / 4 ;
    return CGSizeMake(width, width);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}



#pragma mark - TLTagsControlDelegate
- (void)tagsControl:(TLTagsControl *)tagsControl tappedAtIndex:(NSInteger)index
{
    
}

@end
