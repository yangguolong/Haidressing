
//
//  YZMFixHairAreaViewModel.m
//  Hairdressing
//
//  Created by Yangjiaolong on 16/4/12.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "YZMFixHairAreaViewModel.h"
#import "YZM3DChangeHairViewModel.h"
#import "YZMHairTypeModel.h"
#import "YZMHairStyleModel.h"
#import "YZMCorpsModel.h"
#import "StudioDetailViewModel.h"



@interface YZMFixHairAreaViewModel ()

@property (nonatomic,strong) RACCommand * getHairListCommand;
@end

@implementation YZMFixHairAreaViewModel


-(void)initialize{
    [super initialize];
    
    self.title = @"";
    
    self.snapshotImage = self.params[@"snapshotImage"];
    
    
   
    [[self.services.tryHairService getHairType] subscribeNext:^(id x) {

        
        self.hairTypeNameList = [YZMHairTypeModel mj_objectArrayWithKeyValuesArray:x];
        
    }];
    void (^doNext)(NSDictionary *) = ^(NSDictionary *responeData) {
        NSArray * result = responeData[@"data"];
        
        self.hiarStyleList = [YZMHairStyleModel mj_objectArrayWithKeyValuesArray:result];
        
    };
    self.getHairListCommand = [[RACCommand alloc]  initWithSignalBlock:^RACSignal *(id input) {
        
        return   [[self.services.tryHairService getHairStyleListWithHairTypeId:@"" pNo:1 pSize:10] doNext:doNext];

        
    }];
    [self.getHairListCommand execute:@""];
    
    self.didSelecthairTypeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSIndexPath * input) {
        NSString * hairtypeId = [self.hairTypeNameList objectAtIndex:input.row];
        
        [self.getHairListCommand execute:hairtypeId];
        
        return [RACSignal empty];
    }];
    self.didSelectHairStyleCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSIndexPath * input) {
        YZMHairStyleModel * cmodel = [self.hiarStyleList objectAtIndex:input.row];
        self.corpList = cmodel.corps;
        YZMHairStyleModel * hsModel = self.hiarStyleList[input.row];
        
        return [self.services.tryHairService downloadFileWithHairModelName:hsModel.filename_3d withHairModelId:hsModel.hairstyle_id];
        
//        return [RACSignal empty];
    }];
    
    self.didSelectCorpCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSIndexPath * input) {
        YZMCorpsModel * cmodel = [self.corpList objectAtIndex:input.row];
        
        StudioDetailViewModel * sdViewModel = [[StudioDetailViewModel alloc]initWithServices:self.services params:@{@"corp_id":cmodel.corp_id}];
        [self.services pushViewModel:sdViewModel animated:YES];
        return [RACSignal empty];
    }];
    
}
@end