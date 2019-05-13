//
//  AllOrderInfoViewModel.h
//  Hairdressing
//
//  Created by Guolong Yang on 16/5/26.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AllOrderInfoViewModel : NSObject
@property(nonatomic,assign,readwrite)int unPayedCount;

@property(nonatomic,assign,readwrite)int payedCount;

@property(nonatomic,assign,readwrite)int unCommentCount;
@end
