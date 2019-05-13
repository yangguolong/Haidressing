//
//  EditUerInfoViewController.m
//  ismarter2.0_sz
//
//  Created by zx_03 on 15/4/15.
//
//

#import "AllUserInfoEditViewController.h"
#import "UserViewModel.h"
#import "User.h"
//#import "InteractWithServer.h"
#import "Utility.h"
#import "UserService.h"
//#import "User.h"

@interface AllUserInfoEditViewController ()

@end

@implementation AllUserInfoEditViewController
//@synthesize curUser;
@synthesize orgStr;


- (void)viewDidLoad
{
    [super viewDidLoad];
    @weakify(self)
    UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 6, 50, 25)];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [saveBtn addTarget:self action:@selector(saveClicked) forControlEvents:UIControlEventTouchUpInside];
//    [[saveBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *saveButton) {
//        @strongify(self)
//        [self saveClicked];
//    }];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:saveBtn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,barItem, nil];

    
    /*加载个人信息*/
    
    UITextField *inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 20, kWidth, 40)];
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 40)];
    inputTextField.leftViewMode = UITextFieldViewModeAlways;
    inputTextField.leftView = leftView;
    inputTextField.font = [UIFont systemFontOfSize:16.0];
    inputTextField.textColor = [UIColor blackColor];
    inputTextField.backgroundColor = [UIColor whiteColor];
    inputTextField.returnKeyType = UIReturnKeyDone;
    inputTextField.enablesReturnKeyAutomatically = YES;
    inputTextField.delegate = self;
    inputTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    //name,sexuality,birthday,phone,profile
    if ([self.userEditItem  isEqualToString: @"name"])
    {
        self.title = @"昵称";
        inputTextField.text =self.userInfoViewModel.name;
        inputTextField.userInteractionEnabled = YES;
        nameTextField = inputTextField ;
        [nameTextField becomeFirstResponder];
    }
    else if ([self.userEditItem  isEqualToString: @"sexuality"])
    {
        self.title = @"性别";
        inputTextField.text = self.userInfoViewModel.sexuality;
        sexTextField= inputTextField ;
        [sexTextField becomeFirstResponder];
    }
    else if ([self.userEditItem  isEqualToString: @"birthday"]){
        self.title = @"生日";
        if (self.userInfoViewModel.birthday == nil)
        {
            int Timestamp = [Utility getCurrentTimestamp];
            NSString *currentTime = [Utility getDateByTimestamp:Timestamp type:0];
            inputTextField.text = currentTime;
        }
        else{
            inputTextField.text = self.userInfoViewModel.birthday;
        }
        birthdayTextField = inputTextField;
        [birthdayTextField becomeFirstResponder];
        
    }
    else if ([self.userEditItem  isEqualToString: @"phone"])
    {
        self.title = @"电话";
        inputTextField.text =  self.userInfoViewModel.account;
        phoneTextField =  inputTextField;
        [phoneTextField becomeFirstResponder];
    }

    editTableView.backgroundColor = [UIColor clearColor];
    editTableView.frame = CGRectMake(0, 0, kWidth, kHeight-64);
    [editTableView addSubview:inputTextField];
    changeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeUserInfoKeyBoard)];
    [editTableView addGestureRecognizer:changeTap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userInfoKeyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userInfoKeyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                                object:nil];

}


-(void)viewDidAppear:(BOOL)animated
{
    if(orgStr.length>0)
    {
        orgNameTextField.text = orgStr;
    }
}
//ZY 1210
- (void)viewDidDisappear:(BOOL)animated
{
    [editTableView removeGestureRecognizer:changeTap];
}

-(UserViewModel*)userInfoViewModel{
    if (!_userInfoViewModel) {
        _userInfoViewModel   = [[UserViewModel alloc]init];
        
    }
    return _userInfoViewModel;
}

#pragma mark  - Responding to keyboard events
- (void)userInfoKeyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [self userInfoAutoMovekeyBoard:keyboardRect.size.height];
}

- (void)userInfoKeyboardWillHide:(NSNotification *)notification
{
    NSDictionary* userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [self userInfoAutoMovekeyBoard:0];
}


-(void)userInfoAutoMovekeyBoard:(float)h
{
    if (!isShow) {
        return;
    }
//    CGRect frame = editTableView.frame;
//    frame.origin.y = h?-h:0;
//    [UIView animateWithDuration:0.3
//                     animations:^{
//                         editTableView.frame = frame;
//                     }];
}

