//
//  CommonHelper.m
//  YSBBusiness
//
//  Created by jackyshan on 12/8/14.
//  Copyright (c) 2014 lu lucas. All rights reserved.
//

#import "CommonHelper.h"
#import "MBProgressHUD.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "NSString+Base64.h"
#import <CoreLocation/CLLocationManager.h>
#import "InputHelper.h"

@implementation CommonHelper

+ (NSString *)getFileSizeString:(NSString *)size {
	if ([size floatValue] >= 1024 * 1024) {//大于1M，则转化成M单位的字符串
		return [NSString stringWithFormat:@"%1.2fM", [size floatValue] / 1024 / 1024];
	}
	else if ([size floatValue] >= 1024 && [size floatValue] < 1024 * 1024) { //不到1M,但是超过了1KB，则转化成KB单位
		return [NSString stringWithFormat:@"%1.2fK", [size floatValue] / 1024];
	}
	else {//剩下的都是小于1K的，则转化成B单位
		return [NSString stringWithFormat:@"%1.2fB", [size floatValue]];
	}
}

+ (float)getFileSizeNumber:(NSString *)size {
	NSInteger indexM = [size rangeOfString:@"M"].location;
	NSInteger indexK = [size rangeOfString:@"K"].location;
	NSInteger indexB = [size rangeOfString:@"B"].location;
	if (indexM < 1000) {//是M单位的字符串
		return [[size substringToIndex:indexM] floatValue] * 1024 * 1024;
	}
	else if (indexK < 1000) {//是K单位的字符串
		return [[size substringToIndex:indexK] floatValue] * 1024;
	}
	else if (indexB < 1000) {//是B单位的字符串
		return [[size substringToIndex:indexB] floatValue];
	}
	else {//没有任何单位的数字字符串
		return [size floatValue];
	}
}

+ (NSString *)getDocumentPath {
	return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}

+ (NSString *)getLibraryPath {
	return [NSHomeDirectory() stringByAppendingPathComponent:@"Library"];
}

