//
//  StudioDetailViewModel.m
//  Hairdressing
//
//  Created by Guolong Yang on 16/4/6.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "StudioDetailViewModel.h"
#import "YZMCommentViewModel.h"
#import "StudioDetail.h"
#import "StudioDesigner.h"
#import "StudioComment.h"
#import "ServiceCategories.h"
#import "ServiceDetailViewModel.h"
@interface StudioDetailViewModel ()

@property(nonatomic,copy,readwrite)NSString *studioName;
@property(nonatomic,strong,readwrite)NSString  *address;
@property(nonatomic,copy,readwrite)NSString  *phoneNumStr;
@property(nonatomic,strong,readwrite)NSArray *imagePathArr;// 门店环境图
@property(nonatomic,strong,readwrite)StudioDesigner  *designer;
@property(nonatomic,strong,readwrite)StudioComment  *comment;
@property(nonatomic,strong,readwrite)ServiceCategories  *serviceCategories;

@property(nonatomic,assign,readwrite)int corp_id;

//@property(nonatomic,assign,readwrite)BOOL designerHidden;
//@property(nonatomic,assign,readwrite)BOOL commentHidden;
//@property(nonatomic,assign,readwrite)BOOL serviceHidden;

@end

@implementation StudioDetailViewModel
- (instancetype)initWithServices:(id<MRCViewModelServices>)services params:(NSDictionary *)params {
    self = [super initWithServices:services params:params];
    if (self) {
        self.corp_id = [params[@"corp_id"] intValue];
    }
    return self;
}

-(void)initialize{
    [super initialize];

    @weakify(self)
    self.didSelectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSIndexPath *indexPath) {
        @strongify(self)

        if (indexPath.section == 1) {
            //如果已经登录，则跳转到个人编辑设置页面
            YZMCommentViewModel *commentViewModel =[[YZMCommentViewModel alloc]initWithServices:self.services params:nil];
            commentViewModel.corpId = self.corp_id;
            [self.services pushViewModel:commentViewModel animated:YES];
            
        }
        else if (indexPath.section == 2 ) {//服务项目
            ServiceCategories *serviceCate = self.dataSource[indexPath.section][indexPath.row];
            ServiceDetailViewModel *serviceViewModel = [[ServiceDetailViewModel alloc]initWithServices:self.services params:@{@"serviceItem_id":[NSNumber numberWithInt:serviceCate.itemId]}];
            [self.services pushViewModel:serviceViewModel animated:YES];
        }
        return [RACSignal empty];
    }];

    //tableheaderView的数据
//    self.purchaseCount = 1000;
//    self.technicPoint = @"满分";
//    self.environmentPoint = @"零分";
//    self.servicePoint = @"0.9";
//    self.address =@"天涯海角";
//    self.phoneNumStr = @"13600172150";
//
//    StudioDesigner* studioDesigner = [[StudioDesigner alloc]init];
//    studioDesigner.designerCount  = 999;
//    
//    StudioComment *comment = [[StudioComment alloc]init];
//    comment.remark = @"服务非常好";
//    comment.nickName = @"帅气的发型师";
//    comment.count = 99;
//    
//    ServiceCategories *serviceCategories1 = [[ServiceCategories alloc]init];
//    serviceCategories1.itemName = @"总监剪发";
//    serviceCategories1.price = 80;
//    serviceCategories1.buyerCount = 2000;
//    ServiceCategories *serviceCategories2 = [[ServiceCategories alloc]init];
//    serviceCategories2.itemName = @"小兵美发";
//    serviceCategories2.price = 20;
//    ServiceCategories *serviceCategories3 = [[ServiceCategories alloc]init];
//    serviceCategories3.itemName = @"大家乱剪";
//    serviceCategories3.price = 10;
//    self.dataSource = @[@[studioDesigner],@[comment],@[serviceCategories1,serviceCategories2,serviceCategories3]];//
}



- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page {

    return [[[self.services.studioService getStudioDetailWithStudioID:[NSNumber numberWithUnsignedInteger:self.corp_id] ]
             doNext:^(NSArray *result) {
                      //  self.dataSource = result;
             }]
            map:^id(NSDictionary *value) {
                NSMutableArray *tempDataSource =[[NSMutableArray alloc]init];
                // 字典转模型，遍历字典中的所有元素，全部映射成模型，并且生成数组
                NSMutableArray *designerDicArr = value[@"hairstys"] ;
                NSMutableArray *tempDesignerArr= [[NSMutableArray alloc]init];
                StudioDesigner *designer=[[StudioDesigner alloc]init];
                if (designerDicArr.count!=0) {
                    for (NSDictionary *dict in designerDicArr) {
                        designer = [StudioDesigner itemViewModelWithDict:dict andDesignerCount:designerDicArr.count];
                        [tempDesignerArr addObject:designer];
                    }
                   
                }
                [tempDataSource addObject:@[tempDesignerArr]];
 
                
                NSMutableArray *commentDicArr = value[@"comments"] ;
                StudioComment *comment =[[StudioComment alloc]init];
                if (commentDicArr.count != 0) {
                    comment = [StudioComment itemViewModelWithDict:[commentDicArr objectAtIndex:0] andCommentCount:commentDicArr.count];
                }
                [tempDataSource addObject:@[comment]];
 
                
                NSMutableArray *serviceDicArr = value[@"services"];
                NSMutableArray *serviceArray = [[NSMutableArray alloc]init];
                for (int i=0; i<serviceDicArr.count; i++) {
                  [serviceArray addObject:[ServiceCategories itemViewModelWithDict:[serviceDicArr objectAtIndex:i] andServiceCount:serviceDicArr.count]];
                }
                [tempDataSource addObject:serviceArray];
                
                self.dataSource = tempDataSource;
         
                NSDictionary *studioDic = value[@"corp"];
                StudioDetail *studio =[StudioDetail itemViewModelWithDict:studioDic];
                self.address = studio.address;
                self.studioName = studio.corporation;
                self.phoneNumStr = studio.corpPhone ;
                self.imagePathArr =studio.envLogo;
                return [RACSignal empty];
            }];
}


@end
