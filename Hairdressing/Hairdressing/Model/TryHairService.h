//
//  TryHairService.h
//  Hairdressing
//
//  Created by Guolong Yang on 16/4/5.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
@protocol TryHairService <NSObject>


- (RACSignal *)getHairType;

- (RACSignal *)getHairStyleListWithHairTypeId:(NSString *)hairtypeId pNo:(int)pNo pSize:(int)pSize;

- (RACSignal *)downloadFileWithHairModelName:(NSString *)modelName withHairModelId:(NSString *)hmid;


@end
