//
//  SettingViewController.m
//  Hairdressing
//
//  Created by Guolong Yang on 16/3/29.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "SettingViewController.h"
#import "LoginViewController.h"
#import "FeedBackViewModel.h"
@interface SettingViewController ()
@property (nonatomic, strong, readwrite) SettingViewModel *viewModel;
@property (strong, nonatomic) UITableView *settingTableView;
@property(nonatomic,strong)UIButton *button;
@end

@implementation SettingViewController

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];

    settingListArray = [NSArray arrayWithObjects:@"版权说明", nil];
    self.settingTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64) style:UITableViewStyleGrouped];
    self.settingTableView.userInteractionEnabled = YES;
    self.settingTableView.bounces = YES;
    self.settingTableView.dataSource = self;
    self.settingTableView.delegate = self;
    self.settingTableView.separatorInset = UIEdgeInsetsZero;
    self.button = [[UIButton alloc]initWithFrame:CGRectMake(30, (44-40)/2, kWidth-60, 40)];
    self.button.backgroundColor = [UIColor colorWithRed:195/255.0 green:52/255.0 blue:41/255.0 alpha:1.0];
    [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (![[NSUserDefaults standardUserDefaults]boolForKey:ISLOGIN]) {
        [self.button setTitle:@"登 录" forState:UIControlStateNormal];
    }
    else
        [self.button setTitle:@"退出登录" forState:UIControlStateNormal];
    
    self.button.layer.cornerRadius = 20;
    self.button.userInteractionEnabled = YES;
    //button.layer.masksToBounds = YES;
    self.button.clipsToBounds = YES;
    [self.button addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 44)];
    [footerView addSubview:self.button];
    footerView.backgroundColor = [UIColor clearColor];
    self.settingTableView.tableFooterView = footerView;
    
    [self.view addSubview:self.settingTableView];
    @weakify(self)
    [[[[NSNotificationCenter defaultCenter]
       rac_addObserverForName:UserInfoChangeNotification object:nil]
      takeUntil:self.rac_willDeallocSignal]
     subscribeNext:^(NSNotification *notification) {
         @strongify(self)
         if (![[NSUserDefaults standardUserDefaults]boolForKey:ISLOGIN]) {
             [self.button setTitle:@"登 录" forState:UIControlStateNormal];
         }
         else
             [self.button setTitle:@"退出登录" forState:UIControlStateNormal];
     }];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 50;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

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

    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    NSLog(@"select indexPath:%@",indexPath);
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self.viewModel.didSelectCommand execute:nil];
        }
    }

}

-(void)loginAction{
    if ([[NSUserDefaults standardUserDefaults]boolForKey:ISLOGIN])
    {
        NSString *message = @"退出后不会删除任何数据，下次登录依然可以使用本帐号。";
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                                 message:message
                                                                          preferredStyle:UIAlertControllerStyleActionSheet];
        @weakify(self)
        [alertController addAction:[UIAlertAction actionWithTitle:@"退出登录" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            @strongify(self)
            [self.viewModel.logoutCommand execute:nil];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:NULL]];
        [self presentViewController:alertController animated:YES completion:NULL];
    }
    else{
        [self.viewModel.logoutCommand execute:nil];
        
    }

}

@end