//
//  UserInfoEditViewModel.m
//  Hairdressing
//
//  Created by Guolong Yang on 16/4/13.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "UserInfoEditViewModel.h"
#import "User.h"
@implementation UserInfoEditViewModel

- (instancetype)initWithServices:(id<MRCViewModelServices>)services params:(NSDictionary *)params {
    self = [super init];
    if (self) {
        self.userEditItem = [params objectForKey:@"type"];
    }
    return self;
}

-(void)initialize{
    [super initialize];
    @weakify(self)
    self.models = [User getUserFromDB];
    RAC(self,name)=RACObserve(self.models, name);
    RAC(self,birthday)  = RACObserve(self.models, birthday);
    RAC(self,sexuality) =RACObserve(self.models, sex);
    RAC(self,account) = RACObserve(self.models, account);
    
}
@end
