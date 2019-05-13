//
//  YZMCommentViewController.m
//  Hairdressing
//
//  Created by Guolong Yang on 16/4/21.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "YZMCommentViewController.h"
#import "StudioComment.h"
#import "YZMCommentViewModel.h"
#import "AllCommentCell.h"
@interface YZMCommentViewController ()
@property(nonatomic,strong)YZMCommentViewModel *viewModel;

@property (weak, nonatomic) IBOutlet UILabel *commentCountLab;
@end

@implementation YZMCommentViewController
@dynamic viewModel;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor greenColor];
     [self.tableView registerNib:[UINib nibWithNibName:@"AllCommentCell" bundle:nil] forCellReuseIdentifier:@"AllCommentCell"];
    @weakify(self)
    [RACObserve(self.viewModel, commentCount) subscribeNext:^(id x) {
        self.commentCountLab.text = [NSString stringWithFormat:@"共有%ld条评论",(long)self.viewModel.commentCount];
    }];
    [self.viewModel.requestRemoteDataCommand.executing subscribeNext:^(NSNumber *executing) {
        @strongify(self)
        if (executing.boolValue) {
            //            if (self.viewModel.dataSource.count !=0)
            [MBProgressHUD showHUDAddedTo:self.view animated:YES].labelText = MBPROGRESSHUD_LABEL_TEXT;
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];
}


//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    
//}
//-(void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:NO];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
//    
//}


-(void)bindViewModel{
    [super bindViewModel];
    
    // @weakify(self)
    //    RAC(self.buyerCountLab,text) = [RACObserve(self.viewModel, buyerCount) map:^id(NSNumber *count) {
    //        return [NSString stringWithFormat:@"%@",count];
    //    }];
    
    
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    //    if (section==1) {
    //        return 0;
    //    }
    return [AllCommentCell heightOfCellWithModel:self.viewModel.dataSource[indexPath.section][indexPath.row]];
    
}
//- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    if (section == 0) {
//        return [StudioDetailHeaderView initHeaderView];
//    }
//    return nil;
//}
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//
//    return 1;
//}
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (section != 0) {
//        return 0;
//    }
//    return 1;//返回服务项目总数
//}
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return self.viewModel.dataSource.count;
//}
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    
//    return [self.viewModel.dataSource[section] count];
//    
//}

- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:@"AllCommentCell" forIndexPath:indexPath];
    
}


- (void)configureCell:(AllCommentCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(YZMCommentViewModel *)viewModel {
    //    if (indexPath.section == 0 && indexPath.row == 0)
    //    {
    //        //cell.serviceDetailLab.text = viewModel.serviceDetailStr;
    [cell bindViewModel:viewModel];
    //        //  [(DesignerCompositionCell*)cell bindViewModel:(DesignerComposition*)viewModel];
    //    }
    
    
}

@end
