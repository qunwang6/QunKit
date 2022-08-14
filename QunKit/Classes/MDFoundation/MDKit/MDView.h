//
//  MDView.h
//  shop
//
//  Created by 陈芳 on 2021/12/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MDGradientDirection) {
    MDGradientDirectionTopToBottom              = 0,    //从上到下（默认）
    MDGradientDirectionLeftToRight              = 1,    //从左到右
    MDGradientDirectionTopLeftToBottomRight     = 2,    //从左上到右下
    MDGradientDirectionBottomLeftToTopRight     = 3,    //从左下到右上
};

@interface MDView : UIView
///设置渐变背景
- (void)setGradientBackgroundWithStartColor:(UIColor *_Nullable)startColor endColor:(UIColor *_Nullable)endColor direction:(MDGradientDirection)direction;
- (void)setGradientBackgroundColors:(NSArray *_Nullable)colors locations:(NSArray *_Nullable)locations direction:(MDGradientDirection)direction;

@end


#pragma mark - 链式访问

@interface MDView (DLChain)

@property (nonatomic, readonly) MDView *(^bg)(id color);                            //backgroundColor

@property (nonatomic, readonly) MDView *(^radius)(CGFloat cornerRadius);            //cornerRadius + masksToBounds
@property (nonatomic, readonly) MDView *(^border)(CGFloat width, id color);         //borderWidth + boderColor

@property (nonatomic, readonly) MDView *(^pinWH)(CGFloat width, CGFloat height);    //设置宽高约束, 传NAN表示不设置

@end

NS_ASSUME_NONNULL_END