+ (NSString *)getCachesPath {
	return [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
}

+ (NSString *)getDownloadRelativePath:(NSString *)str {
	return [@"videoDownload" stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4", str]];
}

+ (BOOL)deleteDownloadFile:(NSString *)str {
	NSString *deletePath = [[CommonHelper getCachesPath] stringByAppendingPathComponent:str];
	NSFileManager *fileManager = [NSFileManager defaultManager];

	BOOL res = [fileManager removeItemAtPath:deletePath error:nil];
	if (res) {
		NSLog(@"文件删除成功");
	}
	else
		NSLog(@"文件删除失败");

	return res;
}

+ (NSString *)getDownloadSavePath:(NSString *)relativePath {
	NSString *str = [relativePath substringToIndex:[relativePath rangeOfString:@"/"].location];
	NSString *savePath = [[CommonHelper getCachesPath] stringByAppendingPathComponent:str];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if (![fileManager fileExistsAtPath:savePath]) {
		BOOL res = [fileManager createDirectoryAtPath:savePath withIntermediateDirectories:YES attributes:nil error:nil];

		if (res) {
			NSLog(@"videoDownload创建成功: %@", savePath);
		}
		else {
			NSLog(@"videoDownload创建失败");
		}
	}

	return [[CommonHelper getCachesPath] stringByAppendingPathComponent:relativePath];
}

+ (unsigned long long)getCacheFileSize:(NSString *)tempFilePath {
	NSFileManager *fileManager = [NSFileManager defaultManager];

	if ([fileManager fileExistsAtPath:tempFilePath]) {
		unsigned long long fileSize = [[fileManager attributesOfItemAtPath:tempFilePath
		                                                             error:nil]
		                               fileSize];
		return fileSize;
	}

	return 0;
}

+ (NSString *)getCacheFileSizeString:(NSString *)relativePath {
	CGFloat length = [CommonHelper getCacheFileSize:[CommonHelper getDownloadSavePath:relativePath]];
	return [CommonHelper getFileSizeString:[NSString stringWithFormat:@"%f", length]];
}

+ (NSString *)getPercentString:(CGFloat)progress {
	NSString *percentStr = [NSString stringWithFormat:@"%.f%%", progress * 100];

	return percentStr;
}

/**
 * 计算指定时间与当前的时间差
 * @param compareDate   某一指定时间的时间戳
 * @return 多少(秒or分or天or月or年)+前 (比如，3天前、10分钟前)
 */
+ (NSString *)compareCurrentTime:(NSTimeInterval)compareInterval {
	NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
	NSTimeInterval now =  [dat timeIntervalSince1970];
//    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
//    timeInterval = -timeInterval;
	NSTimeInterval timeInterval = now - compareInterval;
	long temp = 0;
	NSString *result;
	if (timeInterval < 60) {
		result = [NSString stringWithFormat:@"刚刚"];
	}
	else if ((temp = timeInterval / 60) < 60) {
		result = [NSString stringWithFormat:@"%@分前", @(temp)];
	}

	else if ((temp = temp / 60) < 24) {
		result = [NSString stringWithFormat:@"%@小前", @(temp)];
	}

	else if ((temp = temp / 24) < 30) {
		result = [NSString stringWithFormat:@"%@天前", @(temp)];
	}

	else if ((temp = temp / 30) < 12) {
		result = [NSString stringWithFormat:@"%@月前", @(temp)];
	}
	else {
		temp = temp / 12;
		result = [NSString stringWithFormat:@"%@年前", @(temp)];
	}

	return result;
}

+ (NSString *)getDateSecondString:(NSDate *)date {
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
	return [dateFormatter stringFromDate:date];
}

+ (NSString *)getDateDayString:(NSDate *)date {
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy/MM/dd"];
	return [dateFormatter stringFromDate:date];
}

+ (NSString *)getDateMonthString:(NSDate *)date {
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy/MM"];
	return [dateFormatter stringFromDate:date];
}

+ (void)showLongMessage:(UIView *)view message:(NSString *)str
{
    [self _showMessage:view message:str time:3.0f];
}

+ (void)showMessage:(UIView *)view message:(NSString *)str
{
    [self _showMessage:view message:str time:1.0f];
}

+ (void)_showMessage:(UIView *)view message:(NSString *)str time:(NSInteger)time {
	UIWindow *_keyWindow = [[UIApplication sharedApplication] keyWindow];
	[MBProgressHUD hideAllHUDsForView:_keyWindow animated:NO];
	[MBProgressHUD hideAllHUDsForView:view animated:NO];
	UIView *_parentView = view;
	if (!_parentView) {
		_parentView = _keyWindow;
	}

	MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:_parentView animated:YES];
	hud.mode = MBProgressHUDModeText;
	hud.margin = 10.f;
	hud.labelText = str;
	hud.removeFromSuperViewOnHide = YES;
	[hud hide:YES afterDelay:time];
}



+ (NSString *)getCouponStatus:(NSInteger)status {
	switch (status) {
		case 1:
			return @"已经激活";

		case 2:
			return @"立即使用";

		case 3:
			return @"已经使用";

		case 4:
			return @"已过期";

		default:
			return @"";
			break;
	}
}

+ (NSString *)getCarrierName:(NSString *)phoneNum {
	/**
	 * 中国移动
	 * 134[0-8],135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,178
	 */
	NSString *CM = @"^1(34[0-8]|(3[5-9]|5[0-27-9]|8[2-478]|78)\\d)\\d{7}$";
	/**
	 * 中国联通
	 * 130,131,132,155,156,185,186,176
	 */
	NSString *CU = @"^1(3[0-2]|5[56]|8[56]|76)\\d{8}$";
	/**
	 * 中国电信
	 * 133,1349,153,180,189
	 */
	NSString *CT = @"^1((33|53|8[019]|77))\\d{8}$";
	/**
	 * 虚拟运营商
	 */
	NSString *VC = @"^170\\d{8}$";


	NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
	NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
	NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
	NSPredicate *regextestvc = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", VC];

	if ([regextestcm evaluateWithObject:phoneNum]) {
		return @"中国移动";
	}
	else if ([regextestcu evaluateWithObject:phoneNum]) {
		return @"中国联通";
	}
	else if ([regextestct evaluateWithObject:phoneNum]) {
		return @"中国电信";
	}
	else if ([regextestvc evaluateWithObject:phoneNum]) {
		return @"虚拟运营商";
	}

	return nil;
}

+ (NSString *)getBase64CodeFromImage:(UIImage *)image {
	NSData *_imgData = UIImageJPEGRepresentation(image, 0.7);
	NSString *_base64String = [_imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];

	return _base64String;
}

+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size {
	CGFloat width = img.size.width;
	CGFloat height = img.size.height;
	// 缩放因子
	CGFloat scale = 0;
	if (width <= height) {
		scale = width / size.width;
	}
	else {
		scale = height / size.width;
	}

	size = CGSizeMake(width / scale, height / scale);
	// 创建一个bitmap的context
	// 并把它设置成为当前正在使用的context
	UIGraphicsBeginImageContext(size);
	// 绘制改变大小的图片
	[img drawInRect:CGRectMake(0, 0, size.width, size.height)];
	// 从当前context中创建一个改变大小后的图片
	UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
	// 使当前的context出堆栈
	UIGraphicsEndImageContext();
	// 返回新的改变大小后的图片
	return scaledImage;
}

+ (void)playSoundPathForResource:(NSString *)resource ofType:(NSString *)type {
	NSString *path = [NSString stringWithFormat:@"/System/Library/Audio/UISounds/%@.%@", resource, type];
	if (path) {
		NSURL *url = [NSURL fileURLWithPath:path];
		SystemSoundID soundId;
		AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundId);
		AudioServicesPlaySystemSound(soundId);
	}

//     取声音里列表
//        NSFileManager *fm = [NSFileManager defaultManager];
//        NSArray *files = [fm subpathsAtPath: @"/System/Library/Audio/UISounds"];
//        NSLog(@"%@", files);
}

