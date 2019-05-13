//
//  StudioDetailViewModel.h
//  Hairdressing
//
//  Created by Guolong Yang on 16/4/6.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StudioComment.h"
#import "StudioDesigner.h"
#import "ServiceCategories.h"
#import "StudioDetail.h"
@interface StudioDetailViewModel : MRCTableViewModel
{
//    StudioDetail *studioDetail;
}
@property(nonatomic,copy)NSString *title;
//corp 门店详情
@property(nonatomic,copy,readonly)NSString *studioName;
@property(nonatomic,strong,readonly)NSString  *address;
@property(nonatomic,assign,readonly)int corp_id;
@property(nonatomic,copy,readonly)NSString  *phoneNumStr;
@property(nonatomic,strong,readonly)NSArray *imagePathArr;// 门店环境图

@property(nonatomic,strong,readonly)StudioDesigner  *designer;
//@property(nonatomic,assign,readonly)int hairstyCount;
@property(nonatomic,strong,readonly)StudioComment  *comment;
//@property(nonatomic,assign,readonly)int commentCount;
@property(nonatomic,strong,readonly)ServiceCategories  *serviceCategories;
//@property(nonatomic,assign,readonly)int serviceCount;
//@property(nonatomic,strong,readonly)StudioDetail *studioDetail;
//@property(nonatomic,assign,readonly)BOOL designerHidden;
//@property(nonatomic,assign,readonly)BOOL commentHidden;
//@property(nonatomic,assign,readonly)BOOL serviceHidden;
@end
