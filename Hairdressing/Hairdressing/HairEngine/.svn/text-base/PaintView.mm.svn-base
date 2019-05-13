//
//  PaintView.m
//  PaintingSample
//
//  Created by Sean Christmann on 10/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PaintView.h"
#import "TouchPoint.h"

#define kBrushPixelStep	3
#define BrushLineWidth 4
#define EraseWidth 5
#define BytePerPixel 4

@implementation PaintView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
//        [self initContext:frame.size];
        
        _CanvasImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _CanvasImageView.image = nil;
        [self addSubview:_CanvasImageView];
        
        
        _BlendMode = kCGBlendModeNormal;
        
        _RstBrushPointArray = nil;
        _RstTouchPointArray = [[NSMutableArray alloc] init];
        
        _RstImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _RstImageView.image = nil;
        [self addSubview:_RstImageView];
        [_RstImageView setHidden:YES];
        [_CanvasImageView setHidden:NO];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
     
//        [self initContext:self.frame.size];
        
        _CanvasImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _CanvasImageView.image = nil;
        [self addSubview:_CanvasImageView];
        
        
        _BlendMode = kCGBlendModeNormal;
        
        _RstBrushPointArray = nil;
        _RstTouchPointArray = [[NSMutableArray alloc] init];
        
        _RstImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _RstImageView.image = nil;
        [self addSubview:_RstImageView];
        [_RstImageView setHidden:YES];
        [_CanvasImageView setHidden:NO];

    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    _CanvasImageView.frame = self.bounds;
    _RstImageView.frame = self.bounds;
//    [self initContext:self.frame.size];
}
- (BOOL)initContext:(CGSize)size {
	
    int width = (int)size.width;
    int height = (int)size.height;
    
    int bytesPerPixel = 4;
    int bitsPerComponent = 8;
    
	int bitmapByteCount;
	int	bitmapBytesPerRow;
	
	// Declare the number of bytes per row. Each pixel in the bitmap in this
	// example is represented by 4 bytes; 8 bits each of red, green, blue, and
	// alpha.
	bitmapBytesPerRow = (width * bytesPerPixel);
	bitmapByteCount = (bitmapBytesPerRow * height);
	
	// Allocate memory for image data. This is the destination in memory
	// where any drawing to the bitmap context will be rendered.
    if (cacheBitmap) {
        free(cacheBitmap);
        cacheBitmap = NULL;
    }
    
	cacheBitmap = (unsigned char *)malloc( bitmapByteCount );
	if (cacheBitmap == NULL){
		return NO;
	}
    if (cacheContext) {
        CGContextRelease(cacheContext);
        cacheContext = NULL;
    }
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	cacheContext = CGBitmapContextCreate (cacheBitmap, width, height, bitsPerComponent, bitmapBytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colorSpace);
    
	return YES;
}

- (void)dealloc
{
    if(cacheBitmap)
    {
        free(cacheBitmap);
        cacheBitmap = NULL;
    }
    if(cacheContext)
    {
        CGContextRelease(cacheContext);
        cacheContext = NULL;
    }
//    if(_CanvasImageView)
//    {
//        [_CanvasImageView release];
//        _CanvasImageView = nil;
//    }
//    if(_RstBrushPointArray)
//    {
//        [_RstBrushPointArray release];
//        _RstBrushPointArray = nil;
//    }
//    if(_RstTouchPointArray)
//    {
//        [_RstTouchPointArray release];
//        _RstTouchPointArray = nil;
//    }
//    
    self.delegate = nil;
    
    
}

#pragma mark - Sence Rendering

- (void)updateCanvas
{
    CGImageRef imgRef = CGBitmapContextCreateImage(cacheContext);
    UIImage * img = [UIImage imageWithCGImage:imgRef];
    CGImageRelease(imgRef);
    _CanvasImageView.image = img;
}

