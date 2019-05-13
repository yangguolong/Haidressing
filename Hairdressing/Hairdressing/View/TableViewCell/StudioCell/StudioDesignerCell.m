//
//  DesignerDetailCell.m
//  Hairdressing
//
//  Created by Guolong Yang on 16/4/8.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "StudioDesignerCell.h"
#import "StudioDesigner.h"
#import "ThirdCollectionView.h"
#import "StudioDetailViewModel.h"
@implementation StudioDesignerCell//发型师详情cell

- (void)awakeFromNib {
    // Initialization co
//    self.thirdCollectionView.cellSize =CGSizeMake(80, 80);
//    self.thirdCollectionView.sectionNum  = 5;
//    self.thirdCollectionView.delegate = self;
}

- (void)bindViewModel:(NSMutableArray*)dictArray
{
    //self.viewModel = viewModel;
    NSMutableArray *imageArray =[[NSMutableArray alloc]init];
    designerIDArray =[[NSMutableArray alloc]init];
    for (StudioDesigner *designer in dictArray) {
        NSString *imageStr = designer.photo_URL_Str;
        NSNumber *designerID =[NSNumber numberWithUnsignedInteger: designer.hairstylistId];
        [designerIDArray addObject:designerID];
        [imageArray addObject:imageStr];
    }
    
    self.designerCount.text = [NSString stringWithFormat:@"%lu",(unsigned long)imageArray.count];
//    self.thirdCollectionView.cellSize =CGSizeMake(84, 84);
    self.thirdCollectionView.sectionNum  = imageArray.count;
    self.thirdCollectionView.imageViewArray = imageArray;
    self.thirdCollectionView.delegate = self;

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

//+(StudioDesignerCell*)cellWithTableView:(UITableView*)tableView{
//    static NSString *identifier = @"StudioTableViewCell";
//    StudioDesignerCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    if (cell == nil) {
//        cell = [[[NSBundle mainBundle] loadNibNamed:@"StudioDesignerCell" owner:self options:nil] lastObject];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.thirdCollectionView.cellSize = CGSizeMake(80,80);
//        cell.thirdCollectionView.sectionNum = 3;
//        
//    }
//    return cell;
//}
#pragma mark thirdView delegate
-(void)collectionViewdidSelectItemAtIndexPath:(NSInteger)indexPathSection{
 //   NSLog(@"collectionViewdidSelectItemAtIndexPath:%d",indexPathSection);
    if ([self.delegate respondsToSelector:@selector(cellWithDesignerIndex:)]) {
        [self.delegate cellWithDesignerIndex:[[designerIDArray objectAtIndex:indexPathSection ] integerValue]];
    }
}
@end
