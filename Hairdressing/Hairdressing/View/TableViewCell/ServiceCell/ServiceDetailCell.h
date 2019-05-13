//
//  ServiceDetailCell.h
//  Hairdressing
//
//  Created by Guolong Yang on 16/4/18.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRCReactiveView.h"
@interface ServiceDetailCell : UITableViewCell<MRCReactiveView>


//@property(nonatomic,strong)UILabel *serviceDetailLab;
@property (weak, nonatomic) IBOutlet UILabel *serviceDetailLab;
+ (CGFloat)heightOfCell;
@end