- (void)renderLineFromPoint:(CGPoint)start toPoint:(CGPoint)end
{
    //coord transform
    start.y = _CanvasImageView.bounds.size.height - start.y;
    end.y = _CanvasImageView.bounds.size.height - end.y;
    
    int count = MAX(ceilf(sqrtf((end.x - start.x) * (end.x - start.x) + (end.y - start.y) * (end.y - start.y)) / kBrushPixelStep), 1);
    float xPos, yPos;
    float width, halfWidth;
    if(_ToolIndex == ERASER)
        width = EraseWidth;
    else
        width = BrushLineWidth;

    halfWidth = width / 2.0f;
    
    for(int i = 1; i <= count; i++)
    {
        _CurrentPoints++;
        
        xPos = start.x + (end.x - start.x) * ((GLfloat)i / (GLfloat)count);
        yPos = start.y + (end.y - start.y) * ((GLfloat)i / (GLfloat)count);
        CGContextFillEllipseInRect(cacheContext,(CGRectMake (xPos - halfWidth, yPos - halfWidth, width, width)));
	}
    [self updateCanvas];
}

- (void)useEraser
{
    //CGContextSetBlendMode(cacheContext, kCGBlendModeClear);
    //_BlendMode = kCGBlendModeClear;
    
    CGContextSetBlendMode(cacheContext, kCGBlendModeNormal);
    CGContextSetFillColorWithColor(cacheContext, [[UIColor whiteColor] CGColor]);
    _BlendMode = kCGBlendModeNormal;
}

- (void)useBrushWithColorIndex:(unsigned char)colorIndex
{
    UIColor * theColor = [self getColorByIndex:colorIndex];
    if(cacheContext)
    {
        CGContextSetBlendMode(cacheContext, kCGBlendModeNormal);
        CGContextSetFillColorWithColor(cacheContext, [theColor CGColor]);
        _BlendMode = kCGBlendModeNormal;
    }
}

- (UIColor *)getColorByIndex:(unsigned char)index
{
    UIColor * color;
    switch (index)
    {
        case 0:
            color = [UIColor redColor];
            break;
        case 1:
            color = [UIColor greenColor];
            break;
        case 2:
            color = [UIColor blueColor];
            break;
        default:
            color = [UIColor purpleColor];
            break;
    }
    return color;
}


#pragma mark - Interaction

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGContextClearRect(cacheContext, self.bounds);
    
	_touch = [touches anyObject];
    CGPoint startPoint = [_touch previousLocationInView:self];
    CGPoint endPoint = [_touch locationInView:self];
    _CurrentPoints = 0;
    [_RstTouchPointArray removeAllObjects];
    [_RstTouchPointArray addObject:[TouchPoint touchPointWithCGPoint:endPoint]];
	[self renderLineFromPoint:startPoint toPoint:endPoint];
    
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    _touch = [touches anyObject];
    CGPoint startPoint = [_touch previousLocationInView:self];
    CGPoint endPoint = [_touch locationInView:self];
    [_RstTouchPointArray addObject:[TouchPoint touchPointWithCGPoint:endPoint]];
	[self renderLineFromPoint:startPoint toPoint:endPoint];
    
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didDrawOneStroke:)])
        [self.delegate didDrawOneStroke:self];
    
    [super touchesEnded:touches withEvent:event];
}


#pragma mark - Interface

- (void)useTools:(unsigned short)toolIndex
{
    _ToolIndex = (PaintingTools)toolIndex;
    if(_ToolIndex == ERASER)
        [self useEraser];
    else
        [self useBrushWithColorIndex:toolIndex];
}


- (NSMutableArray *)generatePointsWithPaintingToolsIndex:(PaintingTools &)toolIndex
{
    //[self generateRstPointArrayFromMaskImage:cacheBitmap Width:self.bounds.size.width Height:self.bounds.size.height];
    toolIndex = _ToolIndex;
    //return _RstBrushPointArray;
    return _RstTouchPointArray;
}


-(void)clearView
{
    CGContextClearRect(cacheContext, self.bounds);
    [self updateCanvas];
}

- (void)switchImageView
{
    [_CanvasImageView setHidden: !_CanvasImageView.isHidden];
    [_RstImageView setHidden: !_RstImageView.isHidden];
}


