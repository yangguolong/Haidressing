//
//  YZMTakePhotoViewModel.m
//  Hairdressing
//
//  Created by Yangjiaolong on 16/4/5.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "YZMTakePhotoViewModel.h"
#import "YZMPSViewModel.h"


@interface YZMTakePhotoViewModel ()


@end
@implementation YZMTakePhotoViewModel

-(void)initialize{
    [super initialize];
    
    self.title = @"拍照";
    @weakify(self)
    [[RACObserve(self, captureImage)filter:^BOOL(UIImage * value) {
        return value != nil;
    }] subscribeNext:^(id x) {
        @strongify(self)
        
        YZMPSViewModel * psViewModel = [[YZMPSViewModel alloc]initWithServices:self.services params:@{@"captureImage":self.captureImage}];
        [self.services pushViewModel:psViewModel animated:YES];
    }];
    
    self.didPickerImageCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIImage*  input) {
       
        YZMPSViewModel * psViewModel = [[YZMPSViewModel alloc]initWithServices:self.services params:@{@"captureImage":input}];
        [self.services pushViewModel:psViewModel animated:YES];
        
        return [RACSignal empty];
    }];
}



@end
