//
//  UIView+UCCornerRadius.m


#import "UIView+UCCornerRadius.h"


@implementation UIView (UCCornerRadius)
/**
 * setCornerRadius   给view设置圆角
 * @param value      圆角大小
 * @param rectCorner 圆角位置
 **/
- (void)setCornerRadius:(CGFloat)value addRectCorners:(UIRectCorner)rectCorner{
    [self layoutIfNeeded];//这句代码很重要，不能忘了
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:rectCorner cornerRadii:CGSizeMake(value, value)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = path.CGPath;
    self.layer.mask = maskLayer;
  
}
/**
* setCornerRadius   给view设置圆角
* @param value      圆角大小
* @param rectCorner 圆角位置
* @param lineWidth  边框大小
* @param strokeColor 边框颜色
**/
-(void)setCornerRadius:(CGFloat)value addRectCorners:(UIRectCorner)rectCorner andLineWidth:(CGFloat)lineWidth andStrokeColor:(UIColor *)strokeColor{
    [self layoutIfNeeded];//这句代码很重要，不能忘了
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:rectCorner cornerRadii:CGSizeMake(value, value)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = path.CGPath;
    self.layer.mask = maskLayer;
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.frame = self.bounds;
    borderLayer.path = path.CGPath;
    borderLayer.lineWidth = lineWidth;
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.strokeColor = strokeColor.CGColor;
    [self.layer addSublayer:borderLayer];
}

@end
