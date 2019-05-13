//
//  YZMShopListViewModel.h
//  Hairdressing
//
//  Created by yzm on 16/4/12.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "MRCTableViewModel.h"

@interface YZMShopListViewModel : MRCTableViewModel

@property (nonatomic ,strong) NSNumber *sortTypeId;
@property (nonatomic ,copy) NSString *areaId;
@property (nonatomic ,copy) NSString *longitude;
@property (nonatomic ,copy) NSString *latitude;
@property (nonatomic ,copy) NSString *corporation;


@end
