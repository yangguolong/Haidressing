//
//  YZMMessageListViewCtrl.m
//  Hairdressing
//
//  Created by yzm on 16/4/22.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "YZMMessageListViewCtrl.h"
#import "YZMMessageTableViewCell.h"

@interface YZMMessageListViewCtrl ()

@end

@implementation YZMMessageListViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YZMMessageTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([YZMMessageTableViewCell class])];
    
    [self.tableView setRowHeight:87.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


# pragma mark - uitableview delegate datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZMMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YZMMessageTableViewCell class]) forIndexPath:indexPath];
    return cell;
}


@end
