//
//  StudioServiceImpl.h
//  Hairdressing
//
//  Created by Guolong Yang on 16/5/5.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StudioService.h"
#import "BaseServiceImpl.h"
#define CachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]
@interface StudioServiceImpl : BaseServiceImpl<StudioService>

@end
