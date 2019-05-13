//
//  MJNewsModel.h
//  Hairdressing
//
//  Created by 杨国龙 on 16/3/4.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJNewsModel : NSObject

@property (nonatomic ,copy)NSString *ID;

@property (nonatomic ,copy)NSString *name;

@property (nonatomic ,copy)NSString *imageUrl;

+ (instancetype)modelWithId:(NSString *)ID name:(NSString *)name imageUrl:(NSString *)imageUrl;

@end