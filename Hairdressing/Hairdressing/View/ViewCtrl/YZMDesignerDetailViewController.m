//
//  YZMDesignerDetailViewController.m
//  Hairdressing
//
//  Created by Guolong Yang on 16/4/6.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "YZMDesignerDetailViewController.h"
#import "DesignerDetailViewModel.h"
#import "ServiceCell.h"
#import "DesignerComposition.h"
#import "ServiceCategories.h"
#import "DesignerCompositionCell.h"
#import "DesignerCompositionViewModel.h"
#import "UIImage+ImageEffects.h"
#import "Utility.h"

@interface YZMDesignerDetailViewController ()<DesignerCompositionCellDelegate,UIScrollViewDelegate>


@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (weak, nonatomic) IBOutlet UIImageView *backHeadImageView;

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *signatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *studioNameLab;


@property(nonatomic,strong,readonly)DesignerDetailViewModel *viewModel;
@end


@implementation YZMDesignerDetailViewController
@dynamic   viewModel;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"DesignerCompositionCell" bundle:nil] forCellReuseIdentifier:@"DesignerCompositionCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ServiceCell" bundle:nil] forCellReuseIdentifier:@"ServiceCell"];
    self.backHeadImageView.contentScaleFactor = [[UIScreen mainScreen] scale];
    self.backHeadImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.backHeadImageView.clipsToBounds = YES;
    self.backHeadImageView.userInteractionEnabled = YES;
    @weakify(self)
    [self.viewModel.requestRemoteDataCommand.executing subscribeNext:^(NSNumber *executing) {
        @strongify(self)
        if (executing.boolValue) {
            //            if (self.viewModel.dataSource.count !=0)
            [MBProgressHUD showHUDAddedTo:self.view animated:YES].labelText = MBPROGRESSHUD_LABEL_TEXT;
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];
    
    [self.view bringSubviewToFront:self.backButton];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
  //  self.navigationController.navigationBar.alpha = 0.0;
//    self.navigationController.navigationBar.translucent = YES;
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage createImageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage createImageWithColor:[UIColor clearColor]]];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
  //  self.navigationController.navigationBar.alpha = 1.0;
//    self.navigationController.navigationBar.translucent = NO;
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:nil];
    
}

-(void)bindViewModel{
    [super bindViewModel];

    @weakify(self)
    RAC(self.nickNameLabel,text) = RACObserve(self.viewModel, nickName);
    RAC(self.signatureLabel,text)=RACObserve(self.viewModel, signatureStr);
 //   RAC(self.studioNameLab,text) = RACObserve(self.viewModel, studioName);
    [RACObserve(self.viewModel, studioName) subscribeNext:^(NSString *str) {
        self.studioNameLab.text = [NSString stringWithFormat:@" %@    ",str];
    }];
    [RACObserve(self.viewModel, headImgViewURLStr) subscribeNext:^(NSString *urlStr) {
        @strongify(self)
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"haha"]];
    }];
    [RACObserve(self.headImageView,image) subscribeNext:^(id x) {
        @strongify(self)
        if (self.viewModel.headImgViewURLStr!=nil) {
            self.backHeadImageView.image = self.headImageView.image ;
            [Utility addLinearGradientToView:self.backHeadImageView withColor:[UIColor whiteColor] transparentToOpaque:NO];
        }
    }];
}


#pragma mark --UITableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==1) {
        return 60;
    }
    return 10;
    
}
////- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
////    if (section == 0) {
////        return [StudioDetailHeaderView initHeaderView];
////    }
////    return nil;
////}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (DEVICE_IS_IPHONE6P) {
            return 159;
        }
        return 149;
    }
    else if(indexPath.section == 1){
        return 65;
    }
    return 44;

}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view  = [[UIView alloc ]initWithFrame:CGRectMake(0, 0, kWidth, 10)];
    view.backgroundColor = [UIColor colorWithRed:243.0/255.0 green:245.0/255.0 blue:246.0/255.0 alpha:1];
    if (section == 1 ) {
        UIView *labelView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, kWidth, 50)];
        view.frame = CGRectMake(0, 0, kWidth, 60);
        labelView.backgroundColor = [UIColor whiteColor];
        [view addSubview:labelView];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 20, kWidth, 20)];
        label.text = @"服务项目";
        //        label.backgroundColor = [UIColor blueColor];
        [label setFont:[UIFont boldSystemFontOfSize:16.0f]];
        [labelView addSubview:label];
        
    }
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [tableView dequeueReusableCellWithIdentifier:@"DesignerCompositionCell" forIndexPath:indexPath];
    }
        return [tableView dequeueReusableCellWithIdentifier:@"ServiceCell" forIndexPath:indexPath];
    
}
//
- (void)configureCell:(DesignerCompositionCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(DesignerDetailViewModel *)viewModel {
    if (indexPath.section == 0)
    {

        [cell bindViewModel:(DesignerComposition*)viewModel];
         cell.delegate = self;
    }
    if (indexPath.section == 1) {
        [(ServiceCell *)cell bindViewModel:(ServiceCategories*)viewModel];
    }

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.viewModel.didSelectCommand execute:indexPath];
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark --StudioDesignerCellDelegate
-(void)cellWithDesignerIndex:(NSInteger)designerIndex{
    [self.viewModel.collectionViewSelectCommand execute:[NSNumber numberWithInteger:[self.viewModel.designerID integerValue]]];

}
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if (scrollView == self.tableView) {
//        //获取偏移量
//        CGPoint offset = scrollView.contentOffset;
//        if (offset.y>0) {
////            if (self.navigationController.navigationBar.translucent == YES)
////            {
////                self.navigationController.navigationBar.translucent = NO;
//                self.navigationController.navigationBar.alpha = (offset.y)/300.0;
////            }
//
//        }
//        else{
////            if (!(self.navigationController.navigationBar.translucent == YES && self.navigationController.navigationBar.alpha ==1.0)) {
////                self.navigationController.navigationBar.translucent = YES;
//                self.navigationController.navigationBar.alpha = 0.0;
////            }
//        }
//     //   NSLog(@"offsety:%f",offset.y);
//
//    }
//   
//}

- (IBAction)backToLastNaviga:(id)sender {
    [self.viewModel.services popViewModelAnimated:YES];
}




@end
