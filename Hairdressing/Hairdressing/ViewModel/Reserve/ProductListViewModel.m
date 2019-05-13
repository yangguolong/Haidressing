//
//  ProductListViewModel.m
//  Hairdressing
//
//  Created by Guolong Yang on 16/4/6.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "ProductListViewModel.h"
#import "StudioDetailViewModel.h"
@implementation ProductListViewModel

- (instancetype)initWithServices:(id<MRCViewModelServices>)services params:(NSDictionary *)params {
    self = [super initWithServices:services params:params];
    if (self) {
        //id user = params[@"user"];
        
        //        if ([user isKindOfClass:[User class]]) {
        //            self.user = params[@"user"];
        //        } else if ([user isKindOfClass:[NSDictionary class]]) {
        //            self.user = [OCTUser modelWithDictionary:user error:nil];
        //        } else {
        //            self.user = [OCTUser mrc_currentUser];
        //        }
    }
    return self;
}
-(void)initialize{
    @weakify(self)
    self.didSelectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSIndexPath *indexPath) {
        @strongify(self)
        
        StudioDetailViewModel *studioDetailViewModel = [[StudioDetailViewModel alloc] initWithServices:self.services params:nil];
        [self.services pushViewModel:studioDetailViewModel animated:YES];
        
        return [RACSignal empty];
    }];
    
}

@end
