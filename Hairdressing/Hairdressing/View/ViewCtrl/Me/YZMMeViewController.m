//
//  YZMMeViewCtrlView.m
//  Hairdressing
//
//  Created by 杨国龙 on 16/3/4.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "YZMMeViewController.h"
#import "TGRImageViewController.h"
#import "TGRImageZoomAnimationController.h"
#import "UserInfoViewController.h"
#import "SettingViewController.h"
#import "LoginViewController.h"
#import "YZMOrderListViewModel.h"
#import "UIImage+ImageEffects.h"
#import "VPImageCropperViewModel.h"
#import "OrderTableViewCell.h"
#import "OrderDetailCell.h"
#import "AllOrderInfoViewModel.h"
#import "YZMOrderService.h"
//#import "MeTableViewCell.h"

@interface YZMMeViewController ()
@property(nonatomic,strong,readonly)YZMMeViewModel *viewModel;
//@property(nonatomic,strong)    UITableView *meTableView;
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIImageView *headBackgroundView;

@property (weak, nonatomic) IBOutlet UIImageView *userPortrait;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLab;
@property(nonatomic,strong)UIImageView *backHeadImageView;
//@property(nonatomic,strong)       UILabel *nickNameLab;// 用户昵称
@property(nonatomic,strong,readwrite)AllOrderInfoViewModel *allOrderViewModel;


@end

@implementation YZMMeViewController
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    moreFunctionListArray = [NSArray arrayWithObjects:@"邀请好友",@"设置",@"意见反馈", nil];
    self.userPortrait.layer.masksToBounds = YES;
    self.headBackgroundView.contentScaleFactor = [[UIScreen mainScreen] scale];
    self.headBackgroundView.contentMode = UIViewContentModeScaleAspectFill;
    self.headBackgroundView.clipsToBounds = YES;
    self.headBackgroundView.userInteractionEnabled = YES;
    
    @weakify(self)
    [[[[NSNotificationCenter defaultCenter]
       rac_addObserverForName:UserUpdateHeadImageNotification object:nil]
      takeUntil:self.rac_willDeallocSignal]
     subscribeNext:^(NSNotification *notification) {
         @strongify(self)
         UIImage *photoImage = notification.object;
         NSData *imageData = UIImageJPEGRepresentation(photoImage, 0.5);
         [self.viewModel.imageUploadCommand execute:[UIImage imageWithData:imageData]];
     }];
    [self.viewModel.orderInfoCommand.executionSignals.switchToLatest subscribeNext:^(NSDictionary *dict) {
        @strongify(self)
        NSLog(@"%@",dict);
        AllOrderInfoViewModel *model = [[AllOrderInfoViewModel alloc]init];
        model.payedCount = [dict[@"payed"] intValue];
        model.unCommentCount = [dict[@"unComment"] intValue] ;
        model.unPayedCount =[dict[@"unPayed"]intValue];
        self.allOrderViewModel = model;
        [self.tableView reloadData];
    }];
    
    [[[[NSNotificationCenter defaultCenter]
       rac_addObserverForName:UserInfoChangeNotification object:nil]
      takeUntil:self.rac_willDeallocSignal]
     subscribeNext:^(NSNotification *notification) {
         @strongify(self)
         if ([[NSUserDefaults standardUserDefaults]boolForKey:ISLOGIN]) {
             [self.viewModel.userInfoGetCommand execute:nil];
             [self.viewModel.orderInfoCommand execute:nil];
         }
         else{
             self.viewModel.name = nil;
             self.viewModel.imageURLString=nil;
         }

     }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (![[NSUserDefaults standardUserDefaults]boolForKey:ISLOGIN]){
        return;
    }
    [self.viewModel.orderInfoCommand execute:nil];
    
}
-(void)bindViewModel{
    @weakify(self)

    [RACObserve(self.viewModel, name) subscribeNext:^(id x) {
        @strongify(self)
        if ((self.viewModel.name ==nil) || (self.viewModel.name.length == 0)) {
            self.nickNameLab.text = @"用户昵称";
        }
        else
            self.nickNameLab.text =self.viewModel.name;
    }];
    [RACObserve(self.viewModel, imageURLString) subscribeNext:^(NSString *avartURLStr) {
         @strongify(self)

        [self.userPortrait sd_setImageWithURL:[NSURL URLWithString:avartURLStr] placeholderImage:[UIImage imageNamed:@"my_head_default"]];
    }];
    [self.userPortrait addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAction)]];
    [RACObserve(self.userPortrait,image) subscribeNext:^(id x) {
        @strongify(self)
        if (self.viewModel.imageURLString!=nil) {
            self.headBackgroundView.image =[self.userPortrait.image applyLightEffect] ;
//          [Utility addLinearGradientToView:self.headBackgroundView withColor:[UIColor whiteColor] transparentToOpaque:NO];
        }
        else
            self.headBackgroundView.image =self.userPortrait.image;
    }];
}

