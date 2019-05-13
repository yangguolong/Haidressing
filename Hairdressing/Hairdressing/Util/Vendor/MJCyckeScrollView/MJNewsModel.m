//
//  MJNewsModel.m
//  Hairdressing
//
//  Created by 杨国龙 on 16/3/4.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "MJNewsModel.h"

@implementation MJNewsModel

+ (instancetype)modelWithId:(NSString *)ID name:(NSString *)name imageUrl:(NSString *)imageUrl
{
    MJNewsModel *model = [[MJNewsModel alloc] init];
    model.ID = ID;
    model.name = name;
    model.imageUrl = imageUrl;
    
    return model;
}

@end
