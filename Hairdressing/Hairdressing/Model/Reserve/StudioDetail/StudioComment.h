//
//  StudioComment.h
//  Hairdressing
//
//  Created by Guolong Yang on 16/4/6.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StudioComment : NSObject
@property(nonatomic,assign)NSUInteger commentCount	;//	总评论数
@property(nonatomic,assign)NSUInteger corpId	;//	评论序号
@property(nonatomic,copy)NSString *tech_score	;//	技术评分
@property(nonatomic,copy)NSString *service_score	;//	服务评分
@property(nonatomic,copy)NSString *env_score	;//	环境评分
@property(nonatomic,copy)NSString *remark	;//	评论内容
@property(nonatomic,strong)NSArray *commentLabel	;//	评论标签(技术好，服务好，啥啥啥的)
@property(nonatomic,assign)int   creat_time;//创建时间
@property(nonatomic,copy)NSString *nickName	;//	用户昵称

@property(nonatomic,copy)NSString * headImgURLStr	;//用户头像

+ (instancetype)itemViewModelWithDict:(NSDictionary *)dict andCommentCount:(NSUInteger)commentCount;

@end
