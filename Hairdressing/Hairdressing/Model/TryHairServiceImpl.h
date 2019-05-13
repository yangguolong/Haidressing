//
//  TryHairServiceImpl.h
//  Hairdressing
//
//  Created by Guolong Yang on 16/4/5.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TryHairService.h"
#import "BaseServiceImpl.h"
#define CachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]
@interface TryHairServiceImpl : BaseServiceImpl<TryHairService>

@end
