//
//  DesignerCompositionCell.m
//  Hairdressing
//
//  Created by Guolong Yang on 16/4/11.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "DesignerCompositionCell.h"
#import "DesignerComposition.h"
#import "ThirdCollectionView.h"
@implementation DesignerCompositionCell

- (void)awakeFromNib {
//    self.thirdCollectionView.cellSize =CGSizeMake(80, 80);
//    self.thirdCollectionView.sectionNum  = 2;
 //   self.thirdCollectionView.delegate = self;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)bindViewModel:(DesignerComposition*)viewModel
{
    NSLog(@"service cell bind view model");
    //self.thirdCollectionView.cellSize =CGSizeMake(80, 80);
    self.thirdCollectionView.sectionNum  = viewModel.imagePathArray.count;
    self.thirdCollectionView.imageViewArray = viewModel.imagePathArray;
    self.thirdCollectionView.delegate = self;
    self.composiCountLab.text =[NSString stringWithFormat:@"查看所有"];
//    self.servicePrice.text =[NSString stringWithFormat:@"%lu",(unsigned long)viewModel.price];
//    self.serviceType.text = viewModel.itemName;
//    //    self.viewModel = viewModel;
//    //    self.designerCount.text = [NSString stringWithFormat:@"%lu",(unsigned long)viewModel.designerCount];
//    //      self.thirdCollectionView.sectionNum  = viewModel.designerCount;
    
}

#pragma mark --CompCompositionCollectionView Delegate
- (void)collectionViewdidSelectItemAtIndexPath:(NSInteger)indexPathSection{
    if ([self.delegate respondsToSelector:@selector(cellWithDesignerIndex:)]) {
        [self.delegate cellWithDesignerIndex:indexPathSection];
    }

}

@end
