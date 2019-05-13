//
//  SettingViewController.m
//  Hairdressing
//
//  Created by BoDong on 16/3/29.
//  Copyright © 2016年 Cloudream. All rights reserved.
//

#import "SettingViewController.h"
#import "LoginViewController.h"
@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    settingListArray = [NSArray arrayWithObjects:@"版权说明",@"意见反馈", nil];
    settingTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64) style:UITableViewStyleGrouped];
    //   meTableView.contentSize = CGSizeMake(0, kHeight+590);
    settingTableView.userInteractionEnabled = YES;
    settingTableView.bounces = YES;
    settingTableView.dataSource = self   ;
    settingTableView.delegate = self;
    settingTableView.separatorInset = UIEdgeInsetsZero;
    settingTableView.tableFooterView = [UIView new];
    [self.view addSubview:settingTableView];
}

#pragma mark --UITableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return 1;
    }
    return settingListArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 44;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    UITableViewCell *cell;
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.section == 0) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = [settingListArray objectAtIndex:indexPath.row];
        }
        else if(indexPath.section == 1){
            UIButton *logoutButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kWidth, 44)];
            [logoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
            [logoutButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [logoutButton addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:logoutButton];
        }

    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    NSLog(@"select indexPath:%@",indexPath);
    if (indexPath.section == 0) {

    }
    else if(indexPath.section == 1){
        SettingViewController *settingViewController = [[SettingViewController alloc]init];
        [self.navigationController pushViewController:settingViewController animated:YES];
    }
}



-(void)logout{
    LoginViewController *loginViewCtrl = [[LoginViewController alloc]init];
    [self presentViewController:loginViewCtrl animated:NO completion:nil];
    
}


@end
