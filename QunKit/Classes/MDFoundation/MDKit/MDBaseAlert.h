//
//  MDBaseAlert.h
//  shop
//
//  Created by 陈芳 on 2021/12/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/**
 弹窗基类，会自己显示遮罩。
 如果有完整的高度约束，则弹窗高度会自适应，否则使用xib里的高度。
 如果同时有多个弹窗弹出，则会按顺序挨个展示。
 */

@interface MDBaseAlert : UIView
///显示弹窗，默认加到window上
+ (instancetype)show;
///显示弹窗，加到指定view上面
+ (instancetype)showInView:(UIView *)parentView;

///隐藏弹窗（可通过xib直接连线）
- (IBAction)dismiss;

@end


@interface MDBaseAlert (Override)


///弹窗体，默认从同名xib里读取（子类可重写返回自定义View）
+ (instancetype)bodyView;

///弹窗体圆角，默认为8（子类可重写）
+ (CGFloat)bodyCornerRadius;

///弹窗体距离屏幕左右边界的距离，默认弹窗体的宽度为bodyView的宽度（子类可重写来自适应屏幕宽度）
+ (CGFloat)bodyMarginToEdge;

///弹窗体相对相对屏幕中心的偏移量，默认为(0,0)（子类可重写）
+ (CGPoint)bodyCenterOffset;

///遮罩颜色，默认黑色半透明（子类可重写）
+ (UIColor *)maskColor;

///是否支持点击遮罩隐藏，默认为NO（子类可重写）
+ (BOOL)supportsTapToDismiss;

///当同时存在多个弹窗时，是否按顺序一个一个弹出，默认为YES
+ (BOOL)showInOrder;

@end

NS_ASSUME_NONNULL_END
