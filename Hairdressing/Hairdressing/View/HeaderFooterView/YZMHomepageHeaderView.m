//
//  YZMHomepageHeaderView.m
//  Hairdressing
//
//  Created by 杨国龙 on 16/3/4.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "YZMHomepageHeaderView.h"
#import "YZMCategoryButton.h"
#import <Masonry/Masonry.h>

@interface YZMHomepageHeaderView ()



@end

@implementation YZMHomepageHeaderView


+ (NSString *)indentifier
{
    return @"YZMHomepageHeaderView";
}

+ (CGFloat)height
{
    return 240;
}

- (void)awakeFromNib {

   
    for ( NSString *category in self.categoryData ) {
         // 1.添加View
//        UIView *categoryView = [[UIView alloc] init];
//        [categoryView setBackgroundColor:[UIColor redColor]];
//       
//           [self.classfiyStackView addArrangedSubview:categoryView];
//        
//        [categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
//            
//        }];
//        
        // 2.添加ImageView
//        UIImageView *categoryImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"test3"]];
//        [categoryView addSubview:categoryImageView];
        // 3.添加Label
        
      
        

    }

    
}

- (NSArray *)categoryData
{
    if (_categoryData == nil) {
        _categoryData = [NSArray arrayWithObjects:@"test2", @"test2",@"test2", @"test2", nil];
    }
    return _categoryData;
}

//- (void)layoutSubviews
//{
//        
//        [super layoutSubviews];
////        _sliderView.frame = self.frame;
//
//}

@end