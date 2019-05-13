//
//  DesignerCompositionViewController.h
//  Hairdressing
//
//  Created by Guolong Yang on 16/4/20.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRCCollectionViewController.h"

@interface DesignerCompositionViewController : MRCCollectionViewController<UIScrollViewDelegate>
{
    UIScrollView            *scrollView;
    UIView                  *coverView;
    UIView                  *scrollPanel;
    UILabel                 *pageLabel;
    NSUInteger              imageTotalCount;
}

@end
