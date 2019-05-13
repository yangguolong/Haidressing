//
//  CompositionCollectionView.h
//  Hairdressing
//
//  Created by Guolong Yang on 16/4/20.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TapImageView.h"
#import "ImgScrollView.h"
@protocol CompositionCollectionViewDelegate;
@interface CompositionCollectionView : UIView<UIScrollViewDelegate,TapImageViewDelegate,ImgScrollViewDelegate>
{
    UIScrollView            *scrollView;
    UIView                  *alphaView;
    UIView                  *scrollPanel;
}
@property(nonatomic,assign)CGSize cellSize;
@property(nonatomic,assign)NSUInteger sectionNum;

@property(nonatomic,weak)id<CompositionCollectionViewDelegate> delegate;
@end
@protocol CompositionCollectionViewDelegate <NSObject>
- (void)collectionViewdidSelectItemAtIndexPath:(NSInteger)indexPathSection;

@end
