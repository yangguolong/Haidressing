




#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@protocol SettingService <NSObject>

//- (RACSignal *)settingWithUserName:(NSString *)username ;
//
//- (RACSignal *)settingWithSexurity:(NSString *)Sexurity ;
//
//- (RACSignal *)loginWithWeChatAndUserName:(NSString *)birthday;
-(RACSignal *)getUserInfoWithToken:(NSString*)token;

- (RACSignal *)settingWithToken:(NSString*)token UserName:(NSString *)username Birthday:(NSString*)birthday Sexurity:(NSString*)sex;

-(RACSignal *)editSettingWithUserName:(NSString*)userName;
-(RACSignal *)editSettingWithSexurity:(NSString*)sexurity;
-(RACSignal *)editSettingWithBirthday:(NSString*)birthday;

-(RACSignal *)feedBackWithToken:(NSString*)token Content:(NSString*)content AndContactWay:(NSString*)contact_way;

-(RACSignal *)uploadHeadImageWithToken:(NSString*)token HeadImage:(UIImage*)avartImage andAction:(NSString*)action;
@end