+ (void)playShake {
	SystemSoundID soundId = kSystemSoundID_Vibrate;
	AudioServicesPlaySystemSound(soundId);
}

+ (LOAD_TYPE)isFirstLoad {
	NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *lastRunVersion = [defaults objectForKey:@"last_run_version_of_application"];

	if (!lastRunVersion) {
		[defaults setObject:currentVersion forKey:@"last_run_version_of_application"];
		[defaults synchronize];
		return LOAD_TYPE_TOTALLY_FIRST;
		// App is being run for first time
	}
	else if (![lastRunVersion isEqualToString:currentVersion]) {
		[defaults setObject:currentVersion forKey:@"last_run_version_of_application"];
		[defaults synchronize];
		return LOAD_TYPE_VERSION_FIRST;
		// App has been updated since last run
	}
	return LOAD_TYPE_NOT_FIRST;
}

//邮箱
+ (BOOL)validateEmail:(NSString *)email {
	NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
	return [emailTest evaluateWithObject:email];
}

//手机号码验证
+ (BOOL)validateMobile:(NSString *)mobile {
	//手机号以13， 15，18开头，八个 \d 数字字符
	NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9])|(147)|(17[0-9]))\\d{8}$";
	NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
	return [phoneTest evaluateWithObject:mobile];
}

//用户名
+ (BOOL)validateUserName:(NSString *)name {
	NSString *userNameRegex = @"^[A-Za-z0-9]{4,20}+$";
	NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", userNameRegex];
	BOOL B = [userNamePredicate evaluateWithObject:name];
	return B;
}

//昵称
+ (BOOL)validateNickname:(NSString *)nickname {
	NSString *nicknameRegex = @"([\u4e00-\u9fa5]{2,5})(&middot;[\u4e00-\u9fa5]{2,5})*";
	NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nicknameRegex];
	return [passWordPredicate evaluateWithObject:nickname];
}

//身份证号
+ (BOOL)validateIdentityCard:(NSString *)identityCard {
	BOOL flag;
	if (identityCard.length <= 0) {
		flag = NO;
		return flag;
	}
	NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
	NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex2];
	return [identityCardPredicate evaluateWithObject:identityCard];
}

//银行卡
+ (BOOL)validateBankCardNumber:(NSString *)bankCardNumber {
	BOOL flag;
	if (bankCardNumber.length <= 0) {
		flag = NO;
		return flag;
	}
	NSString *regex2 = @"^(\\d{15,30})";
	NSPredicate *bankCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex2];
	return [bankCardPredicate evaluateWithObject:bankCardNumber];
}

