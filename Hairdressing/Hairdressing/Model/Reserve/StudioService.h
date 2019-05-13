//
//  StudioService.h
//  Hairdressing
//
//  Created by Guolong Yang on 16/5/5.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
@protocol StudioService <NSObject>

- (RACSignal *)getStudioDetailWithStudioID:(NSNumber*)cropId;
- (RACSignal *)getDesignerDetailWithHairStyleID:(NSNumber*)hairStyId;
- (RACSignal *)getCommentWithStudioID:(NSNumber*)cropId pageNum:(NSNumber*)pNo pageSize:(NSNumber*)pSize;

- (RACSignal *)getServiceDetailWithItemID:(NSNumber*)itemId;

#pragma mark -- 发型师作品Service
- (RACSignal *)getDesigerComposiWithDesignerID:(NSNumber*)itemId andPageNum:(NSNumber *)pageNum andSize:(NSNumber *)pageSize;

- (RACSignal *)getSignedOrderWithToken:(NSString*)token payType:(NSNumber*)payType ItemID:(NSString*)itemId andOrderNum:(NSString*)orderNum;

- (RACSignal *)confirmOrderPaidOrNotWithToken:(NSString*)token payType:(NSNumber*)payType outTradeNum:(NSString*)outTradeStr;
#pragma mark--所有订单信息查询
- (RACSignal *)confirmAllOrderInfoWithToken:(NSString*)token;
@end