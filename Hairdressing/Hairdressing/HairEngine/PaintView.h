//
//  PaintView.h
//  PaintingSample
//
//  Created by Sean Christmann on 10/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ColorTypes 3

enum PaintingTools
{
    BRUSH_RED,
    BRUSH_GREEN,
    BRUSH_BLUE,
    ERASER
};
typedef enum PaintingTools PaintingTools;

@protocol PaintViewDelegate <NSObject>

-(void)didDrawOneStroke:(id)sender;

@end

@interface PaintView : UIView {
    unsigned char * cacheBitmap;
    CGContextRef cacheContext;
    
    UITouch * _touch;
    
    UIImageView * _PhotoImageView;
    UIImageView * _CanvasImageView;
    
    PaintingTools _ToolIndex;
    CGBlendMode _BlendMode;
    unsigned int _CurrentPoints;
    
    NSMutableArray * _RstBrushPointArray;
    CGRect _RangeRect;
    
    UIImageView * _RstImageView;
    
    NSMutableArray * _RstTouchPointArray;
}

@property (nonatomic, assign) id<PaintViewDelegate> delegate;

- (BOOL)initContext:(CGSize)size;
- (void)renderLineFromPoint:(CGPoint)start toPoint:(CGPoint)end;
- (void)useTools:(unsigned short)toolIndex;
- (NSMutableArray *)generatePointsWithPaintingToolsIndex:(PaintingTools &)toolIndex;
- (void)clearView;
- (void)switchImageView;
@end
