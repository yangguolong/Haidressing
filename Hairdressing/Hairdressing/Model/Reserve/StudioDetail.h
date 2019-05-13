//
//  StudioDetail.h
//  Hairdressing
//
//  Created by BoDong on 16/4/8.
//  Copyright © 2016年 Cloudream. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StudioDesigner.h"
#import "StudioComment.h"
#import "ServiceCategories.h"
@interface StudioDetail : NSObject
@property(nonatomic,assign) int corpId;
@property(nonatomic,copy) NSString *corporation;
@property(nonatomic,copy) NSString *abbreviation;
@property(nonatomic,copy) NSString *address;
@property(nonatomic,assign) int range;
@property(nonatomic,copy) NSString *faresStart;
@property(nonatomic,copy) NSString *techScore;
@property(nonatomic,copy) NSString *serviceScore;
@property(nonatomic,copy) NSString *envScore;
@property(nonatomic,copy) NSString *corpPhone;
@property(nonatomic,copy) NSString *corpLogo;
@property(nonatomic,strong) NSArray *envLogo;//图片地址数组

//设计师
@property(nonatomic,strong)StudioDesigner *designer;
@property(nonatomic,assign)NSUInteger designerQuan;


//评论
@property(nonatomic,strong)StudioComment  *comment;
@property(nonatomic,assign)NSUInteger commentQuan;
//服务项目

@property(nonatomic,strong)ServiceCategories *service;
@property(nonatomic,assign)NSUInteger serviceQuan;

-(void)initStudioDataDemo;
@end
