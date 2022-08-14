//
//  UIBezierPath+MD.m
//  shop
//
//  Created by 陈芳 on 2021/12/14.
//

#import "UIBezierPath+MD.h"

@implementation UIBezierPath (MD)

+ (instancetype)dl_bezierPathWithRoundedRect:(CGRect)rect topLeftRadius:(CGFloat)tlRadius topRightRadius:(CGFloat)trRadius bottomLeft:(CGFloat)blRadius bottomRight:(CGFloat)brRadius {

    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    
    UIBezierPath *roundedPath = [UIBezierPath bezierPath];

    [roundedPath moveToPoint:CGPointMake(tlRadius, 0)];
    [roundedPath addLineToPoint:CGPointMake(width - trRadius, 0)];
    [roundedPath addArcWithCenter:CGPointMake(width - trRadius, trRadius) radius:trRadius startAngle:M_PI*1.5 endAngle:0 clockwise:YES];
    [roundedPath addLineToPoint:CGPointMake(width, height - brRadius)];
    [roundedPath addArcWithCenter:CGPointMake(width - brRadius, height - brRadius) radius:brRadius startAngle:0 endAngle:M_PI_2 clockwise:YES];
    [roundedPath addLineToPoint:CGPointMake(blRadius, height)];
    [roundedPath addArcWithCenter:CGPointMake(blRadius, height - blRadius) radius:blRadius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    [roundedPath addLineToPoint:CGPointMake(0, tlRadius)];
    [roundedPath addArcWithCenter:CGPointMake(tlRadius, tlRadius) radius:tlRadius startAngle:M_PI endAngle:M_PI*1.5 clockwise:YES];
    [roundedPath closePath];
    
    return roundedPath;
}

@end
