//
//  StudioComment.m
//  Hairdressing
//
//  Created by Guolong Yang on 16/4/6.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "StudioComment.h"

@implementation StudioComment

+ (instancetype)itemViewModelWithDict:(NSDictionary *)dict andCommentCount:(NSUInteger)commentCount
{
    StudioComment *model = [[StudioComment alloc] init];
    model.commentCount = commentCount;
    model.corpId = [dict[@"id"] integerValue];
    model.tech_score = dict[@"tech_score"];
    model.service_score = dict[@"service_score"];
 
   model.env_score = dict[@"env_score"];
    model.remark = dict[@"remark"];
    model.commentLabel = dict[@"labels"];
    model.creat_time = [dict[@"create_time"] intValue];
    model.nickName = dict[@"nickname"];
    model.headImgURLStr = dict[@"head_img"];
    
    return model;
}


@end
