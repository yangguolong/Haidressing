//
//  LocatePickerView.h
//  110terminal
//
//  Created by Careers on 15-1-15.
//  Copyright (c) 2015年 Careers. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    PickerTypeNormal = 0,
    PickerTypeSex,
    PickerTypeBirthday,
    PickerTypeTime,
    PickerTypeTimeDetail//年月日 时分
} PickerType;

@protocol LocatePickerViewDelegate <NSObject>

@optional
-(void)selectByType:(PickerType)type andTitle:(NSString *)content;
-(void)selectByType:(PickerType)type andTitle:(NSString *)content inRow:(int)row;
-(void)finishSelected:(PickerType)type;

@end

@interface LocatePickerView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>
{
    PickerType type;
  //  int currIndex;
    NSArray * sexArray;
    NSArray * dutyArray;
    NSArray * leaveArray;         //请假类型

    IBOutlet UIPickerView *locatePickerView;
    IBOutlet UIView *topView;
    id<LocatePickerViewDelegate> parent;
}
@property(nonatomic,assign)  int currSexIndex;
@property(nonatomic,strong) UIDatePicker *dataPicker;

-(void)loadDuty;
- (IBAction)cancel:(id)sender;

- (id)initWithType:(PickerType)pickerType delegate:(id<LocatePickerViewDelegate>)delegate;
- (void)showInView:(UIView *)view;

- (void)closePickerViewShow;                       //关闭UIPickerView弹出
@property (nonatomic,copy)NSString *sexStr;        //保留性别字符串
@property (nonatomic,copy)NSString *birthdayStr;   //保留生日字符串
@property (nonatomic,copy)NSString *dutyStr;       //保留职务字符串
@property (nonatomic,copy)NSString *leaveStr;       //保留请假类型字符串
@property (nonatomic,copy)NSString *timeStr;       //保留时间字符串

@end
