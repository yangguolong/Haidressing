//
//  StudioDesignerModel.m
//  Hairdressing
//
//  Created by Guolong Yang on 16/4/6.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "StudioDesigner.h"

@implementation StudioDesigner

+ (instancetype)itemViewModelWithDict:(NSDictionary *)dict andDesignerCount:(NSUInteger)designerCount
{
    StudioDesigner *model = [[StudioDesigner alloc] init];
    model.designerCount = designerCount;
    model.hairstylistId = [dict[@"hairstylist_id"] integerValue];
    model.hairstylistName = dict[@"hairstylist_name"];
    model.labelsArr = dict[@"labels"];
    model.order_num = [dict[@"order_num"] integerValue];
    model.photo_URL_Str = dict[@"photo_url"];
    model.sign = dict[@"sign"];
    model.techScore = dict[@"tech_score"];
    return model;
}
@end
