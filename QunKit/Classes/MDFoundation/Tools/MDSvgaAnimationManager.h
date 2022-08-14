//
//  MDSvgaAnimationManager.h
//  shop
//
//  Created by 陈芳 on 2022/1/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MDSvgaAnimationManager : NSObject

@property (nonatomic, strong) UIView *svgaPlayerView;
@property (nonatomic, assign) int loops;
@property (nonatomic, strong) void(^completionHandler)(void);
- (void)showAnimation:(NSString *)svgaName;
- (void)stopAnimation;

- (void)pauseAnimate;
- (void)startAnimate;
    
- (void)showAnimation:(NSString *)svgaName withFrame:(CGRect)frame;
- (void)reSetFrame:(CGRect)frame;
@end

NS_ASSUME_NONNULL_END
