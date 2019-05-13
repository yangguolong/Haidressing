//
//  UserInfoViewController.m
//  Hairdressing
//
//  Created by BoDong on 16/3/28.
//  Copyright © 2016年 Cloudream. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UserViewModel.h"
#import "AllUserInfoEditViewController.h"
@interface UserInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UIViewControllerTransitioningDelegate,LEActionSheetDelegate>

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人资料";
    _userInfoTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64) style:UITableViewStyleGrouped];
//    userInfoTableView.delegate = self;
//    userInfoTableView.dataSource = self.userInfoViewModel ;
    _userInfoTableView.userInteractionEnabled = YES;
    _userInfoTableView.bounces = YES;
    _userInfoTableView.dataSource = self   ;
    _userInfoTableView.delegate = self;
    _userInfoTableView.separatorInset = UIEdgeInsetsZero;
    _userInfoTableView.tableFooterView = [UIView new];
    [self.view addSubview:_userInfoTableView];
    
    userInfoListArray = [[NSArray alloc]initWithObjects: @"昵称",@"年龄",@"性别",@"手机号", nil];
    _avatarButton = [[UIButton alloc] initWithFrame:CGRectMake(kWidth-40-40, 10, 45, 45)];
    [self initData];
    [self bindViewModel];
//    @weakify(self)
//    RACSignal *requestSignal = [self.userInfoViewModel.requestCommand execute:nil];
//    [requestSignal subscribeNext:^(NSArray *x) {
//        @strongify(self)
//        self.userInfoViewModel.models = x;
//        [userInfoTableView reloadData];
//    }];
    // Do any additional setup after loading the view.
}
-(UserViewModel*)userViewModel{
    if (!_userViewModel) {
        _userViewModel   = [[UserViewModel alloc]init];
        
    }
    return _userViewModel;
}

-(void)initData{
    User *user=[User getUserFromDB]; ;
    if (!user) {
        user  = [[User alloc]  init];
        user.name = @"liweixiong";
        user.account = @"13600172150";
        user.birthday = @"1949/01/01";
        user.sexuality =@"男";
        [user saveOrUpdate];
    }

    
}


-(void)bindViewModel{
    @weakify(self)
    [RACObserve(self.userViewModel, avatarURL) subscribeNext:^(NSURL *avartURL) {
        @strongify(self)
        [self.avatarButton sd_setImageWithURL:avartURL forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default-avatar"]];
    }];
    
    [[self.avatarButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *avatarButton) {
        @strongify(self)
        [UIApplication sharedApplication].delegate.window.backgroundColor = [UIColor blackColor]    ;
        TGRImageViewController *viewController = [[TGRImageViewController alloc] initWithImage:[avatarButton imageForState:UIControlStateNormal]];
        
        viewController.view.frame = CGRectMake(0, 0, kWidth, kHeight);
        viewController.transitioningDelegate = self;
        
        [self presentViewController:viewController animated:YES completion:NULL];
    }];
    
    

}

#pragma mark --UItableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 64   ;
    }
    return 44;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return userInfoListArray.count;

}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"userInfoCell";
    UITableViewCell *cell;
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=  [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!(indexPath.section==1 &&indexPath.row == 3)) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    if (indexPath.section == 0) {
        cell.textLabel.text = @"头像"   ;
        _avatarButton.backgroundColor = [UIColor grayColor];
        _avatarButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [cell.contentView addSubview:_avatarButton];
    }
    else{
        cell.textLabel.text = [userInfoListArray objectAtIndex:indexPath.row];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(70, 12, kWidth-100, 20)];
       // label.tag = 1002;
//        label.backgroundColor = [UIColor yellowColor];
        label.textColor = [UIColor lightGrayColor];
        label.font =  [UIFont systemFontOfSize:15.0f];
        label.textAlignment = NSTextAlignmentRight;
        label.text =nil;
        [cell.contentView addSubview:label];
        if (indexPath.row==0) {
            label.text = self.userViewModel.name;
            
        }
        else if(indexPath.row ==1)
        {
            label.text = self.userViewModel.birthday;
        }
        else if(indexPath.row == 2){
            label.text = self.userViewModel.sexuality;
        }
        else if(indexPath.row==3){
            label.text = self.userViewModel.account;
        }
    }
    
    return cell ;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        [self showAction];
    }
    else if(indexPath.section == 1){
        if (indexPath.row == 0 ){
            //进入姓名编辑页面
            [self userInfoEditUserInfoEvent:@"name"];
        }
        else if ( indexPath.row == 1){//
            [self userInfoEditUserInfoEvent:@"birthday"];
            
        }
        else if ( indexPath.row == 2){//
            [self userInfoEditUserInfoEvent:@"sexuality"];
            
        }
    
    }
}

/** 修改个人信息 */
- (void)userInfoEditUserInfoEvent:(NSString *)infoItem
{
    
    if(_editUserInfo)
    {
        _editUserInfo = nil;
    }
    
    _editUserInfo = [[AllUserInfoEditViewController alloc] init];
    _editUserInfo.userInfoViewModel = self.userViewModel;
    _editUserInfo.userEditItem = infoItem;
    [self.navigationController  pushViewController:_editUserInfo animated:YES];
    
    __weak __typeof__(self) weakSelf = self;
    _editUserInfo.updateBlock = ^(User *userInfoModel){
        //_userDetailModel = [[UserDetailModel alloc] initWithUser:userInfoModel];
      //  [userInfoModel saveOrUpdate];
        [weakSelf.userInfoTableView reloadData];
    };
}

/** 自己的个人信息 点击头像的触发事件*/
- (void)showAction
{
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
    CGFloat Y = DEVICE_IS_IPHONE5?80:50;
    VPImageCropperViewController *VC = [[VPImageCropperViewController alloc] initWithImage:portraitImg
                                                                                 cropFrame:CGRectMake(0, Y, kWidth, kWidth)
                                                                           limitScaleRatio:3.0];
    VC.parent = self;
    [self.navigationController pushViewController:VC animated:YES];
}


#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    if ([presented isKindOfClass:TGRImageViewController.class]) {
        return [[TGRImageZoomAnimationController alloc] initWithReferenceImageView:self.avatarButton.imageView];
    }
    return nil;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    if ([dismissed isKindOfClass:TGRImageViewController.class]) {
        return [[TGRImageZoomAnimationController alloc] initWithReferenceImageView:self.avatarButton.imageView];
    }
    return nil;
}

@end
