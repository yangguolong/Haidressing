//
//  CopyRightViewController.m
//  Hairdressing
//
//  Created by Guolong Yang on 16/5/24.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "CopyRightViewController.h"
#import "CopyRightViewModel.h"
@interface CopyRightViewController ()
@property (weak, nonatomic) IBOutlet UILabel *versionLab;
@property(nonatomic,strong,readwrite)CopyRightViewModel *viewModel;

@end

@implementation CopyRightViewController
@dynamic viewModel;
- (void)viewDidLoad {
    [super viewDidLoad];
  //
 //   self.view.backgroundColor = [UIColor yellowColor];
    NSString *version = [[[NSBundle mainBundle] infoDictionary]
                         objectForKey:@"CFBundleShortVersionString"];
    self.versionLab.text = [NSString stringWithFormat:@"版本号 %@",version];
}


@end
