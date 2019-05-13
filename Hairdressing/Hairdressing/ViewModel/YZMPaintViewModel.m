//
//  YZMPaintViewModel.m
//  Hairdressing
//
//  Created by Yangjiaolong on 16/4/12.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "YZMPaintViewModel.h"
#import "YZMFixHairAreaViewModel.h"

@implementation YZMPaintViewModel

-(void)initialize{
    [super initialize];
    
    self.title = @"标记头发";
    self.inputImage = self.params[@"captureImage"];
    
    self.nextStepCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        YZMFixHairAreaViewModel * fixHairViewModel = [[YZMFixHairAreaViewModel alloc]initWithServices:self.services params:@{@"snapshotImage":self.inputImage}];
        [self.services pushViewModel:fixHairViewModel animated:YES];
        
        return [RACSignal empty];
    }];
    
}



@end
