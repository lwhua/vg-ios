//
//  DateHelper.m
//  YSBBusiness
//
//  Created by lu lucas on 20/12/14.
//  Copyright (c) 2014 lu lucas. All rights reserved.
//

#import "DateHelper.h"

static const NSDateFormatter *formatter = nil;

@implementation DateHelper

+ (void)initialize
{
    formatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
}

+ (NSString *)timeWithDate:(NSDate *)date
{
    return [formatter stringFromDate:date];
}

+ (void)changeFormatter:(NSString*)newFormatter{
    
    [formatter setDateFormat:newFormatter];
    
}

+ (void)restoreFormatter{
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
}

+ (NSString *)yearWithDate:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];
    
    return @([dateComponent year]).stringValue;
}

+ (NSString *)monthWithDate:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitMonth;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];
    
    return [NSString stringWithFormat:@"%02ld", (long)[dateComponent month]];
}

+ (NSString *)weekWithDate:(NSString *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitWeekOfMonth;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:[formatter dateFromString:date]];
    
    return @([dateComponent weekOfMonth]).stringValue;
}


+ (NSString *)changeDurationToTime:(CGFloat)duration
{
    NSInteger time = ceilf(duration);
    NSString *hour = [NSString stringWithFormat:@"%02ld", time / 3600];
    NSString *min = [NSString stringWithFormat:@"%02ld", (time - [hour integerValue] * 3600) / 60];
    NSString *sec = [NSString stringWithFormat:@"%02ld", time - [hour integerValue] * 3600 - [min integerValue] * 60];
    return [NSString stringWithFormat:@"%@:%@:%@", hour, min, sec];
}

+ (NSString *)getDateYearMonthDayString:(NSDate *)date {
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy/MM/dd"];
	return [dateFormatter stringFromDate:date];
}

+ (NSString*)getDiffrentDateFormatString:(long)time{
    
    NSInteger _timSpace = [[NSDate date] timeIntervalSince1970] - time;
    
    NSString *_hintStr = nil;
    
    if (_timSpace < 60) {
        
        _hintStr = @"刚刚";
        
    }else if(_timSpace >= 60 && _timSpace < 60* 60){
        
        _hintStr = [NSString stringWithFormat:@"%zd分钟前",_timSpace/60];
        
    }else if(_timSpace >=60*60 && _timSpace < 24* 60 *60){
        
        _hintStr = [NSString stringWithFormat:@"%zd小时前",_timSpace/3600];
        
    }else if(_timSpace >=24*60*60){
        
        _hintStr = [DateHelper timeWithDate:[NSDate dateWithTimeIntervalSince1970:time]];
        
    }
    
    return _hintStr;
    
}

@end
