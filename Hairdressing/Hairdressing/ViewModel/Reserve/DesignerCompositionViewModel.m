//
//  DesignerCompositionViewModel.m
//  Hairdressing
//
//  Created by Guolong Yang on 16/4/20.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "DesignerCompositionViewModel.h"
#import "DesignerComposition.h"
@interface DesignerCompositionViewModel()
@property(nonatomic,copy,readwrite) NSString *masterpieceName;
@property(nonatomic,assign,readwrite)int masterpieceCount;
@property(nonatomic,strong,readwrite)NSArray *imagePathArr;
//@property(nonatomic,strong,readwrite)NSNumber *designerID;

@property(nonatomic,strong,readwrite)RACCommand *downloadComposiCommand;
@end
@implementation DesignerCompositionViewModel
-(void)initialize{
    [super initialize];
//    DesignerCompositionViewModel *model1 = [[DesignerCompositionViewModel alloc]init];
//    model1.title= @"理发师作品";
//    model1.masterpieceCount = 5;
//    model1.masterpieceName = @"大师级作品";
//    model1.imagePathArr = [NSArray arrayWithObjects:@"image_1",@"image_2",@"image_3", nil];
//    self.dataSource = @[@[model1]];
   
    @weakify(self)
    void (^doNext)(NSDictionary *) = ^(NSDictionary *responeData) {
        @strongify(self)

        NSMutableArray *tempImageArray =[[NSMutableArray alloc]init];
        for (NSDictionary *objDict in responeData[@"data"]) {
            NSString *str =   [objDict objectForKey:@"img"];
            [tempImageArray addObject:str];
        }
        self.imagePathArr = tempImageArray ;
        self.masterpieceCount = [responeData[@"count"] intValue];
//        if (![responeData[@"data"] isKindOfClass:[NSNull class]]) {
//            self.imagePathArr = responeData[@"data"];
//        }

    };
    
    self.downloadComposiCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"点击了登录");
//        return [[self.services.studioService loginWithUserName:self.username password:self.password]
//                doNext:doNext];
        return [[self.services.studioService getDesigerComposiWithDesignerID:self.designerID andPageNum:@1 andSize:@10] doNext:doNext];
    }];
}




@end
