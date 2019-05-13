//
//  ServiceDetailViewModel.m
//  Hairdressing
//
//  Created by Guolong Yang on 16/4/15.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "ServiceDetailViewModel.h"
#import "ServiceDetail.h"
#import "ServiceCategories.h"
#import "AliPayDemoViewModel.h"
#import "YZMServiceDetailModel.h"
#import "YZMConfirmOrderViewModel.h"
#import "LoginViewModel.h"
@interface ServiceDetailViewModel()

@property(nonatomic,strong,readwrite)NSNumber *serviceID;
@property(nonatomic,strong,readwrite)NSString *imagePathStr;
@property(nonatomic,assign,readwrite)NSString * price;
@property(nonatomic,copy,readwrite)NSString * serviceName;
@property(nonatomic,copy,readwrite)NSString * serviceDetail;
@property(nonatomic,copy)NSString * itemicon;
@property(nonatomic,strong) YZMServiceDetailModel * sdModel;

@end
@implementation ServiceDetailViewModel
- (instancetype)initWithServices:(id<MRCViewModelServices>)services params:(NSDictionary *)params {
    self = [super initWithServices:services params:params];
    if (self) {
        self.serviceID = [NSNumber numberWithInt:[params[@"serviceItem_id"] intValue]];
    }
    return self;
}


-(void)initialize{
    [super initialize];
    
    @weakify(self)
    
    //测试
    
    [[self.services.studioService getServiceDetailWithItemID:self.serviceID] subscribeNext:^(id x) {
        DLog(@"xxxx%@",x);
        self.sdModel =[YZMServiceDetailModel mj_objectWithKeyValues:x];
        
    }];
    [[RACObserve(self, sdModel) filter:^BOOL(id value) {
        return value != nil;
    }] subscribeNext:^(YZMServiceDetailModel * xsd) {
        self.price = xsd.price;
        self.imagePathStr = xsd.item_url;
        self.serviceName = xsd.item_name;
        self.serviceDetail = xsd.serviceDetail;
        self.supplys = xsd.supply;
        self.itemicon = xsd.item_icon;
        NSMutableAttributedString * atstr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%@",xsd.stand_price]];
        [atstr addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, atstr.length)];
        self.standPrice = atstr;
    }];

    self.confirmOrderCommand = [[RACCommand alloc]  initWithSignalBlock:^RACSignal *(id input) {
        if (![[NSUserDefaults standardUserDefaults]boolForKey:ISLOGIN]){
            //如果用户未登录，则跳转到登录页面
            LoginViewModel *loginViewModel = [[LoginViewModel alloc] initWithServices:self.services params:nil];
            //   [self.services presentViewModel:loginViewModel animated:YES completion:nil];
            [self.services presentViewModel:loginViewModel animated:YES completion:nil];
            return [RACSignal empty];
        }
        YZMConfirmOrderViewModel * coModel = [[YZMConfirmOrderViewModel alloc]initWithServices:self.services params:@{@"itemId":self.serviceID,@"price":self.price,@"itemicon":self.itemicon}];
        [self.services pushViewModel:coModel animated:YES];
        
        return [RACSignal empty];
    }];
    
}


@end