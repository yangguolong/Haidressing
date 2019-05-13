//
//  StudioDesignerCell.h
//  Hairdressing
//
//  Created by Guolong Yang on 16/4/20.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRCReactiveView.h"
#import "StudioDesigner.h"
#import "ThirdCollectionView.h"
@protocol StudioDesignerCellDelegate;
@interface StudioDesignerCell : UITableViewCell <MRCReactiveView,ThirdCollectionViewDelegate>{
    NSMutableArray *designerIDArray;
    
}
@property (nonatomic, strong) StudioDesigner *viewModel;

@property (weak, nonatomic) IBOutlet UILabel *designerCount;


@property (weak, nonatomic) IBOutlet ThirdCollectionView *thirdCollectionView;
@property (weak, nonatomic) id<StudioDesignerCellDelegate> delegate;
//+(StudioDesignerCell*)cellWithTableView:(UITableView*)tableView;
@end

@protocol StudioDesignerCellDelegate <NSObject>

-(void)cellWithDesignerIndex:(NSInteger)designerIndex;

@end
