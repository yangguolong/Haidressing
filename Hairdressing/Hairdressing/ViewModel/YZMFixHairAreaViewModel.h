//
//  YZMFixHairAreaViewModel.h
//  Hairdressing
//
//  Created by Yangjiaolong on 16/4/12.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "MRCViewModel.h"


typedef NS_ENUM(NSInteger,FixHairViewStep){
    
    FixHairViewStepOne = 0,
    FixHairViewStepTwo,
    
};


@interface YZMFixHairAreaViewModel : MRCViewModel

@property (nonatomic,strong) UIImage *  snapshotImage;

@property (nonatomic,strong) RACCommand * finishCommand;

@property (nonatomic,assign) FixHairViewStep step;

@property (nonatomic,strong) NSArray * hairTypeNameList;

@property (nonatomic,strong) NSArray * hiarStyleList;

@property (nonatomic,strong) NSArray * corpList;


@property (nonatomic,strong) RACCommand * didSelecthairTypeCommand;

@property (nonatomic,strong) RACCommand * didSelectHairStyleCommand;

@property (nonatomic,strong) RACCommand * didSelectCorpCommand;

@end
