//
//  CommonHelper.h
//  YSBBusiness
//
//  Created by jackyshan on 12/8/14.
//  Copyright (c) 2014 lu lucas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#define kNoDataTipsLblTag 665544

typedef NS_ENUM (NSInteger, LOAD_TYPE) {
	LOAD_TYPE_TOTALLY_FIRST = 0,
	LOAD_TYPE_VERSION_FIRST,
	LOAD_TYPE_NOT_FIRST
};

typedef NS_ENUM (NSInteger, AppType) {
	AppTypeNormal = 0,
	AppTypeEnterprise,
	AppTypeTest
};

@interface CommonHelper : NSObject

/**
 *  将文件大小转化成M单位或者B单位
 */
+ (NSString *)getFileSizeString:(NSString *)size;

/**
 *  经文件大小转化成不带单位ied数字
 */
+ (float)getFileSizeNumber:(NSString *)size;

/**
 *  Document路径
 */
+ (NSString *)getDocumentPath;

/**
 *  Library路径
 */
+ (NSString *)getLibraryPath;

/**
 *  Caches路径
 */
+ (NSString *)getCachesPath;

/**
 *  downloadFile相对路径
 */
+ (NSString *)getDownloadRelativePath:(NSString *)str;

/**
 *  删除downloadFile
 */
+ (BOOL)deleteDownloadFile:(NSString *)str;

/**
 *  downloadFile保存绝对路径
 */
+ (NSString *)getDownloadSavePath:(NSString *)relativePath;

/**
 *  CacheFileSize
 *
 *  @param tempFilePath 缓存文件大小 绝对路径
 *
 *  @return CacheFileSize
 */
+ (unsigned long long)getCacheFileSize:(NSString *)tempFilePath;

/**
 *  CacheFileSize string值
 *
 *  @param relativePath 缓存文件大小 相对路径
 *
 *  @return CacheFileSize
 */
+ (NSString *)getCacheFileSizeString:(NSString *)relativePath;

/**
 *  百分比string
 *
 *  @param progress progress
 *
 *  @return 百分比
 */
+ (NSString *)getPercentString:(CGFloat)progress;

/**
 * 计算指定时间与当前的时间差
 * @param compareDate   某一指定时间
 * @return 多少(秒or分or天or月or年)+前 (比如，3天前、10分钟前)
 */
+ (NSString *)compareCurrentTime:(NSTimeInterval)compareInterval;

/**
 *  获取日期字符串2014/10/11 11:11
 *
 *  @param date 日期
 *
 *  @return 字符串
 */
+ (NSString *)getDateSecondString:(NSDate *)date;

/**
 *  获取日期字符串2014/10/11
 *
 *  @param date 日期
 *
 *  @return 字符串
 */
+ (NSString *)getDateDayString:(NSDate *)date;

/**
 *  获取日期字符串2014/10
 *
 *  @param date 日期
 *
 *  @return 字符串
 */
+ (NSString *)getDateMonthString:(NSDate *)date;

/**
 *  弹出提醒框
 *
 *  @param str 提醒信息
 */
+ (void)showMessage:(UIView *)view message:(NSString *)str;
+ (void)showLongMessage:(UIView *)view message:(NSString *)str;

/**
 *  获得现金券状态
 *
 *  @param status 类型
 *
 *  @return str
 */
+ (NSString *)getCouponStatus:(NSInteger)status;

/**
 *  获取运营商名称 非法的格式返回nil
 *
 *  @param phoneNum 需要检测的手机号
 *
 *  @return 运营商名称 中国联通、中国移动、中国电信、nil
 */
+ (NSString *)getCarrierName:(NSString *)phoneNum;

/**
 *  获取图片Base64位编码
 *
 *  @param image 要进行编码的图片
 *
 *  @return 编码后的字符串
 */
+ (NSString *)getBase64CodeFromImage:(UIImage *)image;

+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;

/**
 *  播放声音
 *
 *  @param resource 声音
 *  @param type     声音的格式
 */
