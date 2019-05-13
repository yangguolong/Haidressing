//
//  YZMMeViewCtrlView.m
//  Hairdressing
//
//  Created by 杨国龙 on 16/3/4.
//  Copyright © 2016年 Cloudream. All rights reserved.
//

#import "MeViewController.h"
#import "TGRImageViewController.h"
#import "TGRImageZoomAnimationController.h"
#import "UserInfoViewController.h"
#import "SettingViewController.h"
//#import "MeTableViewCell.h"

@interface MeViewController ()

@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    moreFunctionListArray = [NSArray arrayWithObjects:@"我的优惠券",@"我的收藏",@"分享给好友",@"设置", nil];
    meTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64) style:UITableViewStyleGrouped];
 //   meTableView.contentSize = CGSizeMake(0, kHeight+590);
    meTableView.userInteractionEnabled = YES;
    meTableView.bounces = YES;
    meTableView.dataSource = self   ;
    meTableView.delegate = self;
    meTableView.separatorInset = UIEdgeInsetsZero;
    meTableView.tableFooterView = [UIView new];
    [self.view addSubview:meTableView];
}


#pragma mark --UITableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 10;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section != 2) {
        return 1;
    }
    return moreFunctionListArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 100  ;
    }
    else if(indexPath.section == 1){
        return 120   ;
    }
    return 44;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static  NSString *ID = @"MeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.section == 0) {
            //头像 cell
            userPortrait = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth/2-35, 10, 70, 70)];
            userPortrait.backgroundColor = [UIColor clearColor];
            userPortrait.contentMode = UIViewContentModeScaleAspectFill;
            userPortrait.layer.borderColor = [[UIColor whiteColor] CGColor];
            userPortrait.layer.borderWidth = 2;
            userPortrait.layer.cornerRadius = 35;
            userPortrait.layer.masksToBounds = YES;
            userPortrait.userInteractionEnabled = YES;
            userPortrait.image = [UIImage imageNamed:@"default_head"];
            [cell.contentView addSubview:userPortrait];
            UITapGestureRecognizer *protraitTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(portraitTapAction)];
            [userPortrait addGestureRecognizer:protraitTap];
            
            UILabel *nickNameLab = [[UILabel alloc] initWithFrame:CGRectMake(kWidth/2-20, userPortrait.frame.origin.y+70, 40, 20)];
            nickNameLab.text = @"用户昵称";
            [nickNameLab setFont:[UIFont systemFontOfSize:9.0]];
            [cell.contentView addSubview:nickNameLab];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else if(indexPath.section == 1){
            //我的订单cell
            
            UILabel *leftNoteLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 70, 20)];
            leftNoteLabel.text = @"我的订单";
            [leftNoteLabel setFont:[UIFont systemFontOfSize:13.0]];
            leftNoteLabel.textColor = [UIColor lightGrayColor];
            leftNoteLabel.textAlignment=NSTextAlignmentCenter;
            leftNoteLabel.backgroundColor = [UIColor whiteColor];
            [cell.contentView addSubview:leftNoteLabel];
            
            UILabel *rightNoteLabel = [[UILabel alloc]initWithFrame:CGRectMake(kWidth-5-70, 5, 70, 20)];
            rightNoteLabel.text = @"查看全部";
            [rightNoteLabel setFont:[UIFont systemFontOfSize:13.0]];
            rightNoteLabel.textColor = [UIColor lightGrayColor];
            rightNoteLabel.textAlignment=NSTextAlignmentCenter;
            rightNoteLabel.backgroundColor = [UIColor whiteColor];
            [cell.contentView addSubview:rightNoteLabel];
            
            UIView *noPayView = [[UIView alloc]initWithFrame:CGRectMake(kWidth/2-40, 120-10-80, 80, 80)];
            UIImageView *noPayImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 60, 60)];
            noPayImageView.image = [UIImage imageNamed:@"other_more_other_evenmore"];
            UILabel *noPayLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, 80, 20)];
            noPayLabel.text = @"未付款";
            noPayLabel.textAlignment = NSTextAlignmentCenter;
            [noPayLabel setFont:[UIFont systemFontOfSize:15.0]];
            [noPayView addSubview:noPayImageView];
            [noPayView addSubview:noPayLabel];
            [cell.contentView addSubview:noPayView];
            UITapGestureRecognizer *noPayTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(noPayTapAction)];
            [noPayView addGestureRecognizer:noPayTap];
            
            UIView *paidView = [[UIView alloc]initWithFrame:CGRectMake(40, 120-10-80, 80, 80)];
            UIImageView *paidImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 60, 60)];
            paidImageView.image = [UIImage imageNamed:@"other_more_other_feedback"];
            UILabel *paidLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, 80, 20)];
            paidLabel.text = @"已付款";
            paidLabel.textAlignment = NSTextAlignmentCenter;
            [paidLabel setFont:[UIFont systemFontOfSize:15.0]];
            [paidView addSubview:paidImageView];
            [paidView addSubview:paidLabel];
            [cell.contentView addSubview:paidView];
            UITapGestureRecognizer *paidTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(paidTapAction)];
            [paidView addGestureRecognizer:paidTap];
            
            UIView *usedView = [[UIView alloc]initWithFrame:CGRectMake(kWidth-40-80, 120-10-80, 80, 80)];
            UIImageView *usedImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 60, 60)];
            usedImageView.image = [UIImage imageNamed:@"other_more_other_more"];
            UILabel *usedLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, 80, 20)];
            usedLabel.text = @"已消费";
            usedLabel.textAlignment = NSTextAlignmentCenter;
            [usedLabel setFont:[UIFont systemFontOfSize:15.0]];
            [usedView addSubview:usedImageView];
            [usedView addSubview:usedLabel];
            [cell.contentView addSubview:usedView];
            UITapGestureRecognizer *usedTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(usedTapAction)];
            [usedView addGestureRecognizer:usedTap];
        }
        else if(indexPath.section == 2){
            //更多功能列表cell
            cell.textLabel.text = [moreFunctionListArray objectAtIndex:indexPath.row];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }

    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    NSLog(@"select indexPath:%@",indexPath);
    if (indexPath.section == 0) {
        if (indexPath.row==0) {
            UserInfoViewController *userInfoVC = [[UserInfoViewController alloc]init];
            [self.navigationController pushViewController:userInfoVC animated:YES];
        }
    }
    else if(indexPath.section == 2){
        SettingViewController *settingViewController = [[SettingViewController alloc]init];
        [self.navigationController pushViewController:settingViewController animated:YES];
    }
}

#pragma mark --tap action
-(void)noPayTapAction{
    NSLog(@"noPayTapAction");
}
-(void)paidTapAction{

    NSLog(@"paidTapAction");
}

-(void)usedTapAction{
      NSLog(@"usedTapAction");
}


-(void)portraitTapAction{
    TGRImageViewController *viewController = [[TGRImageViewController alloc] initWithImage:userPortrait.image];
    viewController.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    viewController.transitioningDelegate = self;
    [self presentViewController:viewController animated:YES completion:NULL];
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    if ([presented isKindOfClass:TGRImageViewController.class]) {
        return [[TGRImageZoomAnimationController alloc] initWithReferenceImageView:userPortrait];
    }
    return nil;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    if ([dismissed isKindOfClass:TGRImageViewController.class]) {
        return [[TGRImageZoomAnimationController alloc] initWithReferenceImageView:userPortrait];
    }
    return nil;
}

@end