#pragma mark --UITableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }
    return moreFunctionListArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 1) {
        return 120  ;
    }

    return 60;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell *cell= [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if(indexPath.section == 0){
        //我的订单cell
        if ( indexPath.row == 0) {
            OrderTableViewCell *cell = [OrderTableViewCell cellWithTableView:tableView];

            return cell;
        }
        else if(indexPath.row == 1){
            OrderDetailCell *cell = [OrderDetailCell cellWithTableView:tableView];
            cell.waitConsumeCountLab.hidden =YES;
            cell.waitPayCountLab.hidden =YES;
            cell.waitReviewCountLab.hidden =YES;
            if ([[NSUserDefaults standardUserDefaults]boolForKey:ISLOGIN]) {
                cell.waitConsumeCountLab.hidden =NO;
                cell.waitPayCountLab.hidden =NO;
                cell.waitReviewCountLab.hidden =NO;
            }
            [cell.waitingForCousumeView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpToConsumeView)]];
            [cell.waitingForPayView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpToPayView)]];
            [cell.waitingForReviewView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpToReviewView)]];
            [cell.moneyBackView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpToMoneyBackView)]];
            [cell bindViewModel:self.allOrderViewModel];
            return cell;
        }
    }
    else if(indexPath.section == 1){
        //更多功能列表cell
        NSMutableArray *imageArray = [[NSMutableArray alloc]initWithObjects:@"my_btn_share",@"my_btn_set",@"my_btn_advice", nil];
        cell.textLabel.text = [moreFunctionListArray objectAtIndex:indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.separatorInset = UIEdgeInsetsMake(0.f, 10.f, 0.f, 10.0f);
        if (indexPath.row<=2) {
            cell.imageView.image = [UIImage imageNamed:[imageArray objectAtIndex:indexPath.row]];
        }

    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
//    [self.viewModel.didSelectCommand execute:indexPath];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        [self jump2OrderListViewCtrlType:YZMOrderRequestTypeAll];
        
    }
    else
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    
    
}


- (void)jump2OrderListViewCtrlType:(YZMOrderRequestType)type
{
    if (![[NSUserDefaults standardUserDefaults]boolForKey:ISLOGIN])
    {
        LoginViewModel *loginViewModel = [[LoginViewModel alloc] initWithServices:self.viewModel.services params:nil];
        [self.viewModel.services presentViewModel:loginViewModel animated:YES completion:nil];
        return;
    }

    
    YZMOrderListViewModel *orderListViewModel = [[YZMOrderListViewModel alloc] initWithServices:self.viewModel.services params:@{@"requestType" : @(type)}];
    
    [self.viewModel.services pushViewModel:orderListViewModel animated:YES];
}

/** 自己的个人信息 点击头像的触发事件*/
- (void)showAction
{
    if (![[NSUserDefaults standardUserDefaults]boolForKey:ISLOGIN]){
        //如果用户未登录，则跳转到登录页面
        LoginViewModel *loginViewModel = [[LoginViewModel alloc] initWithServices:self.viewModel.services params:nil];
        [self.viewModel.services presentViewModel:loginViewModel animated:YES completion:nil];
        return ;
    }
    LEActionSheet *actionSheet = [[LEActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"图库选择头像",@"拍摄头像", nil];
    actionSheet.tag = 999;
    [actionSheet showInView:self.view.window];
    
}

#pragma mark - LEActionSheetDelegate
-(void)actionSheet:(LEActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 999)
    {
        //更换头像
        if(buttonIndex == 0) {
            [self.mediaPicker showWithPhotoLibrary];
        }
        if(buttonIndex == 1) {
            [self.mediaPicker showWithCamera];
        }
    }
}

-(MediaPickerController *)mediaPicker
{

    if (_mediaPicker) {
        return _mediaPicker;
    }
    _mediaPicker = [[MediaPickerController alloc] init];
    _mediaPicker.delegate = self;
    return _mediaPicker;
}

#pragma mark - MediaPickerControllerDelegate
-(void)finishPickingMediaWithInfo:(NSDictionary *)info mediaType:(MediaType)mediaType isFromCamera:(BOOL)isFromCamera
{
    if (mediaType == VIDEOTYPE) {
        return;
    }
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *portraitImg = [Utility imageByScalingToMaxSize:image];

    [self.viewModel.cropImageCommand execute:portraitImg];
    
}


//#pragma mark - UIScrollViewDelegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if (scrollView == self.tableView)
//    {
//        CGFloat Y = scrollView.contentOffset.y;
//        if (Y < 0) {
//            self.headBackgroundView.frame = CGRectMake(Y,Y,kWidth-Y*2, 200-Y);
//            NSLog(@"frame:x:%f y:%f width:%f height:%f",self.headBackgroundView.frame.origin.x,self.headBackgroundView.frame.origin.y,self.headBackgroundView.frame.size.width,self.headBackgroundView.frame.size.height);
//        }
//        
//    }
//    
//}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //获取偏移量
    CGPoint offset = scrollView.contentOffset;
    //判断是否改变
    if (offset.y < 0) {
        CGRect rect = self.headBackgroundView.frame;
        //我们只需要改变图片的y值和高度即可
        rect.origin.y = offset.y;
        rect.size.height = 229 - offset.y;
        self.headBackgroundView.frame = rect;
    }
    
}

#pragma mark --tap gesture jump view
-(void)jumpToConsumeView
{
   // NSLog(@"jumpToConsumeView");
     [self jump2OrderListViewCtrlType:YZMOrderRequestTypeUnConsumed];
}

-(void)jumpToPayView
{
//    NSLog(@"jumpToPayView");
    [self jump2OrderListViewCtrlType:YZMOrderRequestTypeUnpaid];
}
-(void)jumpToReviewView
{
  //   NSLog(@"jumpToReviewView");
    [self jump2OrderListViewCtrlType:YZMOrderRequestTypeReview];
    
}
-(void)jumpToMoneyBackView{
    // NSLog(@"jumpToMoneyBackView");
        [self jump2OrderListViewCtrlType:YZMOrderRequestTypeRefund];
}


#pragma mark--ButtonClickAction

- (IBAction)editUserInfo:(id)sender {
    
  [self.viewModel.goToSettingCommand execute:nil];
    
    
}

@end