//银行卡后四位
+ (BOOL)validateBankCardLastNumber:(NSString *)bankCardNumber {
	BOOL flag;
	if (bankCardNumber.length != 4) {
		flag = NO;
		return flag;
	}
	NSString *regex2 = @"^(\\d{4})";
	NSPredicate *bankCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex2];
	return [bankCardPredicate evaluateWithObject:bankCardNumber];
}

//CVN
+ (BOOL)validateCVNCode:(NSString *)cvnCode {
	BOOL flag;
	if (cvnCode.length <= 0) {
		flag = NO;
		return flag;
	}
	NSString *regex2 = @"^(\\d{3})";
	NSPredicate *cvnCodePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex2];
	return [cvnCodePredicate evaluateWithObject:cvnCode];
}

+ (NSInteger)validateUserStateByPosition:(NSInteger)position status:(NSInteger)status {
	//return 0:未确定 1:店员 2:店长
	//@param position  身份：0:店员 1:店长
	//@param status 0:离职 1 在职 3 待审核 4 审核未通过 5 放弃审核


	if (position == 0 && (status == 1 || status == 2)) {
		//店员
		return 1;
	}
	if (position == 1 && status != 1) {
		//申请店长的店员
		return 1;
	}

	if (position == 1 && status == 1) {
		//正式店长
		return 2;
	}

	return 0;
}

+ (NSString *)createCUID {
	NSString *result;
	CFUUIDRef uuid;
	CFStringRef uuidStr;
	uuid = CFUUIDCreate(NULL);
	uuidStr = CFUUIDCreateString(NULL, uuid);
	result = [NSString stringWithFormat:@"%@", uuidStr];
	CFRelease(uuidStr);
	CFRelease(uuid);
	return result;
}

+ (AppType)checkAppType {
	NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
	if ([infoDictionary[@"CFBundleIdentifier"] rangeOfString:@"Test"].location != NSNotFound) {
		return AppTypeTest;
	}
	if ([infoDictionary[@"CFBundleIdentifier"] rangeOfString:@"Enterprise"].location != NSNotFound) {
		return AppTypeEnterprise;
	}
	return AppTypeNormal;
}

+ (BOOL)checkIsEmoji:(NSString *)str {
	NSString *regex2 = [NSString stringWithFormat:@"^[\\ud83c\\udc00-\\ud83c\\udfff]|[\\ud83d\\udc00-\\ud83d\\udfff]|[\\u2600-\\u27ff]"];
	NSPredicate *bankCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex2];
	return [bankCardPredicate evaluateWithObject:str];
}

+ (BOOL)checkIsAllNumber:(NSString *)str {
	NSString *regex2 = [NSString stringWithFormat:@"^\\d{%ld}", (unsigned long)str.length];
	NSPredicate *bankCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex2];
	return [bankCardPredicate evaluateWithObject:str];
}

+ (BOOL)checkIsAllLetter:(NSString *)str {
	NSString *regex2 = [NSString stringWithFormat:@"^[a-zA-Z]{%ld}", (unsigned long)str.length];
	NSPredicate *bankCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex2];
	return [bankCardPredicate evaluateWithObject:str];
}

+ (NSString *)generateRandomLetter:(NSInteger)number {
	char data[number];
	for (int i = 0; i < number; i++) {
		data[i] = ('A' + (arc4random_uniform(26)));
	}
	NSString *dataPoint = [[NSString alloc] initWithBytes:data length:number encoding:NSUTF8StringEncoding];
	return dataPoint;
}

+ (NSString *)encryptPassword:(NSString *)oldPW {
	NSString *string = [NSString stringWithFormat:@"%@%@%@", [CommonHelper generateRandomLetter:3], oldPW, [CommonHelper generateRandomLetter:4]];
	NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
	string = [NSString base64StringFromData:data length:data.length];
	string = [NSString stringWithFormat:@"%@%@", [CommonHelper generateRandomLetter:2], string];
	data = [string dataUsingEncoding:NSUTF8StringEncoding];
	string = [NSString base64StringFromData:data length:data.length];
	return string;
}

+ (BOOL)isCameraAuthorized {
	if ([AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo].count) {
		// iOS7.0及以上
		int status = (int)[[AVCaptureDevice class] performSelector:@selector(authorizationStatusForMediaType:)
		                                                withObject:AVMediaTypeVideo];
		return (status == 3 /* AVAuthorizationStatusAuthorized */);
	}
	return NO;
}