+ (void)playSoundPathForResource:(NSString *)resource ofType:(NSString *)type;
+ (void)playShake;

+ (LOAD_TYPE)isFirstLoad;

/**
 *  是否邮箱
 *
 *  @param email <#email description#>
 *
 *  @return <#return value description#>
 */
+ (BOOL)validateEmail:(NSString *)email;

/**
 *  是否银行卡
 *
 *  @param bankCardNumber 银行卡号
 *
 *  @return 是否
 */
+ (BOOL)validateBankCardNumber:(NSString *)bankCardNumber;

/**
 *  是否姓名
 *
 *  @param nickname 姓名
 *
 *  @return 是否
 */
+ (BOOL)validateNickname:(NSString *)nickname;

/**
 *  是否身份证
 *
 *  @param identityCard 身份证
 *
 *  @return 是否
 */
+ (BOOL)validateIdentityCard:(NSString *)identityCard;

/**
 *  是否手机号
 *
 *  @param mobile 手机号
 *
 *  @return 是否
 */
+ (BOOL)validateMobile:(NSString *)mobile;
/**
 *  用户身份
 *
 *  @param position  身份：0:店员 1:店长
 *  @param status 0:离职 1 在职 3 待审核 4 审核未通过 5 放弃审核
 *
 *  @return 0:未确定 1:店员 2:店长
 */

+ (NSInteger)validateUserStateByPosition:(NSInteger)position status:(NSInteger)status;

/**
 *  生成宇宙随机码
 */
+ (NSString *)createCUID;
// 是否企业版
+ (AppType)checkAppType;

/**
 *  检查是不是emoji
 *
 *  @param str <#str description#>
 *
 *  @return <#return value description#>
 */
+ (BOOL)checkIsEmoji:(NSString *)str;

/**
 *  检查是否str都是数字
 */
+ (BOOL)checkIsAllNumber:(NSString *)str;
/**
 *  检查是否str都是字母
 */
+ (BOOL)checkIsAllLetter:(NSString *)str;
/**
 *  生成随机字母串
 *
 *  @param number 字母长度
 *
 *  @return 字符串
 */
+ (NSString *)generateRandomLetter:(NSInteger)number;
/**
 *  密码加密传输
 */
+ (NSString *)encryptPassword:(NSString *)oldPW;


/**
 *  检测用户是否授权使用相机
 */

+ (BOOL)isCameraAuthorized;

+ (BOOL)isLocationAuthorized;

/**
 *  两个坐标点的距离
 */
+ (CLLocationDistance)distanceBetweenlat1:(CLLocationDegrees)latitude1
                                     lng1:(CLLocationDegrees)longitude1
                                     lat2:(CLLocationDegrees)latitude2
                                     lng2:(CLLocationDegrees)longitude2;


/**
 *  聊天语音和图片的本地缓存目录
 *
 *  @return
 */
+ (NSURL *)mediaCacheDirectory;

/**
 *  计算音频时长
 *
 *  @return
 */
+ (NSInteger)audioDurationWithUrl:(NSURL *)url;

/**
 * 从json文件中读取Dictionary
 */

+ (NSDictionary *)dictionaryWithContentsOfJSONString:(NSString *)fileLocation;


/**
 * 构造无数据显示时TableView 的沉底提示
 */

+ (UIView *)configureNoDataTipsViewInView:(UIView *)view tips:(NSString *)tips;


+ (NSString *)replaceUnicodeToUTF8:(NSString *)aUnicodeString;

/**
 *  验证名字是否含有两位以上汉字
 *
 *  @param name 名字
 *
 *  @return bool
 */
+ (BOOL)validateName:(NSString *)name;

/**
 *  在当前window中的绝对位置
 *
 *  @param view 要转换的view
 *
 *  @return cgrect
 */
+ (CGRect)convertToWindow:(UIView *)view;

/**
 *  验证url是否正确
 *
 *  @param url url
 *
 *  @return bool
 */
+ (BOOL)validateUrl:(NSString *)url;

@end
