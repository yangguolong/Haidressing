//
//  AppDelegate.m
//  collectionViewDemo
//
//  Created by 李昌庆 on 16/1/14.
//  Copyright © 2016年 李昌庆. All rights reserved.
//

#import "AppDelegate.h"
#import "MRCViewModelServicesImpl.h"
#import "MRCNavigationControllerStack.h"
#import "FMDataTableManager.h"
#import <Reachability/Reachability.h>
#import "MyTabBarViewModel.h"
#import "LoginViewModel.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
#import "WXApiObject.h"
#import "WXApiManager.h"

#import "YZMLocationManager.h"
#import "HairEngine.h"

#import <AlipaySDK/AlipaySDK.h>
#import <UMMobClick/MobClick.h>
#import "NSString+Category.h"
#import "BaseServiceImpl.h"
#import "Utility.h"
#import "YZMAppraiseModel.h"
#import "YZMAppraiseViewModel.h"


//#import <Reachability/Reachability.h>
@interface AppDelegate ()
{
    HairEngine * _hairEnine;
    
}
@property (nonatomic, strong) MRCViewModelServicesImpl *services;
@property (nonatomic, strong) Reachability *reachability;
@property (nonatomic, assign, readwrite) NetworkStatus networkStatus;

@property (nonatomic, strong, readwrite) MRCNavigationControllerStack *navigationControllerStack;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.services = [[MRCViewModelServicesImpl alloc] init];
    self.navigationControllerStack = [[MRCNavigationControllerStack alloc] initWithServices:self.services];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self.services resetRootViewModel:[[MyTabBarViewModel alloc] initWithServices:self.services params:nil]];
  
    
    [self.window makeKeyAndVisible];
    [[UINavigationBar appearance]setTintColor:[UIColor blackColor]];
    

    [self configureReachability];
    [self configureShareSDK];
    
    NSLog(@"%@",NSHomeDirectory());
    
    [[YZMLocationManager shareInstance] start];
    
    [self initHairEngine];
    [self testInterface];
    [self initLogin];
    //向微信注册
    [WXApi registerApp:@"wx5c3f362d8620d5f6" withDescription:@"weixin"];//注册微信支付
    //友盟注册
    UMConfigInstance.appKey = @"573bdbd1e0f55a27e6002341";//Hime在友盟的appkey
    UMConfigInstance.channelId = @"App Store";
    
    return YES;
}

- (void)testInterface
{
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    parameters[@"jsonrpc"] = @"2.0";
//    parameters[@"params"] = @[ @{@"cityId" : @"440300", @"sortType": @"1", @"districtId" : @"0", @"townId" : @"0", @"longitude": @"114.02597366", @"latitude": @"22.54605355", @"distance": @"100000000", @"pNo": @"1", @"pSize": @"10" } ];
//    
//    [self testNetWithParams:parameters withAction:@"getCorplist"];
}

-(void)initLogin{
//    User *user = [User getUserFromDB];
//    if (!user) {
//        user  = [[User alloc]  init];
//        user.account = [[NSUserDefaults standardUserDefaults] objectForKey:USER_ACCOUT];
//        [user saveOrUpdate];
//    }

}

-(void)initHairEngine{
    CFAbsoluteTime subStartTime, subEndTime;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask ,YES);
    NSString *documentsDirectory = paths[0];
    NSString * drawingsDirectory = [documentsDirectory stringByAppendingPathComponent:@"work"];
    
    [[NSFileManager defaultManager] createDirectoryAtPath:drawingsDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
    subStartTime = CFAbsoluteTimeGetCurrent();
    NSString * hairEngineInitDataDir = [[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"AppData"] stringByAppendingPathComponent:@"HairEngineInitData"];
    const char * hairEngineInitDataDirChar = [hairEngineInitDataDir UTF8String];
    
    _hairEnine = new HairEngine();
    _hairEnine->initEngine(hairEngineInitDataDirChar, true);
    subEndTime = CFAbsoluteTimeGetCurrent();
    printf("create Det: %lf s\n", subEndTime - subStartTime);
    
}

-(HairEngine *)getHairEngine{
    return _hairEnine;
}
- (void)configureReachability {
    self.reachability = Reachability.reachabilityForInternetConnection;
    
    RAC(self, networkStatus) = [[[[[NSNotificationCenter defaultCenter]
                                   rac_addObserverForName:kReachabilityChangedNotification object:nil]
                                  map:^(NSNotification *notification) {
                                      return @([notification.object currentReachabilityStatus]);
                                  }]
                                 startWith:@(self.reachability.currentReachabilityStatus)]
                                distinctUntilChanged];
    
    @weakify(self)
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @strongify(self)
        [self.reachability startNotifier];
    });
}

