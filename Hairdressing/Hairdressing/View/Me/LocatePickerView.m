//
//  LocatePickerView.m
//  110terminal
//
//  Created by Careers on 15-1-15.
//  Copyright (c) 2015年 Careers. All rights reserved.
//

#import <QuartzCore/CALayer.h>
#import "LocatePickerView.h"
//#import "UserService.h"
//#import "User.h"

#define kDuration 0.3

@implementation LocatePickerView

- (id)initWithType:(PickerType)pickerType delegate:(id<LocatePickerViewDelegate>)delegate
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"LocatePickerView" owner:self options:nil] objectAtIndex:0];
    if (self)
    {
        locatePickerView.delegate = self;
        locatePickerView.dataSource = self;
        parent = delegate;
        type = pickerType;
        switch (type)
        {
            case PickerTypeBirthday:
            {
                [locatePickerView removeFromSuperview];
                UIDatePicker *dataPicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, kWidth, 216)];
                dataPicker.datePickerMode = UIDatePickerModeDate;
                dataPicker.maximumDate = [NSDate date];
                dataPicker.backgroundColor = [UIColor clearColor];
                [dataPicker setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
                [dataPicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
                [self addSubview:dataPicker];
                
                break;
            }
            case PickerTypeSex:
            {
//                [self loadDuty:self.currIndex];
    
                [locatePickerView selectRow:self.currSexIndex inComponent:0 animated:YES];
                break;
            }
            case PickerTypeTime:
            case PickerTypeTimeDetail:
            {
                [locatePickerView removeFromSuperview];
                self.dataPicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, kWidth, 216)];
                self.dataPicker.backgroundColor = [UIColor clearColor];
                [self.dataPicker setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
                [self.dataPicker addTarget:self action:@selector(dateChanged_Time:) forControlEvents:UIControlEventValueChanged];
                [self addSubview:self.dataPicker];
                [self.dataPicker setDate:[NSDate date] animated:NO];
                break;
            }
            default:
                break;
        }
    }
    return self;
}


-(void)loadDuty
{
    if ([self.sexStr isEqualToString:@"男"]) {
        [locatePickerView selectRow:0 inComponent:0 animated:YES];
    }
    else
         [locatePickerView selectRow:1 inComponent:0 animated:YES];
    
}

-(void)dateChanged:(id)sender
{
    UIDatePicker *dp = (UIDatePicker *)sender;
    [dp setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSString *theTime = [NSString stringWithFormat:@"%@",[dp date]];
    [parent selectByType:type andTitle:[theTime substringToIndex:10]];
}

-(void)dateChanged_Time:(id)sender
{
    UIDatePicker *dp = (UIDatePicker *)sender;
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString * theTime = [dateformatter stringFromDate:[dp date]];
    [parent selectByType:type andTitle:theTime];
}

- (void)showInView:(UIView *)view
{
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromTop;
    [self setAlpha:1.0f];
    [self.layer addAnimation:animation forKey:@"LocatePickerView"];
    
    self.frame = CGRectMake(0, view.frame.size.height - self.frame.size.height, kWidth, self.frame.size.height);
    [view addSubview:self];
}


#pragma mark - PickerView lifecycle
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger num = 0;
    if(type == PickerTypeSex) {
        num = 2;
    }
    return num;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = @"";
    switch (type)
    {
        case PickerTypeSex:
        {
            title = (row == 0)?@"男":@"女";
            break;
        }
        default:
            break;
    }
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (type)
    {
        case PickerTypeSex:
        {
            [parent selectByType:type andTitle:row?@"女":@"男"];
            break;
        }
        default:
            break;
    }
}

#pragma mark - Button lifecycle
- (IBAction)cancel:(id)sender
{
    //px 添加 点击取消的时候 性别、生日以及所在地 都保留以前的值
    if(type == PickerTypeSex)
        [parent selectByType:type andTitle:_sexStr];
    if(type == PickerTypeBirthday)
        [parent selectByType:type andTitle:_birthdayStr];
    if(type == PickerTypeTime)
        [parent selectByType:type andTitle:_timeStr];
    
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromBottom;
    [self setAlpha:0.0f];
    [self.layer addAnimation:animation forKey:@"LocatePickerView"];
    [parent finishSelected:type];
}

- (IBAction)finish:(id)sender
{
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromBottom;
    [self setAlpha:0.0f];
    [self.layer addAnimation:animation forKey:@"LocatePickerView"];
    [parent finishSelected:type];
}

- (void)closePickerViewShow
{
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromBottom;
    [self setAlpha:0.0f];
    [self.layer addAnimation:animation forKey:@"LocatePickerView"];
}
@end
