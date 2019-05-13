//
//  TapImageView.h
//  ismarter2.0_sz
//
//  Created by liuqian on 14-8-13.
//
//

#import <UIKit/UIKit.h>


@protocol TapImageViewDelegate <NSObject>

- (void)tappedWithObject:(id)sender;

@end

@interface TapImageView : UIImageView

@property (nonatomic, assign) id<TapImageViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame isFromDetail:(BOOL)isFromDetail;

@end
