//
//  UIBezierPath+MD.h
//  shop
//
//  Created by 陈芳 on 2021/12/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBezierPath (MD)
///不同圆角的path
+ (instancetype)dl_bezierPathWithRoundedRect:(CGRect)rect topLeftRadius:(CGFloat)tlRadius topRightRadius:(CGFloat)trRadius bottomLeft:(CGFloat)blRadius bottomRight:(CGFloat)brRadius;

@end

NS_ASSUME_NONNULL_END
