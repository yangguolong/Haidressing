//
//  StudioDetail.m
//  Hairdressing
//
//  Created by Guolong Yang on 16/4/8.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "StudioDetail.h"

@implementation StudioDetail

-(instancetype)init{
    self = [super init];
    if (self) {
       // [self initStudioDataDemo];
    }
    return self;
}
+ (instancetype)itemViewModelWithDict:(NSDictionary *)dict
{
    StudioDetail *model = [[StudioDetail alloc] init];
    model.corpId = [dict[@"corp_id"] intValue];
    model.address = dict[@"address"];
    model.corpPhone = dict[@"corp_phone"];
    model.corporation = dict[@"corporation"];
    model.envLogo = dict[@"env"];
    return model;
}

//-(void)initStudioDataDemo{
////    @property(nonatomic,assign) int corpId;
////    @property(nonatomic,copy) NSString *corporation;
////    @property(nonatomic,copy) NSString *abbreviation;
////    @property(nonatomic,copy) NSString *address;
////    @property(nonatomic,assign) int range;
////    @property(nonatomic,copy) NSString *faresStart;
////    @property(nonatomic,assign) int serviceCount;
////    @property(nonatomic,copy) NSString *techScore;
////    @property(nonatomic,copy) NSString *serviceScore;
////    @property(nonatomic,copy) NSString *envScore;
////    @property(nonatomic,copy) NSString *corpPhone;
////    @property(nonatomic,copy) NSString *corpLogo;
////    @property(nonatomic,strong) NSArray *envLogo;//图片地址数组
//    self.corpId = 11;
//    self.corporation = @"公司名称。。";
//    self.address = @"公司地址在哪里呢";
//    self.serviceCount = 100;
//    self.techScore = @"4.5";
//    self.serviceScore = @"6.0";
//    self.envScore = @"9.0";
//    self.corpPhone = @"13333333333";
//    self.designer.designerCount = 10;
//    self.envLogo = @[@"test01",@"test01",@"test01"];
//
//}

@end
