//
//  DesignerCompositionViewController.m
//  Hairdressing
//
//  Created by Guolong Yang on 16/4/20.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "DesignerCompositionViewController.h"
#import "DesignerCompositionViewModel.h"
#import "DesignerListCollectionCell.h"
#import "MJNewsView.h"
#import "MJNewsModel.h"
#define DESIGNER_CELL_WIDTH ((kWidth-2)/3)

@interface DesignerCompositionViewController() <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UIScrollViewDelegate>

@property(nonatomic,strong)UICollectionView *collectionDesignerView;
@property(nonatomic,strong)NSMutableArray *imageArray;

@property(nonatomic,assign)BOOL isWholePage;
//@property (weak, nonatomic) IBOutlet UILabel *compositionCountLab;
@property(nonatomic,strong)UILabel *compositionCountLab;
@property(nonatomic,strong)DesignerCompositionViewModel *viewModel;
@end

@implementation DesignerCompositionViewController
static NSString *BigCellIdentifier =@"BigCollectionViewCell" ;
static NSString *const reuseIdentifier = @"DesignerComposition";
@dynamic   viewModel;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"作品";
    self.isWholePage = NO;
    self.imageArray = [[NSMutableArray alloc]init];
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.minimumInteritemSpacing = 0.f;//同一行cell的间距，经过测试最小为1
    flowLayout.minimumLineSpacing = 1; //上下的间距 可以设置0看下效果
    flowLayout.sectionInset = UIEdgeInsetsZero;
    //    _flowLayout.minimumLineSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0.f, 0, 0.f, 0);
//    self.compositionCountLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kWidth, 44)];
//    [self.view addSubview:self.compositionCountLab];
    self.collectionDesignerView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64) collectionViewLayout:flowLayout];
    self.collectionDesignerView.dataSource=self;
    self.collectionDesignerView.delegate=self;
    self.collectionDesignerView.pagingEnabled = YES;
    
    [self.collectionDesignerView setBackgroundColor:[UIColor clearColor]];
    //注册Cell，必须要有，两套：放大的一套，正常状态的一套
//    [self.collectionDesignerView registerNib:[UINib nibWithNibName:@"DesignerListCollectionCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionDesignerView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionDesignerView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:BigCellIdentifier];
    
    [self.view addSubview:self.collectionDesignerView];
    
    [self.viewModel.downloadComposiCommand execute:nil];
    
    coverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64)];
    coverView.backgroundColor= [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];
    [self.view addSubview:coverView];
    UIImage *image = [UIImage imageNamed:@"icon_No_work"];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth/2-image.size.width/2, (kHeight-64)/2-image.size.height/2, image.size.width, image.size.height)];
    imageView.image = image;
    [coverView addSubview:imageView];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(50, imageView.bottom, kWidth-100, 80)];
    label.textColor=[UIColor lightGrayColor];
    [label setFont:[UIFont systemFontOfSize:14.0]];
    label.text = @"抱歉！\n该门店发型师还没有上传发型师作品";
    label.numberOfLines = 0;
    label.textAlignment=NSTextAlignmentCenter;
    [coverView addSubview:label];
    
    [self.view bringSubviewToFront:coverView];
    coverView.hidden = YES;
}
//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//
//}
//-(void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//
//}
-(void)bindViewModel{
//    RAC(self,imageArray) = RACObserve(self.viewModel, imagePathArr);
        @weakify(self)
    [[RACObserve(self.viewModel, imagePathArr) skip:1] subscribeNext:^(id x) {
        @strongify(self)
        self.imageArray = self.viewModel.imagePathArr;
        if (self.imageArray.count == 0) {
            coverView.hidden = NO;
        }
        else
        {
            coverView.hidden = YES;
            [self.collectionDesignerView reloadData];
        }

    }];

    [RACObserve(self.viewModel, masterpieceCount) subscribeNext:^(id x) {
        @strongify(self)
        self.compositionCountLab.text = [NSString stringWithFormat:@"作品数: %d",self.viewModel.masterpieceCount];
    }];
    
    
    
}

#pragma mark UicollectionView Datasource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageArray.count  ;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
    
}
//每个UICollectionView展示的内容
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell ;
    if (self.isWholePage) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:BigCellIdentifier forIndexPath:indexPath];
        UIImageView *imageView  = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,kWidth-1, kWidth-1)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[self.imageArray objectAtIndex:indexPath.item]] placeholderImage:nil];
      //  imageView.backgroundColor  =[UIColor blueColor];
        [cell.contentView addSubview:imageView];
    }
    else{
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
      //  cell.contentView.backgroundColor = [UIColor blueColor];
        UIImageView *imageView  = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, DESIGNER_CELL_WIDTH, DESIGNER_CELL_WIDTH)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[self.imageArray objectAtIndex:indexPath.item]] placeholderImage:nil];
    //    imageView.backgroundColor  =[UIColor blueColor];
        [cell.contentView addSubview:imageView];
    }
    
    return cell;
}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isWholePage) {
        return CGSizeMake(kWidth-1, kWidth-1);
    }
    return CGSizeMake(DESIGNER_CELL_WIDTH, DESIGNER_CELL_WIDTH);
}

//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(0, 0, 0, 0);
//}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 0.f;//同一行cell的间距，经过测试最小为1
    flowLayout.minimumLineSpacing = 1; //上下的间距 可以设置0看下效果
    flowLayout.sectionInset = UIEdgeInsetsZero;
    [self.collectionDesignerView removeFromSuperview];
    [pageLabel removeFromSuperview];
    pageLabel = [[UILabel alloc]initWithFrame:CGRectMake(kWidth/2-60, kHeight-44-15-50, 120, 50)];
    pageLabel.textColor= [UIColor whiteColor];
    pageLabel.tag = 99;
   // pageLabel.backgroundColor = [UIColor blueColor];
    imageTotalCount =self.viewModel.imagePathArr.count;
    pageLabel.text = [NSString stringWithFormat:@"%d/%lu",indexPath.item+1,imageTotalCount];
    pageLabel.textAlignment = NSTextAlignmentCenter;
    if (self.isWholePage) {
        self.isWholePage = NO;
        self.view.backgroundColor = [UIColor whiteColor];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        self.collectionDesignerView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64) collectionViewLayout:flowLayout];
        pageLabel.hidden = YES;

    }
    else
    {
        self.isWholePage =YES;
        self.view.backgroundColor = [UIColor blackColor];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        self.collectionDesignerView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-44) collectionViewLayout:flowLayout];
        [self.collectionDesignerView setContentOffset:CGPointMake(kWidth*indexPath.item, 0)];

        pageLabel.hidden = NO;

    }


    self.collectionDesignerView.dataSource=self;
    self.collectionDesignerView.delegate=self;
    self.collectionDesignerView.pagingEnabled = YES;
    self.collectionDesignerView.scrollEnabled = YES;
    [self.collectionDesignerView setBackgroundColor:[UIColor clearColor]];
    [self.collectionDesignerView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionDesignerView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:BigCellIdentifier];
    
    [self.view addSubview:self.collectionDesignerView];
    [self.view addSubview:pageLabel];

    
    // @weakify(self)
//    __weak typeof(self) weakself = self;
//    
//    [self.collectionDesignerView setCollectionViewLayout:flowLayout animated:YES completion:^(BOOL finished) {
//        [weakself.collectionView reloadData];
//    }];
    
    
}

#pragma mark --uiscrollviewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    float index = scrollView.contentOffset.x/kWidth + 0.5;
    pageLabel.text =[NSString stringWithFormat:@"%lu/%lu",(NSUInteger)index+1,(unsigned long)imageTotalCount];
}



@end
