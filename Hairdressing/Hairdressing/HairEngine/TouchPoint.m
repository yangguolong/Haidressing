//
//  TouchPoint.m
//  MyPainter
//
//  Created by charles wong on 13-4-25.
//  Copyright (c) 2013年 charles wong. All rights reserved.
//

#import "TouchPoint.h"

@implementation TouchPoint

- (void)setTouchPointWithCGPoint:(CGPoint)thePoint
{
    _Point = thePoint;
}

- (CGPoint)getTouchPoint
{
    return _Point;
}


+ (TouchPoint *)touchPointWithCGPoint:(CGPoint)thePoint
{
    TouchPoint * touchPoint = [[TouchPoint alloc] init];
    [touchPoint setTouchPointWithCGPoint:thePoint];
    return touchPoint;
}



@end