+ (BOOL)isLocationAuthorized {
	if (![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
		return NO;
	}

	return YES;
}

+ (CLLocationDistance)distanceBetweenlat1:(CLLocationDegrees)latitude1
                                     lng1:(CLLocationDegrees)longitude1
                                     lat2:(CLLocationDegrees)latitude2
                                     lng2:(CLLocationDegrees)longitude2 {
	CLLocationCoordinate2D coordinate1 = CLLocationCoordinate2DMake(latitude1, longitude1);
	CLLocation *location1 = [[CLLocation alloc] initWithCoordinate:coordinate1 altitude:0 horizontalAccuracy:0 verticalAccuracy:0 course:0 speed:0 timestamp:[NSDate date]];


	CLLocationCoordinate2D coordinate2 = CLLocationCoordinate2DMake(latitude2, longitude2);
	CLLocation *location2 = [[CLLocation alloc] initWithCoordinate:coordinate2 altitude:0 horizontalAccuracy:0 verticalAccuracy:0 course:0 speed:0 timestamp:[NSDate date]];

	return [location1 distanceFromLocation:location2];
}

+ (NSURL *)mediaCacheDirectory {
	NSURL *url = [[NSFileManager defaultManager] URLForDirectory:NSLibraryDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
	NSURL *cacheDirectory = [url URLByAppendingPathComponent:@"ysb" isDirectory:YES];

	if (NO == [[NSFileManager defaultManager] fileExistsAtPath:cacheDirectory.path]) {
		[[NSFileManager defaultManager] createDirectoryAtURL:cacheDirectory withIntermediateDirectories:YES attributes:nil error:nil];
	}

	return cacheDirectory;
}

+ (NSInteger)audioDurationWithUrl:(NSURL *)url {
	AVAudioPlayer *avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
	CGFloat duration = avPlayer.duration;
	avPlayer = nil;
	return (NSInteger)duration;
}

+ (NSDictionary *)dictionaryWithContentsOfJSONString:(NSString *)fileLocation {
	NSString *filePath = [[NSBundle mainBundle] pathForResource:[fileLocation stringByDeletingPathExtension] ofType:@"json"];
	NSData *data = [NSData dataWithContentsOfFile:filePath];
	__autoreleasing NSError *error = nil;
	id result = [NSJSONSerialization JSONObjectWithData:data
	                                            options:kNilOptions error:&error];
	// Be careful here. You add this as a category to NSDictionary
	// but you get an id back, which means that result
	// might be an NSArray as well!
	if (error != nil) return nil;
	return result;
}

+ (UIView *)configureNoDataTipsViewInView:(UIView *)view tips:(NSString *)tips {
	UIView *noDataBgView = [[UIView alloc]initWithFrame:view.bounds];

//	UILabel *tipsLbl = [InputHelper createLabelWithFrame:CGRectMake(10.0f, noDataBgView.height / 2 - 20.0f, noDataBgView.width - 2 * 10.0f, 20.0f) title:tips textColor:COLOR_646464 bgColor:COLOR_CLEAR fontSize:14.0f textAlignment:NSTextAlignmentCenter addToView:noDataBgView bBold:NO];
//	[tipsLbl setTag:kNoDataTipsLblTag];
	return noDataBgView;
}

+ (NSString *)replaceUnicodeToUTF8:(NSString *)aUnicodeString
{
    
    NSString *tempStr1 = [aUnicodeString stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}

+ (BOOL)validateName:(NSString *)name
{
    
    if (name == nil
        || [name isEqualToString:@""]) {
        return NO;
    }
    

    if ([name length] < 2) {


        return NO;
    }
    
    for (int i = 0; i < [name length]; i++) {
        int a = [name characterAtIndex:i];
        if (a < 0x4e00 || a > 0x9fff) {


            return NO;
        }
    }
    
    return YES;
}

+ (CGRect)convertToWindow:(UIView *)view {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    return [view convertRect:view.bounds toView:window];
}

+ (BOOL)validateUrl:(NSString *)url {
    NSString *regex2 = @"[a-zA-z]+://[^\\s]*";
    
    NSPredicate *urlPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex2];
    return [urlPredicate evaluateWithObject:url];
}

@end
