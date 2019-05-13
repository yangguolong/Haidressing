//
//  DesignerCompositionCell.h
//  Hairdressing
//
//  Created by Guolong Yang on 16/4/11.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRCReactiveView.h"
#import "DesignerCompositionCell.h"
#import "ThirdCollectionView.h"
@protocol DesignerCompositionCellDelegate;
@class CompositionCollectionView;

@interface DesignerCompositionCell : UITableViewCell<MRCReactiveView,ThirdCollectionViewDelegate>
@property (weak, nonatomic) IBOutlet ThirdCollectionView *thirdCollectionView;

@property (weak, nonatomic) IBOutlet UILabel *composiCountLab;

@property (weak, nonatomic) id<DesignerCompositionCellDelegate> delegate;
@end


@protocol DesignerCompositionCellDelegate <NSObject>

-(void)cellWithDesignerIndex:(NSInteger)designerIndex;

@end
