//
//  DesignerCompositionViewModel.h
//  Hairdressing
//
//  Created by Guolong Yang on 16/4/20.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MRCCollectionViewModel.h"
@interface DesignerCompositionViewModel : MRCCollectionViewModel
@property(nonatomic,copy,readonly) NSString *masterpieceName;
@property(nonatomic,assign,readonly)int masterpieceCount;
@property(nonatomic,strong,readonly)NSArray *imagePathArr;

@property(nonatomic,strong,readwrite)NSNumber *designerID;
@property(nonatomic,strong,readonly)RACCommand *downloadComposiCommand;
@end
