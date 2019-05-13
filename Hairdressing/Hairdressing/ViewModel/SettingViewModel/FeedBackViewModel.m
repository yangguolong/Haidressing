//
//  FeedBackViewModel.m
//  Hairdressing
//
//  Created by Guolong Yang on 16/4/29.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "FeedBackViewModel.h"

@interface FeedBackViewModel()//<UIAlertViewDelegate>
@property(nonatomic,strong,readwrite)RACCommand *feedBackCommand;

@property(nonatomic,strong,readwrite)RACSignal *validFeedBackSignal;
@end

@implementation FeedBackViewModel



-(void)initialize{
    [super initialize];
    @weakify(self)
    void (^doNext)(NSDictionary *) = ^(NSDictionary *responeData) {
//        @strongify(self)
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"反馈已提交,感谢您的宝贵意见！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [[self rac_signalForSelector:@selector(alertView:clickedButtonAtIndex:) fromProtocol:@protocol(UIAlertViewDelegate)] subscribeNext:^(RACTuple *tuple) {
            switch ([tuple.second integerValue]) {
                case 0:
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.services popViewModelAnimated:YES];
                    });
                }
                  //  NSLog(@"tuple 0 ");
                    break;
                case 1:
                    NSLog(@"tuple 1 ");
                    break;
                default:
                    break;
            }
        }];
        [alertView show];

        
        
    };
    self.feedBackCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        return [[self.services.settingService feedBackWithToken:[[NSUserDefaults standardUserDefaults]objectForKey:USER_TOKEN] Content:self.content AndContactWay:self.contact_way] doNext:doNext];
    }];

    self.validFeedBackSignal = [[RACSignal combineLatest:@[RACObserve(self, content),RACObserve(self, contact_way)] reduce:^(NSString *content,NSString *contact_way){
        return @(content.length>0 && contact_way.length>0 );
    }] distinctUntilChanged];
                                
    
}





@end
