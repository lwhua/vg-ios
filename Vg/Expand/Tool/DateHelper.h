//
//  DateHelper.h
//  YSBBusiness
//
//  Created by lu lucas on 20/12/14.
//  Copyright (c) 2014 lu lucas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateHelper : NSObject

+ (NSString *)timeWithDate:(NSDate *)date;

+ (NSString *)yearWithDate:(NSDate *)date;
+ (NSString *)monthWithDate:(NSDate *)date;
+ (NSString *)weekWithDate:(NSString *)date;
+ (NSString *)getDateYearMonthDayString:(NSDate *)date;

/**
 *  将秒数转换为时：分：秒
 *
 *  @param duration <#duration description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)changeDurationToTime:(CGFloat)duration;
/**
 *  更改时间显示格式，使用之后记得更改为默认格式 @"yyyy-MM-dd HH:mm:ss"
 *
 *  @param newFormatter 显示的时间格式
 */
+ (void)changeFormatter:(NSString*)newFormatter;
/**
 *  恢复成默认格式 @"yyyy-MM-dd HH:mm:ss"
 */
+ (void)restoreFormatter;

/**
 *  根据时间间隔 显示不同时间提示
 *
 *  @param time since1970的date描述
 */
+ (NSString *)getDiffrentDateFormatString:(long)time;

@end
