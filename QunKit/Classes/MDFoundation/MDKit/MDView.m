//
//  MDView.m
//  shop
//
//  Created by 陈芳 on 2021/12/14.
//

#import "MDView.h"
#import "MDFoundation.h"
#import "NSArray+MD.h"


@interface MDView ()

//线性渐变
@property (nonatomic, strong) IBInspectable UIColor *gradientStartColor;
@property (nonatomic, strong) IBInspectable UIColor *gradientEndColor;
@property (nonatomic, assign) MDGradientDirection gradientDirection;
@property (nonatomic, assign) IBInspectable NSUInteger gradientDirectionValue;  //0：上到下，1：左到右，2：左上到右下，3：左下到右上

@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
@property (nonatomic, assign) IBInspectable NSInteger cornerPosition;           //0：全部，1：上半部，2：下半部，3：左半部，4：右半部

@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
@property (nonatomic, strong) IBInspectable UIColor *borderColor;

@property (nonatomic, assign) IBInspectable CGFloat touchExtend;
@property (nonatomic, assign) IBInspectable NSInteger zPosition;

@end

@implementation MDView

+ (Class)layerClass {
    return CAGradientLayer.class;
}

- (CAGradientLayer *)gradientLayer {
    return (id)self.layer;
}

- (void)setGradientStartColor:(UIColor *)gradientStartColor {
    _gradientStartColor = gradientStartColor;
    [self configGradientColors];
}

- (void)setGradientEndColor:(UIColor *)gradientEndColor {
    _gradientEndColor = gradientEndColor;
    [self configGradientColors];
}

- (void)setGradientDirection:(MDGradientDirection)gradientDirection {
    CGPoint startPoint, endPoint;
    
    switch (gradientDirection) {
        case MDGradientDirectionLeftToRight:
            startPoint = CGPointMake(0, 0.5);
            endPoint = CGPointMake(1, 0.5);
            break;
        case MDGradientDirectionTopLeftToBottomRight:
            startPoint = CGPointMake(0, 0);
            endPoint = CGPointMake(1, 1);
            break;
        case MDGradientDirectionBottomLeftToTopRight:
            startPoint = CGPointMake(0, 1);
            endPoint = CGPointMake(1, 0);
            break;
        default:
            startPoint = CGPointMake(0.5, 0);
            endPoint = CGPointMake(0.5, 1);
            break;
    }
    
    self.gradientLayer.startPoint = startPoint;
    self.gradientLayer.endPoint = endPoint;
}

- (void)setGradientDirectionValue:(NSUInteger)gradientDirectionValue {
    self.gradientDirection = gradientDirectionValue;
}

- (void)configGradientColors {
    if (self.gradientStartColor && self.gradientEndColor) {
        self.gradientLayer.colors = @[(id)self.gradientStartColor.CGColor, (id)self.gradientEndColor.CGColor];
    } else {
        self.gradientLayer.colors = nil;
    }
}

- (void)setGradientBackgroundWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor direction:(MDGradientDirection)direction {
    _gradientStartColor = startColor;
    _gradientEndColor = endColor;
    [self configGradientColors];
    self.gradientDirection = direction;
}

- (void)setGradientBackgroundColors:(NSArray *)colors locations:(NSArray *)locations direction:(MDGradientDirection)direction {
    self.gradientDirection = direction;
    self.gradientLayer.locations = locations;
    
    self.gradientLayer.colors = [colors dl_map:^id _Nonnull(id _Nonnull obj) {
        return ([obj isKindOfClass:UIColor.class]? (id)[obj CGColor]: obj);
    }];
}


@end
@implementation MDView (DLChain)

- (MDView * (^)(id))bg {
    return ^(id color) {
        self.backgroundColor = Color(color);
        return self;
    };
}

- (MDView * _Nonnull (^)(CGFloat))radius {
    return ^(CGFloat radius) {
        self.cornerRadius = radius;
        return self;
    };
}

- (MDView * _Nonnull (^)(CGFloat, id _Nonnull))border {
    return ^(CGFloat width, id color) {
        self.borderWidth = width;
        self.borderColor = Color(color);
        return self;
    };
}

- (MDView * _Nonnull (^)(CGFloat, CGFloat))pinWH {
    return ^(CGFloat width, CGFloat height) {
        if (!isnan(width)) {
            [self.widthAnchor constraintEqualToConstant:width].active = YES;
        }
        if (!isnan(height)) {
            [self.heightAnchor constraintEqualToConstant:height].active = YES;
        }
        return self;
    };
}

@end
