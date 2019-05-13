//
//  ServiceCell.h
//  Hairdressing
//
//  Created by Guolong Yang on 16/4/8.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRCReactiveView.h"
#import "ServiceCategories.h"
@protocol   ServiceCellDelegate;
@interface ServiceCell : UITableViewCell<MRCReactiveView>

@property (weak) IBOutlet NSLayoutConstraint *constraint;

@property (weak, nonatomic) IBOutlet UILabel *serviceCountLab;


@property (weak, nonatomic) IBOutlet UIImageView *serviceImageView;

@property (weak, nonatomic) IBOutlet UILabel *serviceType;

@property (weak, nonatomic) IBOutlet UILabel *servicePrice;

@property (weak, nonatomic) IBOutlet UIView *detailView;

@property (nonatomic, assign) id<ServiceCellDelegate>   delegate;

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, strong) ServiceCategories *categoryModel;

//-(void)configWithServiceCategoriesModel:(ServiceCategories *)categoryModel;

//+(ServiceCell*)cellWithTableView:(UITableView*)tableView labHidden:(BOOL)hidden;

//-(void)addItem;

@end
@protocol ServiceCellDelegate <NSObject>

@optional
- (void)ChangeCountOfCell:(ServiceCell *)cell;
//- (void)deleteCommentOfCell:(Comment *)comment;

@end
