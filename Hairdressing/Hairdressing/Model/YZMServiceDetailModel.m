//
//  YZMServiceDetailModel.m
//  Hairdressing
//
//  Created by Yangjiaolong on 16/5/23.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "YZMServiceDetailModel.h"


@implementation YZMServiceDetailModel
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"serviceDetail":@"description"};
}

+(NSDictionary *)mj_objectClassInArray{
    return @{@"supply":@"YZMSupplyModel"};
}
@end
