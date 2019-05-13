//
//  YZMStudioDetailViewController.m
//  Hairdressing
//
//  Created by Guolong Yang on 16/4/7.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "YZMStudioDetailViewController.h"
#import "StudioDetailViewModel.h"
#import "StudioDesignerCell.h"
#import "CommentCell.h"
#import "ServiceCell.h"
#import "StudioDetail.h"
#import "StudioComment.h"
#import "MJNewsView.h"
#import "MJNewsModel.h"
#import "DesignerDetailViewModel.h"
#import "YZMCommentViewModel.h"
@interface YZMStudioDetailViewController ()<StudioDesignerCellDelegate>

//@property (weak, nonatomic) IBOutlet UIImageView *envLogoImageView;//
//@property (weak, nonatomic) IBOutlet UILabel *buyerCountLabel;
//@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
//@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
//@property (weak, nonatomic) IBOutlet UIButton *phoneCallButton;
//@property (weak, nonatomic) IBOutlet UILabel *orderQuantityLabel;
//@property (weak, nonatomic) IBOutlet UIButton *submitOrderButton;

//@property (weak, nonatomic) IBOutlet UIImageView *backToNavView;

@property (weak, nonatomic) IBOutlet UIButton *backToNavButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *phoneCallButton;
@property(nonatomic,copy)NSString *photoNumStr;
@property (weak, nonatomic) IBOutlet MJNewsView *sliderContentView;

@property(nonatomic,strong)NSMutableArray *sliderData;

@property(nonatomic,strong,readonly)StudioDetailViewModel *viewModel;

@property(nonatomic,strong)UIWebView *phoneView;

@end

@implementation YZMStudioDetailViewController
@dynamic   viewModel;
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.navigationBarHidden = YES;
    [self.tableView registerNib:[UINib nibWithNibName:@"StudioDesignerCell" bundle:nil] forCellReuseIdentifier:@"StudioDesignerCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CommentCell" bundle:nil] forCellReuseIdentifier:@"CommentCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ServiceCell" bundle:nil] forCellReuseIdentifier:@"ServiceCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    
//    UIButton * bt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
//    [bt setImage:[UIImage imageNamed:@"nav_det_back"] forState:UIControlStateNormal];
//    [bt addTarget:self action:@selector(backToLastNavigation ) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem * barItem = [[UIBarButtonItem alloc]initWithCustomView:bt];
//    self.navigationItem.leftBarButtonItem = barItem;
    
    [self.view bringSubviewToFront:self.backToNavButton];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];

}

-(void)bindViewModel{
    [super bindViewModel];
    @weakify(self)
    RAC(self.nameLabel,text ) = RACObserve(self.viewModel,studioName);
    RAC(self.addressLabel,text)  = RACObserve(self.viewModel, address);
    [RACObserve(self.viewModel, phoneNumStr) subscribeNext:^(NSString *string) {
        @strongify(self)
        self.photoNumStr = string;
      //  [self.phoneCallButton setTitle:string forState:UIControlStateNormal];
    }];
    

    [[[self.phoneCallButton rac_signalForControlEvents:UIControlEventTouchUpInside] deliverOnMainThread] subscribeNext:^(id x) {
        @strongify(self)
        NSLog(@"拨打电话:%@",self.photoNumStr);
        if (!self.phoneView) {
            self.phoneView = [[UIWebView alloc]init];
        }
        // NSString *subString = [self.phoneCallButton.titleLabel.text substringFrom:0 to:([self.phoneCallButton.titleLabel.text length]-20)];
        NSURL *url =[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.photoNumStr]];
        [self.phoneView loadRequest:[NSURLRequest requestWithURL:url]];
    }];
//浏览视图
//    self.sliderContentView.newses = self.sliderData;
   // RAC(self.sliderContentView,newses) = RACObserve(self,sliderData);
   // RAC(self,sliderData) = RACObserve(self.viewModel, imagePathArr);
    [RACObserve(self.viewModel, imagePathArr) subscribeNext:^(id x) {
        for (NSString *string in self.viewModel.imagePathArr) {
             MJNewsModel *model = [MJNewsModel modelWithId:nil name:nil imageUrl:string];
            [self.sliderData addObject:model];
        }
        self.sliderContentView.newses = self.sliderData;
    }];
}


