//
//  MDTimer.m
//  shop
//
//  Created by 陈芳 on 2021/12/14.
//

#import "MDTimer.h"

@interface MDTimer ()

@property (nonatomic, strong) dispatch_source_t innerTimer;
@property (nonatomic, assign) NSInteger countdownValue;
@property (nonatomic, assign) NSInteger countValue;
@property (nonatomic, assign) BOOL isFirstTime;

@end
@implementation MDTimer
+ (instancetype)delayWithInterval:(NSTimeInterval)interval block:(void(^)(void))block {
    __weak __block MDTimer *weak_timer = nil;
    
    MDTimer *timer = [MDTimer timerWithInterval:interval block:^(NSInteger value) {
        if (value != 0) {
            if (block) block();
            [weak_timer invalidate];
        }
    }];

    weak_timer = timer;
    return timer;
}

+ (instancetype)timerWithInterval:(NSTimeInterval)interval block:(void (^)(NSInteger value))block {
    __weak __block MDTimer *weak_timer = nil;
    
    MDTimer *timer = [[MDTimer alloc] initWithInterval:interval block:^{
        if (weak_timer.isFirstTime) {
            weak_timer.isFirstTime = NO;
        } else {
            weak_timer.countValue++;
        }
        
        if (block) {
            block(weak_timer.countValue);
        }
    }];
    
    weak_timer = timer;
    timer.countValue = 0;
    timer.isFirstTime = YES;
    
    [timer startTimer];
    return timer;
}

+ (instancetype)countdownTimerWithValue:(NSInteger)beginValue block:(void (^)(NSInteger value))block {
    __weak __block MDTimer *weak_timer = nil;
//    NSLog(@"我的初始值：%ld",beginValue);
    MDTimer *timer = [[MDTimer alloc] initWithInterval:1 block:^{
        if (weak_timer.isFirstTime) {
            weak_timer.isFirstTime = NO;
        } else {
            weak_timer.countdownValue--;
        }
        NSInteger value = weak_timer.countdownValue;
        if (block) {
            block(value);
        }
        
        if (value <= 0) {
            [weak_timer invalidate];
        }
    }];
    weak_timer = timer;
    timer.countdownValue = beginValue;
    timer.isFirstTime = YES;
    [timer startTimer];
    return timer;
}

//+ (instancetype)countdownTimerWithValue:(NSInteger)beginValue withInterval:(CGFloat)interval block:(void (^)(NSInteger value))block {
//    __weak __block MDTimer *weak_timer = nil;
//
//    MDTimer *timer = [[MDTimer alloc] initWithInterval:interval block:^{
//        if (weak_timer.isFirstTime) {
//            weak_timer.isFirstTime = NO;
//        } else {
//            weak_timer.countdownValue = weak_timer.countdownValue - interval;
//        }
//        
//        NSInteger value = weak_timer.countdownValue;
//        
//        if (block) {
//            block(value);
//        }
//        
//        if (value <= 0) {
//            [weak_timer invalidate];
//        }
//    }];
//
//    weak_timer = timer;
//    timer.countdownValue = beginValue;
//    timer.isFirstTime = YES;
//    
//    [timer startTimer];
//    return timer;
//}

- (instancetype)initWithInterval:(NSTimeInterval)interval block:(dispatch_block_t)block {
    self = [super init];
    MDWeakify(self);

    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_source_t innerTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);

    dispatch_source_set_timer(innerTimer, DISPATCH_TIME_NOW, interval * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(innerTimer, ^{
        if (!weak_self.paused) {
            dispatch_async(dispatch_get_main_queue(), block);
        }
    });

    self.innerTimer = innerTimer;
    return self;
}


- (void)startTimer {
    if (self.innerTimer) {
        dispatch_resume(self.innerTimer);
    }
}

- (void)invalidate {
    if (self.innerTimer) {
        NSLog(@"invalidate ------222222");
        dispatch_source_cancel(self.innerTimer);
        self.innerTimer = nil;
    }
}

- (void)dealloc {
    [self invalidate];
}
@end
@implementation MDTimer (Utils)

+ (NSDateComponents *)dateComponentsWithTimeInterval:(NSInteger)value {
    NSInteger hour = 0;
    NSInteger min = 0;
    NSInteger sec = 0;

    if (value >= 3600) {
        hour = value / 3600;
        value = value % 3600;
    }
    if (value > 60) {
        min = value / 60;
        value = value % 60;
    }

    sec = value;

    NSDateComponents *c = [NSDateComponents new];
    c.hour = hour;
    c.minute = min;
    c.second = sec;
    return c;
}

+ (NSString *)timeStringWithTimeInterval:(NSInteger)value {
    NSDateComponents *c = [self dateComponentsWithTimeInterval:value];
    NSString *timeStr = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)c.hour, (long)c.minute, (long)c.second];
    return timeStr;
}
+ (NSString *)timeStringForSecondsWithTimeInterval:(NSInteger)value
{
    NSDateComponents *c = [self dateComponentsWithTimeInterval:value];
    NSString *timeStr = [NSString stringWithFormat:@"%02ld",(long)c.second];
    return timeStr;
}
@end