#pragma mark - 导航栏左右键
-(void)saveClicked
{
    [currentTextField resignFirstResponder];

    if(nameTextField.text.length)
    {
        //判断名字是否含有非法字符
        if ([Utility isHaveIllegalChar:nameTextField.text] || [[nameTextField.text substringToIndex:1] isEqualToString:@"_"] || [[nameTextField.text substringFrom:(nameTextField.text.length-1) to:(nameTextField.text.length )] isEqualToString:@"_"]) {
            UIAlertView *alert  = [[UIAlertView alloc]initWithTitle:nil
                                                            message:@"昵称只能含有汉字、数字、字母、下划线，并且不能以下划线开头和结尾"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];

            return;
        }
    }
    User *curUser = [User getUserFromDB];
    NSMutableDictionary *updateDic = [[NSMutableDictionary alloc] init];
    [updateDic setObject:[NSString stringWithFormat:@"%@",curUser.account] forKey:@"account"];
    NSString *result = @"";
    if ([self.userEditItem  isEqualToString: @"name"])
    {
        if(![nameTextField.text isEqualToString:curUser.name])
        {
            isChangeName = YES;
        }
        result = [nameTextField.text length]?nameTextField.text:@"";
        [updateDic setObject:result forKey:@"name"];
        [updateDic setObject:[NSString stringWithFormat:@"%@",curUser.sexuality] forKey:@"sexuality"];
      //  [updateDic setObject:[NSString stringWithFormat:@"%@",[Utility getDateByTimestamp:curUser.birthday type:0]] forKey:@"birthday"];
        [updateDic setObject:[NSString stringWithFormat:@"%@",curUser.account] forKey:@"account"];
    }
    else if ([self.userEditItem  isEqualToString: @"sexuality"])
    {
        if(![sexTextField.text isEqualToString:curUser.sexuality])
        {
            isChangeSex = YES;
        }
        result = [sexTextField.text length]?sexTextField.text:@"";
        [updateDic setObject:result forKey:@"sexuality"];
        [updateDic setObject:[NSString stringWithFormat:@"%@",curUser.name] forKey:@"name"];
       // [updateDic setObject:[NSString stringWithFormat:@"%@",[Utility getDateByTimestamp:curUser.birthday type:0]] forKey:@"birthday"];
        [updateDic setObject:[NSString stringWithFormat:@"%@",curUser.account] forKey:@"account"];
        
    }
    else if ([self.userEditItem  isEqualToString: @"birthday"])
    {
        if(![birthdayTextField.text isEqualToString:curUser.birthday])
        {
            isChangeBirthday = YES;
        }
//        [updateDic setObject:birthdayTextField.text forKey:@"birthday"];
//        [updateDic setObject:[NSString stringWithFormat:@"%@",curUser.account] forKey:@"account"];
//        [updateDic setObject:[NSString stringWithFormat:@"%@",curUser.name] forKey:@"name"];
//        [updateDic setObject:[NSString stringWithFormat:@"%@",curUser.sex] forKey:@"sex"];
    }

    if (!isChangeName && !isChangeSex && !isChangeBirthday ) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    if (isChangeName) {
        curUser.name = [NSString stringWithFormat:@"%@",nameTextField.text];
    }
    if (isChangeSex) {
        curUser.sexuality = [NSString stringWithFormat:@"%@",sexTextField.text];
    }
    if (isChangeBirthday) {
        curUser.birthday = birthdayTextField.text;
    }
    if (isChangePhone) {
        curUser.account = [NSString stringWithFormat:@"%@",phoneTextField.text];
    }
    [curUser saveOrUpdate]; //更新本地数据
    if (_updateBlock) {
        _updateBlock([User getUserFromDB]);
    }
    [self.navigationController popViewControllerAnimated:YES];
//    [MBProgressHUD showHUD:@"修改信息中" isDim:NO];

//    //上传服务器
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        NSDictionary *resultDic = [[InteractWithServer sharedInstance] uploadPersonalInfo:updateDic];
//        BOOL isSuccess = NO;
//        if (resultDic != nil && [@"200" isEqualToString:[resultDic objectForKey:@"status"]]) {
//            if (isChangeName) {
//                curUser.name = [NSString stringWithFormat:@"%@",nameTextField.text];
//            }
//            if (isChangeSex) {
//                curUser.sex = [NSString stringWithFormat:@"%@",sexTextField.text];
//            }
//            if (isChangeBirthday) {
//                curUser.birthday = (int)[Utility timestampToDate:birthdayTextField.text type:6];
//            }
//            if (isChangeOrgName) {
//                curUser.orgName = [NSString stringWithFormat:@"%@",orgNameTextField.text];
//            }
//            if (isChangeDuty) {
//                curUser.duty = [NSString stringWithFormat:@"%@",dutyTextField.text];
//            }
//            if (isChangeDescn) {
//                curUser.descn = [NSString stringWithFormat:@"%@",descnTextView.text];
//            }
//            if (isChangePhone) {
//                curUser.mobilePhone = [NSString stringWithFormat:@"%@",phoneTextField.text];
//            }
//            [curUser saveOrUpdate]; //更新本地数据
//            [UserService resetMySelf];
//            isSuccess = YES;
//        }
//        //回到主线程
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self hideHUD];
//            
//            NSString *message = @"更新失败";
//            NSInteger ALERT_TAG = 501;
//            if (isSuccess) {
//                message = @"更新成功";
//                ALERT_TAG = 500;
//            }
//            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
//            alert.tag = ALERT_TAG;
//            [self performSelector:@selector(showAlertView:) withObject:alert afterDelay:0.5];
//            
//        });
//    });
    
}

