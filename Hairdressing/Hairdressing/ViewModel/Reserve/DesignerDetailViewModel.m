//
//  DesignerDetailViewModel.m
//  Hairdressing
//
//  Created by admin on 16/4/10.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "DesignerDetailViewModel.h"
#import "DesignerComposition.h"
#import "ServiceCategories.h"
#import "DesignerCompositionViewModel.h"
#import "ServiceDetailViewModel.h"
@interface DesignerDetailViewModel()

@property(nonatomic,copy,readwrite)NSString *headImgViewURLStr;
@property(nonatomic,copy,readwrite)NSString *nickName;
@property(nonatomic,copy,readwrite)NSString *signatureStr;
@property(nonatomic,copy,readwrite)NSString *studioName;
@property(nonatomic,copy,readwrite)NSString *studioAddress;

//@property(nonatomic,copy,readwrite)NSString *designerID;

@property(nonatomic,assign,readwrite)BOOL compositionHidden;
@property(nonatomic,assign,readwrite)BOOL serviceHidden;
@property(nonatomic,strong,readwrite)RACCommand *collectionViewSelectCommand;
@end
@implementation DesignerDetailViewModel


-(void)initialize{
    [super initialize];

    @weakify(self)
    self.didSelectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSIndexPath *indexPath) {
        //@strongify(self)
        if (indexPath.section == 0) {
            DesignerCompositionViewModel *compViewModel = [[DesignerCompositionViewModel alloc]initWithServices:self.services params:nil];
            compViewModel.designerID = [NSNumber numberWithInt:[self.designerID intValue]];
            [self.services pushViewModel:compViewModel animated:YES];
            
        }
        else if (indexPath.section == 1 ) {//服务项目
            ServiceCategories *serviceCate = self.dataSource[indexPath.section][indexPath.row];
            ServiceDetailViewModel *serviceViewModel = [[ServiceDetailViewModel alloc]initWithServices:self.services params:@{@"serviceItem_id":[NSNumber numberWithInt:serviceCate.itemId]}];
            [self.services pushViewModel:serviceViewModel animated:YES];
        }
        return [RACSignal empty];
    }];
    
    self.collectionViewSelectCommand =[[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *num) {
        @strongify(self)
        
            DesignerCompositionViewModel *compViewModel = [[DesignerCompositionViewModel alloc]initWithServices:self.services params:nil];
            compViewModel.designerID = [NSNumber numberWithInt:[self.designerID intValue]];
            [self.services pushViewModel:compViewModel animated:YES];
        return [RACSignal empty];
    }];
    
}

- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page {
    return [[[self.services.studioService getDesignerDetailWithHairStyleID:[NSNumber numberWithInt:[self.designerID intValue]]  ]//71有图片
             doNext:^(NSArray *result) {
                 //  self.dataSource = result;
             }]
            map:^id(NSDictionary *value) {
                NSMutableArray *tempDataSource =[[NSMutableArray alloc]init];
                
                DesignerComposition *composition = [[DesignerComposition alloc]init];
                NSMutableArray *tempImageArray =[[NSMutableArray alloc]init];
                for (NSDictionary *objDict in value[@"portfolios"]) {
                  NSString *str =   [objDict objectForKey:@"img"];
                    [tempImageArray addObject:str];
                }
                composition.imagePathArray = tempImageArray;
                composition.count = [value[@"pfCount"] intValue];
                [tempDataSource addObject:@[composition]];
                // 字典转模型，遍历字典中的所有元素，全部映射成模型，并且生成数组
                NSMutableArray *serviceDicArr = value[@"services"];
                NSMutableArray *serviceArray = [[NSMutableArray alloc]init];
                for (int i=0; i<serviceDicArr.count; i++) {
                    [serviceArray addObject:[ServiceCategories itemViewModelWithDict:[serviceDicArr objectAtIndex:i] andServiceCount:serviceDicArr.count]];
                }
                [tempDataSource addObject:serviceArray];
                
                NSDictionary *studioDic = value[@"hairsty"];
                self.headImgViewURLStr = studioDic[@"photo_url"];
                self.nickName = studioDic[@"hairstylist_name"];
                self.signatureStr = studioDic[@"sign"];
                self.studioName = studioDic[@"corporation"];
                self.studioAddress = studioDic[@"address"];
                

                
                self.dataSource = tempDataSource;

                return [RACSignal empty];
            }];
}
@end
