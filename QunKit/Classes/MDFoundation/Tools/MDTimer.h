//
//  MDTimer.h
//  shop
//
//  Created by 陈芳 on 2021/12/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MDTimer : NSObject

@property (nonatomic, assign) BOOL paused;                  ///是否暂停

@property (nonatomic, readonly) NSInteger countValue;       ///常规定时器计数
@property (nonatomic, readonly) NSInteger countdownValue;   ///倒计时定时器计数

///单次延迟调用定时器
+ (instancetype)delayWithInterval:(NSTimeInterval)interval block:(void(^)(void))block;

///常规重复定时器
+ (instancetype)timerWithInterval:(NSTimeInterval)interval block:(void (^)(NSInteger value))block;

///倒计时定时器
+ (instancetype)countdownTimerWithValue:(NSInteger)beginValue block:(void (^)(NSInteger value))block;

//+ (instancetype)countdownTimerWithValue:(NSInteger)beginValue withInterval:(CGFloat)interval block:(void (^)(NSInteger value))block;

- (void)invalidate;
@end

@interface MDTimer (Utils)

///秒数->时分秒
+ (NSDateComponents *)dateComponentsWithTimeInterval:(NSInteger)value;
///秒数->01:50:30
+ (NSString *)timeStringWithTimeInterval:(NSInteger)value;
///格式化只剩下秒-> 0s
+ (NSString *)timeStringForSecondsWithTimeInterval:(NSInteger)value;

@end

NS_ASSUME_NONNULL_END