#pragma mark --UITableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==2) {
        return 60;
    }
    return 10;
    
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view  = [[UIView alloc ]initWithFrame:CGRectMake(0, 0, kWidth, 10)];
    view.backgroundColor = [UIColor colorWithRed:243.0/255.0 green:245.0/255.0 blue:246.0/255.0 alpha:1];
    if (section == 2 ) {
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        if (DEVICE_IS_IPHONE6P) {
            return 159;
        }
        return 149;
    }
    else if(indexPath.section == 1){
        return [CommentCell heightOfCellWithModel:self.viewModel.dataSource[indexPath.section][indexPath.row]];
    }
    else if(indexPath.section == 2){
        return 65;
    }
    return 44;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0 ) {
        return [tableView dequeueReusableCellWithIdentifier:@"StudioDesignerCell" forIndexPath:indexPath];
    }
    else if(indexPath.section == 1  )
    {
        return [tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
    }
    else //if(self.viewModel.serviceHidden== NO)
        return [tableView dequeueReusableCellWithIdentifier:@"ServiceCell" forIndexPath:indexPath];

}

- (void)configureCell:(StudioDesignerCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(StudioDetailViewModel *)viewModel {
    if (indexPath.section == 0)
    {
            [cell bindViewModel:(NSMutableArray*)viewModel];
            cell.delegate = self;
    }
    else if (indexPath.section == 1 ) {
            [(CommentCell*)cell bindViewModel:(StudioComment*)viewModel];
    }
    else //if (viewModel.serviceCategories.serviceCount != 0)
    {
        [(ServiceCell*)cell bindViewModel:(ServiceCategories*)viewModel];
        
    }

}
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    if (indexPath.section==1) {// 点击查看全部评论
//        YZMCommentViewModel *commentViewModel =[[YZMCommentViewModel alloc]initWithServices:self.viewModel.services params:nil];
//        [self.viewModel.services pushViewModel:commentViewModel animated:YES];
//    }
//    
//}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    [self.viewModel.didSelectCommand execute:indexPath];
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
}

#pragma mark --StudioDesignerCellDelegate
-(void)cellWithDesignerIndex:(NSInteger)designerIndex{
    //执行pushviewmodel的命令
//    NSLog(@"cellWithDesignerIndex");
    DesignerDetailViewModel *desginerViewModel = [[DesignerDetailViewModel alloc]initWithServices:self.viewModel.services params:nil];
    desginerViewModel.designerID =[NSString stringWithFormat:@"%ld",(long)designerIndex];
    [self.viewModel.services pushViewModel:desginerViewModel animated:YES];
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
//}

- (NSMutableArray *)sliderData
{
    if (_sliderData == nil) {
        _sliderData =[[NSMutableArray alloc]init];
//        MJNewsModel *model0 = [MJNewsModel modelWithId:@"0" name:@"000" imageUrl:@"test01"];
//        MJNewsModel *model1 = [MJNewsModel modelWithId:@"1" name:@"111" imageUrl:@"test01"];
//        MJNewsModel *model2 = [MJNewsModel modelWithId:@"2" name:@"222" imageUrl:@"test01"];
//        MJNewsModel *model3 = [MJNewsModel modelWithId:@"3" name:@"333" imageUrl:@"test01"];
//        MJNewsModel *model4 = [MJNewsModel modelWithId:@"4" name:@"444" imageUrl:@"test01"];
//        _sliderData = [NSMutableArray arrayWithObjects:model0, model1, model2,model3,model4, nil];
    }
    return _sliderData;
    
}


//- (void)backToLastNavigation {
//       [self.viewModel.services popViewModelAnimated:YES];
//}
- (IBAction)backToLastNav:(id)sender {
       [self.viewModel.services popViewModelAnimated:YES];
    
}

@end