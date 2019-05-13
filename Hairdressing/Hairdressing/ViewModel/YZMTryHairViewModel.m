//
//  YZMTryHairViewModel.m
//  Hairdressing
//
//  Created by 杨国龙 on 16/3/4.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "YZMTryHairViewModel.h"
#import "YZMTakePhotoViewModel.h"

@interface YZMTryHairViewModel ()

@property (nonatomic,strong,readwrite)RACCommand * leftItemButtonCommand;

@end

@implementation YZMTryHairViewModel



-(void)initialize{
    [super initialize];
    
    self.title = @"试发";
    
    
    self.leftItemButtonCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        YZMTakePhotoViewModel * tpViewModel = [[YZMTakePhotoViewModel alloc]initWithServices:self.services params:nil];
        
        [self.services pushViewModel:tpViewModel animated:YES];
        
        return [RACSignal empty];
    }];
    
    
}


@end
