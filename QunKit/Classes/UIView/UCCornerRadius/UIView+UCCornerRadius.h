//
//  UIView+UCCornerRadius.h



NS_ASSUME_NONNULL_BEGIN

@interface UIView (UCCornerRadius)
- (void)setCornerRadius:(CGFloat)value addRectCorners:(UIRectCorner)rectCorner;
- (void)setCornerRadius:(CGFloat)value addRectCorners:(UIRectCorner)rectCorner andLineWidth:(CGFloat)lineWidth andStrokeColor:(UIColor *)strokeColor;
@end

NS_ASSUME_NONNULL_END
