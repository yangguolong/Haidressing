//
//  EditUerInfoViewController.h
//  ismarter2.0_sz
//
//  Created by zx_03 on 15/4/15.
//
//

#import <UIKit/UIKit.h>
#import "LocatePickerView.h"
#import "UserViewModel.h"
//#import "User.h"
//#import "UserService.h"
//#import "BaseViewController.h"

typedef void(^userInfoUpdateBlock)(User *userInfoModel);

@interface AllUserInfoEditViewController : MRCViewController<UITextFieldDelegate,UITextViewDelegate,LocatePickerViewDelegate>
{
    IBOutlet UIView *editTableView;
    UITextField *accountTextField;
    UITextField *nameTextField;
    UITextField *sexTextField;
    UITextField *birthdayTextField;
    UITextField *orgNameTextField;
    UITextField *dutyTextField;
    UITextField *phoneTextField;
    
    UITextView  *descnTextView;
    UILabel     *overLab;                            //剩余字数提示
    
    UITextField *currentTextField;
    
    BOOL isChangeName;
    BOOL isChangeSex;
    BOOL isChangeBirthday;
    BOOL isChangeOrgName;
    BOOL isChangeDuty;
    BOOL isChangeDescn;
    BOOL isChangePhone;
    
    BOOL isShow;
    
    NSString * orgStr;
//    User *curUser;
    NSMutableArray *reserveArray;
    LocatePickerView *pickerView;
    UITapGestureRecognizer *changeTap;
    
    
}
@property(strong,nonatomic)NSString *userEditItem;
//@property (nonatomic,retain) User * curUser;
@property(nonatomic,strong)UserViewModel *userInfoViewModel;
@property (nonatomic,copy) NSString * orgStr;

@property (nonatomic, copy)     userInfoUpdateBlock        updateBlock;

@end

