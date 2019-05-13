//
//  DesignerDetailViewModel.h
//  Hairdressing
//
//  Created by admin on 16/4/10.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServiceCategories.h"
#import "DesignerComposition.h"
@interface DesignerDetailViewModel : MRCTableViewModel

@property(nonatomic,copy)NSString *title;
//@property(nonatomic,strong,readonly)NSArray *imagePathArr;
//@property(nonatomic,assign,readonly)NSUInteger purchaseCount;
//@property(nonatomic,copy,readonly)NSString *     technicPoint;
////@property(nonatomic,copy,readonly)NSString *       environmentPoint;
////@property(nonatomic,copy,readonly)NSString *       servicePoint;
//@property(nonatomic,strong,readonly)NSString  *address;
////@property(nonatomic,strong,readonly)NSString  *phoneNumStr;
////@property(nonatomic,strong,readonly)StudioDesigner  *designer;
////@property(nonatomic,strong,readonly)StudioComment  *comment;
////@property(nonatomic,strong,readonly)ServiceCategories  *serviceCategories;
@property(nonatomic,copy,readonly)NSString *headImgViewURLStr;
@property(nonatomic,copy,readonly)NSString *nickName;
@property(nonatomic,copy,readonly)NSString *signatureStr;
@property(nonatomic,copy,readonly)NSString *studioName;

@property(nonatomic,copy,readwrite)NSString *designerID;
@property(nonatomic,copy,readonly)NSString *itemID;// 服务项目id
@property(nonatomic,strong,readonly)DesignerComposition *composition;//作品图片数组
@property(nonatomic,strong,readonly)ServiceCategories  *serviceCategories;
@property(nonatomic,strong,readonly)RACCommand *collectionViewSelectCommand;
@end
