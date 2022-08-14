//
//  NSDate+MD.m
//  shop
//
//  Created by 陈芳 on 2021/12/20.
//

#import "NSDate+MD.h"

@implementation NSDate (MD)
+ (NSDate *)dl_dateWithDateString:(NSString *)dateString {
    return [self dl_dateWithFormat:@"yyyy-MM-dd" string:dateString];
}

+ (NSDate *)dl_dateWithDateTimeString:(NSString *)dateTimeString {
    return [self dl_dateWithFormat:@"yyyy-MM-dd HH:mm:ss" string:dateTimeString];
}

+ (NSDate *)dl_dateWithFormat:(NSString *)format string:(NSString *)string {
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init] ;
    });
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    formatter.dateFormat = format;
    return [formatter dateFromString:string];
}
+ (NSTimeInterval)dl_dateWithtimeInterva:(NSDate *)date
{
    NSTimeInterval timeInterval = [date timeIntervalSinceNow];//date距离当前时间多久
    return timeInterval;
}

+ (NSInteger)dl_dateWithtimeIntervaStr:(NSDate *)date
{
    NSTimeInterval timeInterval = [date timeIntervalSinceNow];//date距离当前时间多久
    NSString *timeString = [NSString stringWithFormat:@"%d",(int)timeInterval];
    return [timeString integerValue];
}

- (NSString *)dl_dateString {
    return [self dl_stringFormat:@"yyyy-MM-dd"];
}

- (NSString *)dl_dateTimeString {
    return [self dl_stringFormat:@"yyyy-MM-dd HH:mm:ss"];
}

- (NSString *)dl_monthDayString {
    return [self dl_stringFormat:@"MM.dd"];
}

- (NSString *)dl_hourMinuteString {
    return [self dl_stringFormat:@"HH:mm"];
}

- (NSString *)dl_stringFormat:(NSString *)format {
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init] ;
    });
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    formatter.dateFormat = format;
    return [formatter stringFromDate:self];
}

+ (NSTimeInterval)dl_currentTimeStamp {
    return [[NSDate date] timeIntervalSince1970];
}

+ (NSString *)dl_currentTimeStampString {
    return [NSString stringWithFormat:@"%ld", (unsigned long)[[NSDate date] timeIntervalSince1970]];
}

+ (NSString *)dl_currentTimeString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *time = [formatter stringFromDate:[NSDate date]];
    return time;
}


- (NSDateComponents *)dl_unitComponents {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger units  = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |
                       NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday;
    return [calendar components:units fromDate:self];
}


- (NSDate *)dl_startOfCurrentDay {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [self dl_unitComponents];
    
    comps.hour = 0;
    comps.minute = 0;
    comps.second = 0;
    comps.nanosecond = 0;
    comps.weekday = 0;
    comps.weekdayOrdinal = 0;
    
    return [calendar dateFromComponents:comps];
}

- (NSDate *)dl_startOfNextDay {
    return [[self dl_dateByAddingYears:0 months:0 days:1] dl_startOfCurrentDay];
}

- (NSDate *)dl_dateByAddingHours:(NSInteger)hours minutes:(NSInteger)minutes seconds:(NSInteger)seconds {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    comps.hour = hours;
    comps.minute = minutes;
    comps.second = seconds;

    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    return [calender dateByAddingComponents:comps toDate:self options:0];
}

- (NSDate *)dl_dateByAddingYears:(NSInteger)years months:(NSInteger)months days:(NSInteger)days  {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    comps.year = years;
    comps.month = months;
    comps.day = days;

    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    return [calender dateByAddingComponents:comps toDate:self options:0];
}

- (NSDateComponents *)dl_differentUnitsSinceDate:(NSDate *)fromDate components:(NSCalendarUnit)unitFlags {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar components:unitFlags fromDate:fromDate toDate:self options:0];
}


- (NSInteger)dl_differentHoursSinceDate:(NSDate *)fromDate {
    return [self dl_differentUnitsSinceDate:fromDate components:NSCalendarUnitHour].day;
}

- (NSInteger)dl_differentDaysSinceDate:(NSDate *)fromDate {
    return [self dl_differentUnitsSinceDate:fromDate components:NSCalendarUnitDay].day;
}

- (NSInteger)dl_differentCalendarDaysSinceDate:(NSDate *)fromDate {
    NSDate *from;
    NSDate *to;

    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&from interval:NULL forDate:fromDate];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&to interval:NULL forDate:self];

    NSDateComponents *difference = [calendar components:NSCalendarUnitDay fromDate:from toDate:to options:0];
    return [difference day];
}

- (BOOL)dl_isSameDayAs:(NSDate *)date {
    NSDateComponents *c1 = [self dl_unitComponents];
    NSDateComponents *c2 = [date dl_unitComponents];
    return (c1.year == c2.year && c1.month == c2.month && c1.day == c2.day);
}
@end
