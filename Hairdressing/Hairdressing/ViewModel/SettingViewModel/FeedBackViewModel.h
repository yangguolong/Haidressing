//
//  FeedBackViewModel.h
//  Hairdressing
//
//  Created by Guolong Yang on 16/4/29.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedBackViewModel : MRCViewModel

@property(nonatomic,copy)NSString *token;

@property(nonatomic,copy)NSString *content;

@property(nonatomic,copy)NSString  *contact_way;


@property(nonatomic,strong,readonly)RACCommand *feedBackCommand;

@property(nonatomic,strong,readonly)RACSignal *validFeedBackSignal;


@end
