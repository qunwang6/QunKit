//
//  NSDate+MD.h
//  shop
//
//  Created by 陈芳 on 2021/12/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (MD)
///"2021-02-01" -> NSDate
+ (NSDate *_Nullable)dl_dateWithDateString:(NSString *)dateString;
///"2021-02-01 16:30:00" -> NSDate
+ (NSDate *_Nullable)dl_dateWithDateTimeString:(NSString *)dateTimeString;
///指定的格式 -> NSDate
+ (NSDate *_Nullable)dl_dateWithFormat:(NSString *)format string:(NSString *)string;
///nsdate转时间戳
+ (NSTimeInterval)dl_dateWithtimeInterva:(NSDate *)date;

+ (NSInteger)dl_dateWithtimeIntervaStr:(NSDate *)date;

///"2021-02-01"
- (NSString *)dl_dateString;
///"2021-02-01 16:30:00"
- (NSString *)dl_dateTimeString;
///"02.01"
- (NSString *)dl_monthDayString;
///"16:30"
- (NSString *)dl_hourMinuteString;
///指定的格式
- (NSString *_Nullable)dl_stringFormat:(NSString *)format;



///当前的时间戳
+ (NSTimeInterval)dl_currentTimeStamp;
///当前的时间戳字符串
+ (NSString *)dl_currentTimeStampString;

+ (NSString *)dl_currentTimeString;

///NSDate->unit（年/月/日/时/分/秒）
- (NSDateComponents *)dl_unitComponents;



///操作NSDate，加上指定的unit偏移量（年/月/日/时/分/秒）
- (NSDate *)dl_dateByAddingYears:(NSInteger)years months:(NSInteger)months days:(NSInteger)days;
- (NSDate *)dl_dateByAddingHours:(NSInteger)hours minutes:(NSInteger)minutes seconds:(NSInteger)seconds;

///返回当天0点0分0秒的NSDate
- (NSDate *)dl_startOfCurrentDay;
///返回第二天0点0分0秒NSDate
- (NSDate *)dl_startOfNextDay;



///返回两个NSDate之间的指定unit差值（年/月/日/时/分/秒）
- (NSDateComponents *)dl_differentUnitsSinceDate:(NSDate *)fromDate components:(NSCalendarUnit)unitFlags;

///小时差
- (NSInteger)dl_differentHoursSinceDate:(NSDate *)fromDate;
///真实天数差（超过24小时才算1天）
- (NSInteger)dl_differentDaysSinceDate:(NSDate *)fromDate;
///日历上的天数差（只要跨天就算1天）
- (NSInteger)dl_differentCalendarDaysSinceDate:(NSDate *)fromDate;



///判断是否是同一天
- (BOOL)dl_isSameDayAs:(NSDate *)date;

@end

NS_ASSUME_NONNULL_END
