
#import "Utility.h"
@implementation Utility

#define ORIGINAL_MAX_WIDTH 640.0f
+ (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

+ (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
        
        //pop the context to get back to the default
        UIGraphicsEndImageContext();
        return newImage;
}//


/**
 *  判断字符串是否含有非法字符
 *
 *  @param str 需要判断的字符
 *
 *  @return true则有非法字符
 */
+ (BOOL)isHaveIllegalChar:(NSString *)str{
    //    if (str) {
    //        return YES;
    //    }
    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"[]{}（#%-*+=）\\|~(＜＞$%^&*) "];
    NSRange range = [str rangeOfCharacterFromSet:doNotWant];
    return range.location<str.length;
}

+ (int)getCurrentTimestamp
{
    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSInteger Timestamp = a;
    return (int)Timestamp;
}


+ (NSString *)getDateByTimestamp:(NSInteger)timestamp type:(NSInteger)timeType
{
    if (timestamp == 0) {
        return nil;
    }
    
    NSTimeInterval time = timestamp;
    NSDate *detaildate =[NSDate dateWithTimeIntervalSince1970:(double)time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    switch (timeType)
    {
        case 0:
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            break;
            
        case 1:
            [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
            break;
            
        case 2:
            [dateFormatter setDateFormat:@"yyyy/MM/dd"];
            break;
            
        case 3:
            [dateFormatter setDateFormat:@"yyyy年MM月"];
            break;
            
        case 4:
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            break;
            
        case 5:
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            break;
            
        case 6:
            [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
            break;
            
        case 7:
            [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
            break;
        case 8:
            [dateFormatter setDateFormat:@"yyMMdd"];
            break;
            
        default:
            break;
    }
    NSString *timeString =  [dateFormatter stringFromDate:detaildate];

    return timeString;
}

+ (NSInteger)timestampToDate:(NSString *)times type:(NSInteger)timeType
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    switch (timeType)
    {
        case 0:
            [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
            break;
            
        case 1:
            [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
            break;
            
        case 2:
            [dateFormatter setDateFormat:@"yyyy/MM/dd"];
            break;
            
        case 3:
            [dateFormatter setDateFormat:@"yyyy年MM月"];
            break;
            
        case 4:
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            break;
            
        case 5:
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            break;
        case 6:
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            break;
        case 7:
            [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
            break;
        case 8:
            [dateFormatter setDateFormat:@"yyMMdd"];
            break;
        default:
            break;
    }
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormatter setTimeZone:timeZone];
    NSDate* date = [dateFormatter dateFromString:times];
    NSTimeInterval a = [date timeIntervalSince1970];
    NSInteger Timestamp = a;
    return Timestamp;
}
/**
 *  计算出用户的年龄
 *
 *  @param compareDate
 *
 *  @return 用户的age int类型
 */
+(NSUInteger)compareHoursWithDate:(NSString *)inputDate{
   NSUInteger compareDate = [self timestampToDate:inputDate type:6];
    compareDate = [self changeMsecToSec:compareDate];
    
//    long long int timeDifference = [self getNowTimestamp] - compareDate;
//    long long int secondTime = timeDifference;
//    long long int minuteTime = secondTime/60;
//    long long int hoursTime =( minuteTime)/60;
//    long long int dayTime = hoursTime/24;
//    long long int monthTime = dayTime/30;
//    long long int yearTime = monthTime/12;
//    
//    if (1 <= yearTime)
//    {
//        return yearTime;
//    }
//    return 0;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];
    
    NSDate *dat = [NSDate dateWithTimeIntervalSince1970:[self getNowTimestamp]];
    int nowDate = [[dateFormatter stringFromDate:dat] intValue];
    
    dat = [NSDate dateWithTimeIntervalSince1970:compareDate];
    int ageDate = [[dateFormatter stringFromDate:dat] intValue];
    
    return (nowDate - ageDate);
    
}
+(NSString *)getUserAge:(long long int)createTimestamp
{
    createTimestamp = [self changeMsecToSec:createTimestamp];
    
    if (createTimestamp == 0) {
        return @"";
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];
    
    NSDate *dat = [NSDate dateWithTimeIntervalSince1970:[self getNowTimestamp]];
    int nowDate = [[dateFormatter stringFromDate:dat] intValue];
    
    dat = [NSDate dateWithTimeIntervalSince1970:createTimestamp];
    int ageDate = [[dateFormatter stringFromDate:dat] intValue];
    
    return [NSString stringWithFormat:@"%d岁",(nowDate - ageDate)];
}
//将毫秒转换为秒
+ (long long int)changeMsecToSec:(long long)timestamp
{
    NSString *timestampStr = [NSString stringWithFormat:@"%lld",timestamp];
    if (timestampStr.length > 10) {
        timestampStr = [timestampStr substringToIndex:10];
    }
    return [timestampStr longLongValue];
}
+(long long int)getNowTimestamp
{
    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a = [dat timeIntervalSince1970] ;
    NSString *timeString = [NSString stringWithFormat:@"%f", a];
    NSString *tempString = nil;
    if ([timeString length] > 10) {
        tempString = [timeString substringToIndex:10];
    } else {
        tempString = [NSString stringWithFormat:@"%@",timeString];
    }
    long long int timeStamp = [tempString longLongValue];
    return timeStamp;
}


+(BOOL)getHairStyleModel{

    return YES;
}



#pragma mark - 文件、路劲
+(NSString *)getDocDir
{
    NSArray *searchPaths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [searchPaths objectAtIndex: 0];
    return documentPath;
}
+(NSString *)getUserDir
{
    NSString *accout = [[NSUserDefaults standardUserDefaults] objectForKey:USER_ACCOUT];
    NSString *docu = [self getDocDir];
    NSString *userDir = [docu stringByAppendingPathComponent:accout];
    if (![[NSFileManager defaultManager] fileExistsAtPath:userDir]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:userDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return userDir;
}

//获取缩略图文件夹路径
+(NSString *)getHeadImageDocDir
{
    NSString *userDir = [self getUserDir];
    NSString *thumbnailDir = [userDir stringByAppendingPathComponent:@"Thumbnail"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:thumbnailDir]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:thumbnailDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return thumbnailDir;
}
/**
 *  头发模型固定的存储路径
 *
 *  @return 
 */
+(NSString *)getHairModelDir
{
    NSString *docu = [self getDocDir];
    NSString *dir = [docu stringByAppendingPathComponent:@"hairModel"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dir]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return dir;
}
/**
 *  根据modelName，在固定存储路径下面建个子路径
 *
 *  @param modelName <#modelName description#>
 *
 *  @return <#return value description#>
 */
+(NSString*)getHairModelDirWithName:(NSString*)modelName{

    NSString *modelDir = [[self getHairModelDir] stringByAppendingPathComponent:modelName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:modelDir]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:modelDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return modelDir;
}

/**
 *  判断是否已有该名称的模型存在试发路径
 *
 *  @param modelName <#modelName description#>
 *
 *  @return <#return value description#>
 */
+(BOOL)isFileExistInHairModelDir:(NSString*)modelName
{
    NSString *modelDir= [[self getHairModelDir] stringByAppendingPathComponent:modelName];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:modelDir]) {
        return YES;
    }
    return NO;
}

// Generates alpha-numeric-random string
+ (NSString *)genRandStringLength:(int)len
{
    static NSString *letters = @"0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    return randomString;
}


/**
 *  图片透明度渐变效果
 */
+ (void)addLinearGradientToView:(UIView *)theView withColor:(UIColor *)theColor transparentToOpaque:(BOOL)transparentToOpaque
{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    
    //the gradient layer must be positioned at the origin of the view
    CGRect gradientFrame = theView.frame;
    gradientFrame.origin.x = 0;
    gradientFrame.origin.y = 0;
    gradient.frame = gradientFrame;
    
    //build the colors array for the gradient
    NSArray *colors = [NSArray arrayWithObjects:
                    (id)[[theColor colorWithAlphaComponent:0.65f] CGColor],
                    (id)[[theColor colorWithAlphaComponent:0.70f] CGColor],
                    (id)[[theColor colorWithAlphaComponent:0.75] CGColor],
                    (id)[[theColor colorWithAlphaComponent:0.80f] CGColor],
                    (id)[[theColor colorWithAlphaComponent:0.98f] CGColor],
                    (id)[theColor CGColor],
                       nil];
    
    //reverse the color array if needed
    if(transparentToOpaque)
    {
        colors = [[colors reverseObjectEnumerator] allObjects];
    }
    
    //apply the colors and the gradient to the view
    gradient.colors = colors;
    
    [theView.layer insertSublayer:gradient atIndex:0];
}

#pragma mark - 验证
+ (BOOL)vefifyPhoneNumber:(NSString *)num
{
    NSString *regex = @"1[3|4|5|7|8|][0-9]{9}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [predicate evaluateWithObject:num];
    return isMatch;
}
@end
