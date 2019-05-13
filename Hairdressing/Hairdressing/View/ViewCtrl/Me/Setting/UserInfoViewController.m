//
//  UserInfoViewController.m
//  Hairdressing
//
//  Created by Guolong Yang on 16/3/28.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UserInfoViewModel.h"
#import "LocatePickerView.h"
#import "VPImageCropperViewModel.h"
@interface UserInfoViewController ()<LEActionSheetDelegate,LocatePickerViewDelegate,UITextFieldDelegate>
{
    LocatePickerView *pickerView;
    UIView *coverView;
    UITextField *userNameTextField;
    UIButton *saveButton;//保存按钮
}

@end

@implementation UserInfoViewController
@dynamic viewModel;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor  = [self.view superview].backgroundColor;
    self.title = @"编辑资料";
    _userInfoTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64) style:UITableViewStyleGrouped];
    _userInfoTableView.userInteractionEnabled = YES;
    _userInfoTableView.bounces = YES;
    _userInfoTableView.dataSource = self;
    _userInfoTableView.delegate = self;
    _userInfoTableView.separatorInset = UIEdgeInsetsZero;
    [self.view addSubview:_userInfoTableView];
    
    saveButton = [[UIButton alloc]initWithFrame:CGRectMake(kWidth/2-125, (44-40)/2, 250, 40)];
//    saveButton.backgroundColor = [UIColor blackColor];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    saveButton.layer.cornerRadius = 20;
    saveButton.userInteractionEnabled = YES;
    //button.layer.masksToBounds = YES;
    saveButton.clipsToBounds = YES;
    [saveButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 44)];
    [footerView addSubview:saveButton];
    footerView.backgroundColor = [UIColor clearColor];
    _userInfoTableView.tableFooterView = footerView;
    
    userInfoListArray = [[NSArray alloc]initWithObjects: @"昵称",@"年龄",@"性别",@"手机号", nil];
    _avatarButton = [[UIButton alloc] initWithFrame:CGRectMake(kWidth-40-40, 10, 45, 45)];
    _avatarButton.backgroundColor = [UIColor grayColor];
    [_avatarButton.layer setMasksToBounds:YES];
    [_avatarButton.layer setCornerRadius:22.5]; //设置矩形四个圆角半径
    _avatarButton.imageView.contentMode = UIViewContentModeScaleAspectFill;

    coverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    coverView.backgroundColor = [UIColor blackColor];
    coverView.alpha = 0.5;
    [self.userInfoTableView addSubview:coverView];
    coverView.hidden = YES;
    
    if (self.viewModel.birthday.length == 0)
    {
        self.viewModel.birthday = @"请填写";
    }
    if (self.viewModel.sexuality.length == 0)
    {
        self.viewModel.sexuality = @"请填写";
    }
    if (self.viewModel.userName.length == 0)
    {
        self.viewModel.userName = @"请填写";
    }
    @weakify(self)
//    [[[[NSNotificationCenter defaultCenter]
//       rac_addObserverForName:UserUpdateHeadImageNotification object:nil]
//      takeUntil:self.rac_willDeallocSignal]
//     subscribeNext:^(NSNotification *notification) {
//         @strongify(self)
//         UIImage *photoImage = notification.object;
//         NSData *imageData = UIImageJPEGRepresentation(photoImage, 0.5);
//         [self.viewModel.imageUploadCommand execute:[UIImage imageWithData:imageData]];
//     }];
    self.localUser =[User getUserFromDB];
    [RACObserve(self.localUser, portraitImageDir) subscribeNext:^(id x) {
        @strongify(self)
        self.viewModel.avatarURLStr  = self.localUser.portraitImageDir;
    }];

}

