//
//  YZMProductTableViewCell.m
//  Hairdressing
//
//  Created by 杨国龙 on 16/3/7.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "YZMProductTableViewCell.h"
#import "YZMShopModel.h"
#import "BitmapUtils.h"

@interface YZMProductTableViewCell ()

@property (nonatomic, strong) YZMShopModel *viewModel;

@property (weak, nonatomic) IBOutlet UILabel *corporationLabel;
@property (weak, nonatomic) IBOutlet UILabel *townNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (weak, nonatomic) IBOutlet UILabel *faresStartLabel;
@property (weak, nonatomic) IBOutlet UIImageView *image_view;
@property (weak, nonatomic) IBOutlet UILabel *corpLabelLabel;


@end

@implementation YZMProductTableViewCell

+ (NSString *)indentifier
{
    return @"YZMProductTableViewCell";
}

+ (CGFloat)cellHeight
{
    return  (SCREEN_WIDTH - 2*5 ) / 2 + 90;  // (screen_width - 2 * padding ) / 2 + label_height
}

- (void)awakeFromNib {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


}

- (void)bindViewModel:(YZMShopModel *)viewModel
{
    self.viewModel = viewModel;
    self.corporationLabel.text = [NSString stringWithFormat:@"%@", viewModel.corporation];
    self.townNameLabel.text = [NSString stringWithFormat:@"%@ | %@", viewModel.commercial_area, viewModel.distance];
    self.faresStartLabel.text = [NSString stringWithFormat:@"￥%@起", viewModel.fares_start];
    self.descLabel.text = [NSString stringWithFormat:@"%@", viewModel.signature];
    
    NSMutableString *labels = [[NSMutableString alloc] init];
    for (int i = 0; i < viewModel.corp_label.count; i ++) {
        [labels appendString:viewModel.corp_label[i]];
        if(i != viewModel.corp_label.count - 1)
        [labels appendString:@" • "];
    }
    
    NSMutableAttributedString * atstr= [[NSMutableAttributedString alloc] initWithString:labels];

    NSRange searchRange = NSMakeRange(0,labels.length);
    NSRange foundRange;
    while (searchRange.location < labels.length) {
        searchRange.length = labels.length-searchRange.location;
        foundRange = [labels rangeOfString:@"•" options:nil range:searchRange];
        if (foundRange.location != NSNotFound) {
            // found an occurrence of the substring! do stuff here
                [atstr addAttribute:NSForegroundColorAttributeName value:HexRGBAlpha(0xffffff, 0.6) range:foundRange];
            
            searchRange.location = foundRange.location+foundRange.length;
        } else {
            // no more substring to find
            break;
        }
    }
    
    
//    NSRange 
    self.corpLabelLabel.attributedText = atstr ;//[NSString stringWithFormat:@"%@", ];
    
    
    [BitmapUtils setImageWithImageView:self.image_view URLString:viewModel.env_img];
    
    
}

@end
