//
//  StudioDesignerModel.h
//  Hairdressing
//
//  Created by Guolong Yang on 16/4/6.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StudioDesigner : NSObject//门店详情页面的发型师cell内容

@property(nonatomic,assign)NSUInteger designerCount;

@property(nonatomic,assign)NSUInteger hairstylistId;
@property(nonatomic,copy)NSString * hairstylistName;
@property(nonatomic,strong)NSArray *labelsArr;
@property(nonatomic,assign)NSUInteger order_num;
@property(nonatomic,copy)NSString *photo_URL_Str;
@property(nonatomic,copy)NSString *sign;
@property(nonatomic,copy)NSString *techScore;
+ (instancetype)itemViewModelWithDict:(NSDictionary *)dict andDesignerCount:(NSUInteger)designerCount;

@end