- (void)configureShareSDK
{
    [ShareSDK registerApp:@"1020e8b39c389"
          activePlatforms:@[@(SSDKPlatformTypeSinaWeibo),@(SSDKPlatformTypeWechat),@(SSDKPlatformTypeQQ)]
                 onImport:^(SSDKPlatformType platformType) {
                     switch (platformType)
                     {
                         case SSDKPlatformTypeWechat:
                             //                             [ShareSDKConnector connectWeChat:[WXApi class]];
                             [ShareSDKConnector connectWeChat:[WXApi class] delegate:self];
                             break;
                         case SSDKPlatformTypeQQ:
                             [ShareSDKConnector connectQQ:[QQApiInterface class]
                                        tencentOAuthClass:[TencentOAuth class]];
                             break;
                             
                             break;
                         default:
                             break;
                     }
                 }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
              
              switch (platformType)
              {
                  case SSDKPlatformTypeSinaWeibo:
                      //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                      [appInfo SSDKSetupSinaWeiboByAppKey:@"1395479196"
                                                appSecret:@"87b119d293f929f25d1b1425a97c5a38"
                                              redirectUri:@"https://api.weibo.com/oauth2/default.html"
                                                 authType:SSDKAuthTypeBoth];
                      break;
                      
                  case SSDKPlatformTypeQQ:
                      [appInfo SSDKSetupQQByAppId:@"1105161013" appKey:@"HqlVSC7jmQerYhOp" authType:SSDKAuthTypeBoth];
                      break;
                  case SSDKPlatformTypeWechat:
                      [appInfo SSDKSetupWeChatByAppId:@"" appSecret:@""];
                  default:
                      
                      break;
              }
          }];
    
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)testNetWithParams:(NSDictionary *)parameters withAction:(NSString *)action
{
    // 1.时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval timestamp=[dat timeIntervalSince1970];
    NSString *time = [NSString stringWithFormat:@"%0.f", timestamp];
    
    // 2. request_id: 标识每个请求的唯一数字串,对于同一个request_id的请求，服务器端只接受一次.规则：年份(2位)+月份+日期+时+分+秒+6位随机数    例如 160218160101123456s
    NSString *date = [Utility  getDateByTimestamp:timestamp type:8];
    NSString * genRandString = [Utility genRandStringLength:6];
    NSString *request_id = [NSString stringWithFormat:@"%@%@", date, genRandString];
    
    
    // 3.sign: 指请求方按照后台规定的规则生成的一串字符串，后台系统用该字符串进行请求的身份认证。
    // 生成规则：md5(BA),其中A= "API请求地址的?后的所有字符串(不包括sign)"，B=md5('hair.cloud.net ')。
    
    NSString *B = [@"hair.cloud.net" md5Str];
    NSString *A = [NSString stringWithFormat:@"request_id=%@&time=%@",request_id ,time] ;
    NSString *sign = [[NSString stringWithFormat:@"%@%@", B, A] md5Str];
    
    NSString *requestURL = [NSString stringWithFormat:@"%@%@?%@&sign=%@",ONLINEHOST,action, A, sign];
    DLog(@"设置请求URL: %@", requestURL);
    //         NSString *requestURL = @"http://192.168.1.46/api/deviceRegister?request_id=160222153354123456&time=1456126434013&token=D713CBC68622C8A361D4119399DD2109&dev_sn=cd5cd0c087259bec";
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestURL]];
    [request setHTTPMethod:@"POST"];
    
    // 添加body
    NSString *str = [parameters mj_JSONString];
    if (str) {
        DLog(@"设置请求参数：%@",str);
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:data];
    }
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.responseSerializer = [AFJSONResponseSerializer serializer]; //AFJSONResponseSerializer
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error)
        {
            
            DLog(@"Error: %@", error);
//            [subscriber sendError:error];
            
        } else
        {
            
            NSLog(@"%@ %@", response, responseObject);
            
            
            
            if([responseObject objectForKey:@"code"])
            {
                int code = [responseObject[@"code"] intValue];
                switch (code) {
                    case 0:
                         DLog(@"请求成功: %@", responseObject[@"result"]);
                        break;
                        
                    default:
                        
                        break;
                }
                if (code == 0) {
                    
                   
//                    [subscriber sendNext:responseObject[@"result"]];
//                    [subscriber sendCompleted];
                    
                } else {
                    
                    DLog(@"Error: %@", responseObject[@"msg"]);
//                    [subscriber sendError:responseObject[@"msg"]];
                    
                }
                
            }
        }
    }];
    [dataTask resume];
}

//9.0以下的接口，支付宝回调调用此方法，（需要找8.0系统手机测试）
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
//    if ([url.host isEqualToString:@"safepay"]) {
//        //跳转支付宝钱包进行支付，处理支付结果
//        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//            NSLog(@"result = %@",resultDic);
//        }];
//    }
//    return YES;
    
    //如果极简开发包不可用，会跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给开发包
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            NSLog(@"result = %@",resultDic);
        }];
    }
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回authCode
        
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            NSLog(@"result = %@",resultDic);
        }];
    }
    if ([[(NSDictionary*)annotation objectForKey:@"UIApplicationOpenURLOptionsSourceApplicationKey"] isEqualToString:@"com.tencent.xin"]) {
        return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
    return YES;
}

//9.0以上的系统，支付宝需要调用这个方法
-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    //如果极简开发包不可用，会跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给开发包
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            NSLog(@"result = %@",resultDic);
        }];
    }
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回authCode
        
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            NSLog(@"result = %@",resultDic);
        }];
    }
    if ([[options objectForKey:@"UIApplicationOpenURLOptionsSourceApplicationKey"] isEqualToString:@"com.tencent.xin"]) {
        return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
    return YES;
}

//-(void)onResp:(BaseResp*)resp{
//    if ([resp isKindOfClass:[PayResp class]]){
//        PayResp*response=(PayResp*)resp;
//        switch(response.errCode){
//            case WXSuccess:
//                //服务器端查询支付通知或查询API返回的结果再提示成功
//                NSLog(@"支付成功");
//                break;
//            default:
//                NSLog(@"支付失败，retcode=%d",resp.errCode);
//                break;
//        }
//    }
//}

@end