-(void)bindViewModel{
    @weakify(self)
    [RACObserve(self.viewModel, avatarURLStr) subscribeNext:^(NSString *avartURLStr) {
        @strongify(self)
        [self.avatarButton sd_setImageWithURL:[NSURL URLWithString:avartURLStr] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"my_head_default"]];
    }];

    [[RACSignal merge:@[RACObserve(self.viewModel, userName),RACObserve(self.viewModel, birthday),RACObserve(self.viewModel, sexuality)]]subscribeNext:^(id x) {
        @strongify(self)
        [self.userInfoTableView reloadData];
    }];
    [[self.avatarButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *avatarButton) {
        @strongify(self)
        [self showAction];
    }];
    [self.viewModel.saveCommand.executing
     subscribeNext:^(NSNumber *executing) {
         @strongify(self);
         if (executing.boolValue) {
             
             [self.view endEditing:YES];
             [MBProgressHUD showHUDAddedTo:self.view animated:YES].labelText = @"正在修改...";
         }else{
             [MBProgressHUD hideHUDForView:self.view animated:YES];
         }
     }];
    
    // 错误处理
    [self.viewModel.saveCommand.errors
     subscribeNext:^(NSError *error) {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         NSLog(@"save error:%@",error);
         
     }];
   saveButton.enabled  =  self.viewModel.validLoginSignal;
    RAC(saveButton,enabled) = self.viewModel.validLoginSignal   ;
    RAC(saveButton,backgroundColor) = [self.viewModel.validLoginSignal map:^id(NSNumber *valid) {
        return [valid boolValue]?[UIColor blackColor]:[UIColor lightGrayColor];
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
    if (section == 0 ) {
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

        [cell.contentView addSubview:_avatarButton];
    }
    else if(indexPath.section == 1){
        cell.textLabel.text = [userInfoListArray objectAtIndex:indexPath.row];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(70, 12, kWidth-100, 20)];
        label.textColor = [UIColor lightGrayColor];
        label.font =  [UIFont systemFontOfSize:15.0f];
        label.textAlignment = NSTextAlignmentRight;
        label.text =nil;
        [cell.contentView addSubview:label];
        if (indexPath.row==0) {
            cell.tag = 999;
            label.tag = 99;
            label.text = self.viewModel.userName;
        }
        else if(indexPath.row ==1)
        {
            label.text = [NSString stringWithFormat:@"%lu",(unsigned long)[Utility compareHoursWithDate:self.viewModel.birthday]];
        }
        else if(indexPath.row == 2){
            label.text = self.viewModel.sexuality;
        }
        else if(indexPath.row==3){
            label.text = self.viewModel.account;
        }
    }
    
    return cell ;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([userNameTextField isFirstResponder]) {
        [userNameTextField resignFirstResponder];
        return;
      //  self.viewModel.name =  userNameTextField.text;
    }
    if (indexPath.section == 0) {
        [self showAction];
    }
    else if(indexPath.section == 1){
        if (indexPath.row == 0 ){
            UILabel *label = (UILabel*)[tableView viewWithTag:99];
            label.hidden = YES;
            if (userNameTextField!=nil) {
                [userNameTextField removeFromSuperview];
            }
            userNameTextField = [[UITextField alloc]initWithFrame:CGRectMake(70, 12, kWidth-100, 20)];
            userNameTextField.backgroundColor = [UIColor clearColor]   ;
            userNameTextField.text =self.viewModel.userName;
            userNameTextField.delegate = self;
            userNameTextField.returnKeyType = UIReturnKeyDone;
            [userNameTextField becomeFirstResponder];
            UITableViewCell *cell = (UITableViewCell*)[tableView viewWithTag:999];
            [cell addSubview:userNameTextField];

        }
        else if ( indexPath.row == 1){//
            [self userInfoEditUserInfoEvent:@"birthday"];
            
        }
        else if ( indexPath.row == 2){//
            [self userInfoEditUserInfoEvent:@"sexuality"];
            
        }
        //[self.viewModel.didSelectedCommand execute:indexPath];
    
    }
   // [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

/** 修改个人信息 */
- (void)userInfoEditUserInfoEvent:(NSString *)infoItem
{
    coverView.hidden = NO;
    if ([infoItem isEqualToString:@"birthday"]) {
        if (pickerView)  {
            [pickerView closePickerViewShow];
        }
        pickerView = [[LocatePickerView alloc]initWithType:PickerTypeBirthday delegate:self];
        //    if (self.viewModel.birthday.length==0) {
        ////        pickerView.birthdayStr =
        //    }
        pickerView.birthdayStr = self.viewModel.birthday;
        [pickerView showInView:self.view];
    }
    else if([infoItem isEqualToString:@"sexuality"]){
        if (pickerView)  {
            [pickerView closePickerViewShow];
        }
        pickerView = [[LocatePickerView alloc]initWithType:PickerTypeSex delegate:self];
        pickerView.sexStr = self.viewModel.sexuality;
        [pickerView showInView:self.view];
    }
   // else if([infoItem isEqualToString:@"name"])
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
  //  CGFloat Y = DEVICE_IS_IPHONE5?80:50;
//    VPImageCropperViewController *VC = [[VPImageCropperViewController alloc] initWithImage:portraitImg
//                                                                                 cropFrame:CGRectMake(0, Y, kWidth, kWidth)
//                                                                           limitScaleRatio:3.0];
//    VC.parent = self;
//    [self.navigationController pushViewController:VC animated:YES];
    [self.viewModel.cropImageCommand execute:portraitImg];
}



#pragma mark --UIButton

-(void)save{
    if ([userNameTextField isFirstResponder]) {
        [userNameTextField resignFirstResponder];
    }
    User *user = [User getUserFromDB];
    if (!([user.name isEqualToString:self.viewModel.userName]&&[user.sex isEqualToString:self.viewModel.sexuality]&&[user.birthday isEqualToString:self.viewModel.birthday])) {
        [self.viewModel.saveCommand execute:nil];
    }
    

}

#pragma mark -- locatePickerViewDelegate

-(void)selectByType:(PickerType)type andTitle:(NSString *)content inRow:(int)row
{
    
}

-(void)selectByType:(PickerType)type andTitle:(NSString *)content
{
    
    //   self.birthTextField.text = [NSString stringWithFormat:@"%lu",(unsigned long)[Utility compareHoursWithDate:content]];//将出生日期转换成年龄
    if (type ==PickerTypeBirthday) {
            self.viewModel.birthday =content;
    }
    else if(type ==PickerTypeSex){
        self.viewModel.sexuality = content;
    }
    [self.userInfoTableView reloadData];
}

-(void)finishSelected:(PickerType)type
{
    coverView.hidden = YES;
    CGRect frame = pickerView.frame;
    frame.origin.y = self.view.frame.size.height;
    [UIView animateWithDuration:0.3
                     animations:^{
                         pickerView.frame = frame;
                     }];
}

#pragma mark --UItextfield delegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.viewModel.userName = textField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == userNameTextField) {
        [textField resignFirstResponder];
    }
    return  YES;
}

@end
