//
//  StudioDetail.h
//  Hairdressing
//
//  Created by Guolong Yang on 16/4/8.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StudioDesigner.h"
#import "StudioComment.h"
#import "ServiceCategories.h"
@interface StudioDetail : NSObject
@property(nonatomic,copy) NSString *address;
@property(nonatomic,assign) int corpId;
@property(nonatomic,copy) NSString *corpPhone;
@property(nonatomic,copy) NSString *corporation;
@property(nonatomic,strong) NSArray *envLogo;//图片地址数组


-(void)initStudioDataDemo;
+ (instancetype)itemViewModelWithDict:(NSDictionary *)dict;
@end