- (void)showAlertView:(UIAlertView *)alert
{
    [alert show];
    [self performSelector:@selector(dimissAlert:) withObject:alert afterDelay:1.5f];
}

- (void)dimissAlert:(UIAlertView *)alert
{
//    if(alert && 500 == alert.tag)     {
//        [UserService resetMySelf];
//        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
//        [alert release];
//        if (_updateBlock) {
//            _updateBlock([UserService getUserFromDB]);
//        }
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//    if(alert && 501 == alert.tag)
//    {
//        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
//        [alert release];
//    }
}

-(void)removeUserInfoKeyBoard
{
    if ([currentTextField isFirstResponder]) {
        [currentTextField resignFirstResponder];
    }
    //ZY 1210
    if ([descnTextView isFirstResponder]) {
        [descnTextView resignFirstResponder];
    }
//    [editTableView removeGestureRecognizer:changeTap];
}

#pragma mark - textField delegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
        [self saveClicked];
        return NO;
    }
    if (textField == nameTextField) {
        if([textField.text length]>10) {
            textField.text = [textField.text substringToIndex:10];
        }
    }
    if (textField == phoneTextField) {
        if([textField.text length]>15) {
            textField.text = [textField.text substringToIndex:15];
        }
    }
    return YES;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([self.userEditItem  isEqualToString: @"sexuality"] || [self.userEditItem  isEqualToString: @"birthday"]){
        if (pickerView)  {
            [pickerView closePickerViewShow];
        }
        PickerType type;
        
        if([self.userEditItem  isEqualToString: @"sexuality"])
        {
            type = PickerTypeSex;
            if([sexTextField.text isEqualToString:@""] || [sexTextField.text length]==0) {
                sexTextField.text = @"男";
            }
        } else if([self.userEditItem  isEqualToString: @"birthday"]) {
            type = PickerTypeBirthday;
        } else {
            type = PickerTypeNormal;
        }
        pickerView = [[LocatePickerView alloc]initWithType:type delegate:self];
        if([self.userEditItem  isEqualToString: @"sexuality"]) {
            pickerView.sexStr = sexTextField.text;
        } else if([self.userEditItem  isEqualToString: @"birthday"]) {
            //保存当前的生日
            pickerView.birthdayStr = birthdayTextField.text;
        } else {
            type = PickerTypeNormal;
        }
        [pickerView showInView:self.view];
        return NO;
    }
    else
        return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    isShow = NO;
    if (textField == phoneTextField) {
        phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    [editTableView addGestureRecognizer:changeTap];
    currentTextField = textField;
    [textField becomeFirstResponder];
    if (textField == nameTextField) {
        if(textField.text.length >= 10)  {
            nameTextField.text = [textField.text substringToIndex:10];
        }
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    isShow = YES;
    if (textField == nameTextField) {
        if(textField.text.length >= 10) {
            nameTextField.text = [textField.text substringToIndex:10];
        }
    }
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    isShow = YES;
    if(pickerView) {
        [pickerView closePickerViewShow];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *string = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if ([textView.text isEqualToString:@"\n"] && [textView.text length] == 1)
    {
        textView.text = nil;
        return NO;
    }
    if ([text isEqualToString:@"\n"] && [string length] != 1)
    {
        [self saveClicked];
        return NO;
    }
    if ([string length] < 31) {
        overLab.text = [NSString stringWithFormat:@"%d",30-(int)[string length]];
        return YES;
    }
    else
    {
        textView.text = [string substringToIndex:30];
        overLab.text = [NSString stringWithFormat:@"0"];
        return NO;
    }
    return YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    //禁止系统表情
  //  [textView setText:[EmojiUnicode disable_emoji:[textView text]]];
}

//防止智能联想模式导致文字越界-
-(void)textViewDidChange:(UITextView *)textView
{
    if([textView.text length]<31) {
        overLab.text = [NSString stringWithFormat:@"%d",30-(int)[textView.text length]];
    }else {
        textView.text = [textView.text substringToIndex:30];
    }
}


#pragma mark -- locatePickerViewDelegate
//@required ZY 1210
-(void)selectByType:(PickerType)type andTitle:(NSString *)content inRow:(int)row
{
    
}

-(void)selectByType:(PickerType)type andTitle:(NSString *)content
{
    switch (type)
    {
        case PickerTypeSex:
        {
            sexTextField.text = content;
            break;
        }
        case PickerTypeBirthday:
        {
            birthdayTextField.text = content;
            break;
        }
        default:
            break;
    }
}

-(void)finishSelected:(PickerType)type
{
    if ((type!=PickerTypeSex)&& !DEVICE_IS_IPHONE5)
    {
        CGRect frame = editTableView.frame;
        frame.origin.y = 0;
        [UIView animateWithDuration:0.3
                         animations:^{
                             editTableView.frame = frame;
                         }];
    }
}


@end

