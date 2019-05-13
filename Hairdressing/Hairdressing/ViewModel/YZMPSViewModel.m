//
//  YZMPSViewModel.m
//  Hairdressing
//
//  Created by Yangjiaolong on 16/4/12.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "YZMPSViewModel.h"
#import "YZMPaintViewModel.h"

@implementation YZMPSViewModel

-(void)initialize{
    [super initialize];
    
    self.title = @"";
    
    self.captureImage = self.params[@"captureImage"];
    
    self.nextStepCommamd = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
       
        YZMPaintViewModel * paintViewModel = [[YZMPaintViewModel alloc]initWithServices:self.services params:@{@"captureImage":self.captureImage}];
        [self.services pushViewModel:paintViewModel animated:YES];
        
        return [RACSignal empty];
    }];
}


@end