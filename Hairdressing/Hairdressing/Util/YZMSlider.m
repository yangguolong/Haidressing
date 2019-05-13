//
//  YZMSlider.m
//  CustomSlider
//
//  Created by Yangjiaolong on 16/5/30.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "YZMSlider.h"

#define LINEHEIGHT 2
#define THUMBRADIUS 8
#define TINYPOINTRADIUS 4

#define WIDTH  (self.frame.size.width - THUMBRADIUS *2)
@interface YZMSlider ()


@property (nonatomic,strong)CALayer * thumb;

@property (nonatomic,strong)CALayer * selectmask;

@property (nonatomic,strong)CALayer * normaLlayer;

@property (nonatomic,strong)CALayer * selectLayer;

@property (nonatomic,strong)CALayer * maskbackgrandLayer;

@property (nonatomic,strong) NSMutableArray * nomalps;

@property (nonatomic,strong) NSMutableArray * selectps;

@property (nonatomic,assign) BOOL needUpdate;
@end

@implementation YZMSlider

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSome];
    }
    return self;
}


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initSome];
    }
    return self;
}



-(void)initSome{
    
    _needUpdate = YES;
    _nomalps =[NSMutableArray array];
    _selectps = [NSMutableArray array];

    CGPoint center = CGPointMake(self.frame.size.width/2 , self.frame.size.height/2);
    
    _normaLlayer = [[CALayer alloc]init];
    _normaLlayer.bounds = CGRectMake(0, 0, WIDTH, LINEHEIGHT);
    _normaLlayer.backgroundColor = [UIColor colorWithWhite:229/255.f alpha:1].CGColor;
    _normaLlayer.position = center;
    [self.layer addSublayer:_normaLlayer];
    
    for (int i = 0; i < 5; i++) {
        CALayer * point = [[CALayer alloc]init];
        point.bounds = CGRectMake(0, 0, TINYPOINTRADIUS *2, TINYPOINTRADIUS *2);
        point.position = CGPointMake(i* WIDTH / 4 , LINEHEIGHT/2);
        point.cornerRadius = TINYPOINTRADIUS;
        point.backgroundColor = [UIColor colorWithWhite:229/255.f alpha:1].CGColor;
        [_nomalps addObject:point];
        [_normaLlayer addSublayer:point];
        
    }
    
    UIColor * orange = [UIColor colorWithRed:1 green:179/255.f blue:43/255.f alpha:1];
    _maskbackgrandLayer = [[CALayer alloc]init];
    
    CGRect rect = self.bounds;
//    rect.size.width = 100;
    _maskbackgrandLayer.bounds = rect;
    _maskbackgrandLayer.position = center;
    [self.layer addSublayer:_maskbackgrandLayer];
    
    _selectLayer = [[CALayer alloc]init];
    _selectLayer.bounds = CGRectMake(0, 0, WIDTH, LINEHEIGHT);
    _selectLayer.backgroundColor = orange.CGColor;
    _selectLayer.position = CGPointMake(_maskbackgrandLayer.bounds.size.width/2, self.frame.size.height/2);
    [_maskbackgrandLayer addSublayer:_selectLayer];
    
    for (int i = 0; i < 5; i++) {
        CALayer * point = [[CALayer alloc]init];
        point.bounds = CGRectMake(0, 0, TINYPOINTRADIUS * 2, TINYPOINTRADIUS *2);
        point.position = CGPointMake(i* WIDTH / 4 , LINEHEIGHT/2);
        point.cornerRadius = TINYPOINTRADIUS;
        point.backgroundColor = orange.CGColor;
        [_selectps addObject:point];
        [_selectLayer addSublayer:point];
        
    }
    _selectmask = [[CALayer alloc]init];
    CGRect arect = _maskbackgrandLayer.bounds;

    _selectmask.bounds = arect;
    _selectmask.position = CGPointMake(arect.size.width/2, self.frame.size.height/2);
    _selectmask.backgroundColor = [UIColor redColor].CGColor;
    _maskbackgrandLayer.mask = _selectmask;
    
    
    _thumb = [[CALayer alloc]init];
    _thumb.bounds = CGRectMake(0, 0, THUMBRADIUS *2, THUMBRADIUS *2 );
    _thumb.position = CGPointMake(WIDTH + THUMBRADIUS, self.frame.size.height / 2);
    _thumb.cornerRadius = THUMBRADIUS;
    _thumb.backgroundColor = orange.CGColor;
    [self.layer addSublayer:_thumb];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    
    _needUpdate = NO;
    CGPoint touchp = [[[touches allObjects]lastObject] locationInView:self];
    
    CGFloat half = self.frame.size.width / 8;
    CGFloat centerx;
    
    if (touchp.x < half) {
        centerx = 0;
    }else if (touchp.x > half && touchp.x < 3* half){
        centerx = 1;
    }else if (touchp.x > 3*half && touchp.x < 5* half){
        centerx = 2;
    }else if (touchp.x > 5* half && touchp.x < 7 *half){
        centerx = 3;
    }else{
        centerx = 4;
    }
    
    CGFloat x = WIDTH / 4 * centerx + 10;
    
    CGRect mframe = _selectmask.bounds;
    mframe.size.width = x;
    
    
    _selectmask.bounds = mframe;
    _selectmask.position = CGPointMake(mframe.size.width/2, mframe.size.height/2);
    _thumb.position = CGPointMake( x , _thumb.position.y);
    
    if (self.valuedidChangeBlock) {
        self.valuedidChangeBlock(centerx +1);
    }
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
}
-(void)updateUI{
    if (!_needUpdate) {
        return;
    }
    CGPoint center = CGPointMake(self.frame.size.width/2 , self.frame.size.height/2);
    
    
    _normaLlayer.bounds = CGRectMake(0, 0, WIDTH, LINEHEIGHT);
    
    _normaLlayer.position = center;
    if (_selectps && _nomalps) {
        
        for (int i = 0; i < 5; i++) {
            CALayer * point = _nomalps[i];
            point.bounds = CGRectMake(0, 0, TINYPOINTRADIUS *2, TINYPOINTRADIUS *2);
            point.position = CGPointMake(i* WIDTH / 4 , LINEHEIGHT/2);
            point.cornerRadius = TINYPOINTRADIUS;
            point.backgroundColor = [UIColor colorWithWhite:229/255.f alpha:1].CGColor;
        }
    }
    
    UIColor * orange = [UIColor colorWithRed:1 green:179/255.f blue:43/255.f alpha:1];
    
    CGRect rect = self.bounds;
    //    rect.size.width = 100;
    _maskbackgrandLayer.bounds = rect;
    _maskbackgrandLayer.position = center;
    
    
    
    _selectLayer.bounds = CGRectMake(0, 0, WIDTH, LINEHEIGHT);
    
    _selectLayer.position = CGPointMake(_maskbackgrandLayer.bounds.size.width/2, self.frame.size.height/2);

    if (_selectps && _nomalps) {
        
     
        for (int i = 0; i < 5; i++) {
            CALayer * point = _selectps[i];
            point.bounds = CGRectMake(0, 0, TINYPOINTRADIUS * 2, TINYPOINTRADIUS *2);
            point.position = CGPointMake(i* WIDTH / 4 , LINEHEIGHT/2);
            point.cornerRadius = TINYPOINTRADIUS;
            point.backgroundColor = orange.CGColor;
            
            
            
        }
        
    }
    
    CGRect arect = _maskbackgrandLayer.bounds;
    
    _selectmask.bounds = arect;
    _selectmask.position = CGPointMake(arect.size.width/2, self.frame.size.height/2);
    
    
    
    
    _thumb.bounds = CGRectMake(0, 0, THUMBRADIUS *2, THUMBRADIUS *2 );
    _thumb.position = CGPointMake(WIDTH + THUMBRADIUS, self.frame.size.height / 2);
    _thumb.cornerRadius = THUMBRADIUS;
    _thumb.backgroundColor = orange.CGColor;
    
 
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [self updateUI];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
