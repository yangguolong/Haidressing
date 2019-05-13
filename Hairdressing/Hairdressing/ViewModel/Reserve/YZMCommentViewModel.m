//
//  YZMCommentViewModel.m
//  Hairdressing
//
//  Created by Guolong Yang on 16/4/21.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "YZMCommentViewModel.h"
#import "StudioComment.h"
@implementation YZMCommentViewModel

-(void)initialize{
    [super initialize];
    self.title = @"全部评论";
//    YZMCommentViewModel *model1 = [[YZMCommentViewModel alloc]init];
//    model1.commentTimeStamp = @"20160101";
//   // model1.commentCount =100;
//    model1.commentContent = @"我是沙发评论";
//    model1.userName = @"王二小";
//    YZMCommentViewModel *model3= [[YZMCommentViewModel alloc]init];
//    model3.commentTimeStamp = @"20160101";
//    // model1.commentCount =100;
//    model3.commentContent = @"我是沙发评论";
//    model3.userName = @"王二小";
//    YZMCommentViewModel *model4 = [[YZMCommentViewModel alloc]init];
//    model4.commentTimeStamp = @"20160101";
//    // model1.commentCount =100;
//    model4.commentContent = @"我是沙发评论";
//    model4.userName = @"王二小";
//    YZMCommentViewModel *model2= [[YZMCommentViewModel alloc]init];
//    model2.commentTimeStamp = @"20160101";
//    // model1.commentCount =100;
//    model2.commentContent = @"我是沙发评论";
//    model2.userName = @"王二小";
//    YZMCommentViewModel *model5 = [[YZMCommentViewModel alloc]init];
//    model5.commentTimeStamp = @"20160101";
//    // model1.commentCount =100;
//    model5.commentContent = @"我是沙发评论";
//    model5.userName = @"王二小";

}

- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page {
    
    return [[[self.services.studioService getCommentWithStudioID:[NSNumber numberWithUnsignedInteger:self.corpId] pageNum:@1 pageSize:@10 ]
             doNext:^(NSArray *result) {
                 //  self.dataSource = result;
             }]
            map:^id(NSDictionary *value) {
                NSMutableArray *tempDataSource =[[NSMutableArray alloc]init];
                NSMutableArray *commentDicArr = value[@"data"];
                NSMutableArray *commentArray = [[NSMutableArray alloc]init];
                for (int i=0; i<commentDicArr.count; i++) {
                    [commentArray addObject:[StudioComment itemViewModelWithDict:[commentDicArr objectAtIndex:i] andCommentCount:commentDicArr.count]];
                }
                [tempDataSource addObject:commentArray];
               self.dataSource = tempDataSource;
                self.commentCount = commentArray.count;

                return [RACSignal empty];
            }];
}
             


@end
