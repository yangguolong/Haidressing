//
//  YZMAppraiseViewController.m
//  Hairdressing
//
//  Created by Yangjiaolong on 16/5/24.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "YZMAppraiseViewController.h"
#import "YZMAppraiseViewModel.h"
#import "YZMSlider.h"
#import "CALayer+BorderColorFromUiColor.h"
#import "YZMAppraiseLabelCollectionViewCell.h"
#import "UIView+MJExtension.h"
#import "YZMAppraiseLabelModel.h"
#import "UIView+ShowHUD.h"
#import "UIScrollView+MJExtension.h"
@interface YZMAppraiseViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UICollectionView *markCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;

@property (weak, nonatomic) IBOutlet YZMSlider *techniqueSlider;
@property (weak, nonatomic) IBOutlet UILabel *techniqueScoreLabel;

@property (weak, nonatomic) IBOutlet YZMSlider *serviceSlider;
@property (weak, nonatomic) IBOutlet UILabel *servicesScoreLabel;

@property (weak, nonatomic) IBOutlet YZMSlider *environmentSlider;
@property (weak, nonatomic) IBOutlet UILabel *enviornmentScoreLabel;


@property (nonatomic,strong,readonly) YZMAppraiseViewModel * viewModel;
@property (weak, nonatomic) IBOutlet UIScrollView *backgrandScrollView;


@property (nonatomic,strong) UITapGestureRecognizer * tap;

@end

@implementation YZMAppraiseViewController
@dynamic viewModel;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tap = [[UITapGestureRecognizer alloc]init];
    [[self.tap rac_gestureSignal] subscribeNext:^(id x) {
        [self.view endEditing:YES];
    }];
    
    self.commitButton.rac_command = self.viewModel.commitButtonCommand;
    
    [_techniqueSlider setValuedidChangeBlock:^(CGFloat value) {
        _techniqueScoreLabel.text = [NSString stringWithFormat:@"%.1f",value];
        self.viewModel.aModel.tech_score = value;
    }];
    
    [_serviceSlider setValuedidChangeBlock:^(CGFloat value) {
        _servicesScoreLabel.text = [NSString stringWithFormat:@"%.1f",value];
        self.viewModel.aModel.service_score = value;
    }];
    
    [_environmentSlider setValuedidChangeBlock:^(CGFloat value) {
        _enviornmentScoreLabel.text = [NSString stringWithFormat:@"%.1f",value];
        self.viewModel.aModel.env_score = value;
    }];
    
    [_markCollectionView registerNib:[UINib nibWithNibName:@"YZMAppraiseLabelCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"YZMAppraiseLabelCollectionViewCell"];
    
    _markCollectionView.allowsMultipleSelection = YES;
    
    [RACObserve(self.viewModel, labels) subscribeNext:^(id x) {
        [_markCollectionView reloadData];
    }];
    [self.viewModel.commitButtonCommand.executing subscribeNext:^(id x) {
        if ( [x boolValue]) {
            [self.navigationController.view showHUDWith:@"正在提交..."];
        }else{
            [self.navigationController.view hideHUD];
        }
    }];
    [self.viewModel.commitButtonCommand.errors subscribeNext:^(id x) {
        [self.navigationController.view showHUDWith:@"提交失败" hideAfterDelay:1.5];
    }];
    RAC(self.viewModel.aModel,remark) = [self.textView rac_textSignal];
   
  
    // Do any additional setup after loading the view.
}

-(void)bindViewModel{
    [super bindViewModel];
  
    
//    RAC(self.viewModel,tech_score);
    
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [[self.viewModel.labels objectAtIndex:indexPath.row]setIsSelect:YES];
    
}
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    [[self.viewModel.labels objectAtIndex:indexPath.row] setIsSelect:NO];
    

}
#pragma  mark - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.viewModel.labels.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    YZMAppraiseLabelCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YZMAppraiseLabelCollectionViewCell" forIndexPath:indexPath];
    [cell updateUIWithModel:[self.viewModel.labels objectAtIndex:indexPath.row]];
    return cell;

}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((collectionView.mj_w - 30) / 4, 30);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [self.view removeGestureRecognizer:self.tap];
   [self.backgrandScrollView setContentOffset:CGPointMake(self.backgrandScrollView.mj_offsetX, 0) animated:YES];
    return YES;
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [self.view addGestureRecognizer:self.tap];
    CGFloat y = self.backgrandScrollView.mj_h - self.view.mj_h + 200;
       [self.backgrandScrollView setContentOffset:CGPointMake(self.backgrandScrollView.mj_offsetX, y) animated:YES];
    return YES;
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