- (void)colorForBitmap:(unsigned char *)bitmap AnchorPoint:(unsigned int)anchorpoint Red:(unsigned char &)red Green:(unsigned char &)green Blue:(unsigned char &)blue Alpha:(unsigned char &)alpha
{
    alpha = bitmap[anchorpoint];
    red   = bitmap[anchorpoint +1];
    green = bitmap[anchorpoint +2];
    blue  = bitmap[anchorpoint + 3];
}

- (void)generateRstPointArrayFromMaskImage:(unsigned char *)bitmap Width:(int)width Height:(int)height
{
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
    
//    if(!_RstBrushPointArray)
//        _RstBrushPointArray = [[NSMutableArray alloc] initWithCapacity:100];
//    else
//        [_RstBrushPointArray removeAllObjects];
    
//    int anchorPoint = 3; //get alpha value
//    int xMin = 100000;
//    int xMax = -1;
//    int yMin = 100000;
//    int yMax = -1;
//    for(int i=0; i<height; i++)
//        for(int j=0; j<width; j++)
//        {
//            //for pixel (j, i)
//            if(bitmap[anchorPoint] == 0xff)
//            {
//                //alpha = 255
//                [_RstBrushPointArray addObject:[TouchPoint touchPointWithCGPoint:CGPointMake(j, i)]];
//                if(xMin > j)    xMin = j;
//                if(xMax < j)    xMax = j;
//                if(yMin > i)    yMin = i;
//                if(yMax < i)    yMax = i;
//            }
//            
//            anchorPoint += BytePerPixel;
//        }
//    
//    _RangeRect = CGRectMake(xMin, yMin, xMax - xMin + 1, yMax - yMin + 1);
    
    CFAbsoluteTime endTime = CFAbsoluteTimeGetCurrent();
    NSLog(@"points generation : %f\n", endTime - startTime);
    
    //[self drawRstForArray:_RstBrushPointArray Rect:_RangeRect];
}

- (void)drawRstForArray:(NSMutableArray *)rstArray Rect:(CGRect)rangeRect
{
    CGSize  size = _RstImageView.bounds.size;
    float height = size.height;
    int bitmapByteCount;
	int	bitmapBytesPerRow;
    
	bitmapBytesPerRow = (size.width * 4);
	bitmapByteCount = (bitmapBytesPerRow * size.height);
    
	void * thecacheBitmap = malloc( bitmapByteCount );
	if (thecacheBitmap == NULL){
		return ;
	}
    
    CGContextRef thecacheContext;
	thecacheContext = CGBitmapContextCreate (thecacheBitmap, size.width, size.height, 8, bitmapBytesPerRow, CGColorSpaceCreateDeviceRGB(), kCGImageAlphaPremultipliedFirst);
    
    //float halfWidth = BrushLineWidth / 2.0f;
    CGContextClearRect(thecacheContext, _RstImageView.bounds);
    CGContextSetBlendMode(thecacheContext, kCGBlendModeNormal);
    CGContextSetFillColorWithColor(thecacheContext, [[self getColorByIndex:_ToolIndex] CGColor]);
    
    CGContextSetStrokeColorWithColor(thecacheContext, [[UIColor whiteColor] CGColor]);
    rangeRect.origin.y = height - rangeRect.origin.y - rangeRect.size.height;
    CGContextStrokeRectWithWidth(thecacheContext, rangeRect, 3);
    
    for(int i = 0; i < rstArray.count;i++)
    {
        TouchPoint * touchPoint = (TouchPoint *)[rstArray objectAtIndex:i];
        CGPoint point = [touchPoint getTouchPoint];
        point.y = height - point.y;
        //CGContextFillEllipseInRect(thecacheContext,(CGRectMake (point.x - halfWidth, point.y - halfWidth, BrushLineWidth, BrushLineWidth)));
        CGContextFillEllipseInRect(thecacheContext,(CGRectMake (point.x - 0.5, point.y - 0.5, 1, 1)));
    }
    
    
    CGImageRef imgRef = CGBitmapContextCreateImage(thecacheContext);
    UIImage * img = [UIImage imageWithCGImage:imgRef];
    CGImageRelease(imgRef);
    _RstImageView.image = img;
    
    free(thecacheBitmap);
    CGContextRelease(thecacheContext);
}

@end
