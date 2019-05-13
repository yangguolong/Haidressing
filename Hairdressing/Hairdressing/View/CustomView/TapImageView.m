//
//  TapImageView.m
//  ismarter2.0_sz
//
//  Created by liuqian on 14-8-13.
//
//

#import "TapImageView.h"

@implementation TapImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initGesture];
    }
    return self;
}

- (void)initGesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Tapped:)];
    [self addGestureRecognizer:tap];

    self.clipsToBounds  = YES;
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.contentScaleFactor = [[UIScreen mainScreen] scale];
    self.userInteractionEnabled = YES;
}

- (id)initWithFrame:(CGRect)frame isFromDetail:(BOOL)isFromDetail
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initGesture];
    }
    return self;
}

- (void)awakeFromNib
{
    [self initGesture];
}

- (void)Tapped:(UIGestureRecognizer *) gesture
{
    [self.delegate tappedWithObject:self];
}



@end
