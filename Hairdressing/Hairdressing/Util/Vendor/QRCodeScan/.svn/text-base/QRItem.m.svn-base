//
//  QRItem.m
//  QRWeiXinDemo
//
//  Created by lovelydd on 15/4/30.
//  Copyright (c) 2015年 lovelydd. All rights reserved.
//

#import "QRItem.h"
#import <objc/runtime.h>

@implementation QRItem


- (instancetype)initWithFrame:(CGRect)frame
                       //titile:(NSString *)titile
                imageWithName:(NSString *)imageName
{
    
    self =  [QRItem buttonWithType:UIButtonTypeCustom];
    if (self) {
        
//        [self setTitle:titile forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        self.frame = frame;
    }
    return self;
}

@end
