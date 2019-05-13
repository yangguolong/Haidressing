//
//  ThirdCollectionView.h
//  3张图片滚动demo
//
//  Created by admin on 16/4/10.
//  Copyright © 2016年 flybearTech. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ThirdCollectionViewDelegate;
@interface ThirdCollectionView : UIView


@property(nonatomic,strong)NSArray *imageViewArray;
@property(nonatomic,assign)CGSize cellSize;
@property(nonatomic,assign)NSUInteger sectionNum;
@property(nonatomic,weak)id<ThirdCollectionViewDelegate> delegate;
@end
@protocol ThirdCollectionViewDelegate <NSObject>

- (void)collectionViewdidSelectItemAtIndexPath:(NSInteger)indexPathSection;

@end