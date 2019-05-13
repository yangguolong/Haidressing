//
//  YZMMyCollectionViewModel.m
//  Hairdressing
//
//  Created by Yangjiaolong on 16/4/14.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "YZMMyCollectionViewModel.h"


@interface YZMMyCollectionViewModel ()

@end

@implementation YZMMyCollectionViewModel


-(void)initialize{
    [super initialize];
    
    self.title = @"我的收藏";
    
    [[[self.services profileService] getFavorspNo:1 pSize:20] subscribeNext:^(id x) {
      
        DLog(@"xxx%@",x);
    }];

    
}

@end