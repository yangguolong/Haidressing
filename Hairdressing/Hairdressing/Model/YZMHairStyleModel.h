//
//  YZMHairStyleModel.h
//  Hairdressing
//
//  Created by Yangjiaolong on 16/5/21.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZMHairStyleModel : NSObject

@property (nonatomic,copy) NSString * hairstyle_id;

@property (nonatomic,copy) NSString * hairstyle_name;

@property (nonatomic,copy) NSString * filename_2d;

@property (nonatomic,copy) NSString * filename_3d;

@property (nonatomic,copy) NSArray * corps;

@end
