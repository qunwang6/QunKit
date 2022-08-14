//
//  UIView+DL.m
//  DLFoundation
//
//  Created by cyp on 2021/5/11.
//

#import "UIView+DL.h"
#import "NSObject+MD.h"
#import "MDFoundation.h"
#import <objc/runtime.h>
#import "UIBezierPath+MD.h"


@implementation UIView (DLTouch)

- (BOOL)dl_pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    NSValue *extendsValue = [self dl_associatedObjectForKey:@"touchExtends"];
    
    if (extendsValue) {
        UIEdgeInsets extends = [extendsValue UIEdgeInsetsValue];
        extends = UIEdgeInsetsMake(-extends.top, -extends.left, -extends.bottom, -extends.right);
        CGRect rect = UIEdgeInsetsInsetRect(self.bounds, extends);
        return CGRectContainsPoint(rect, point);
        
    } else {
        return [self dl_pointInside:point withEvent:event];
    }
}

- (UIEdgeInsets)dl_touchExtends {
    return [[self dl_associatedObjectForKey:@"touchExtends"] UIEdgeInsetsValue];
}

- (void)setDl_touchExtends:(UIEdgeInsets)dl_touchExtends {
    [self dl_setAssociatedObject:@(dl_touchExtends) forKey:@"touchExtends"];
}

- (void)onTap:(void (^)(void))callback {
    if (!callback) return;
    
    self.userInteractionEnabled = YES;
    MDSimpleBlock tapBlock = [self dl_associatedObjectForKey:@"tapBlock"];
    
    if (!tapBlock) {
        if ([self isKindOfClass:UIControl.class]) {
            [(UIControl *)self addTarget:self action:@selector(dl_didTap) forControlEvents:UIControlEventTouchUpInside];
            
        } else {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dl_didTap)];
            [self addGestureRecognizer:tap];
        }
    }
    
    tapBlock = callback;
    [self dl_setAssociatedObject:tapBlock forKey:@"tapBlock"];
}

- (void)dl_didTap {
    MDSimpleBlock tapBlock = [self dl_associatedObjectForKey:@"tapBlock"];
    if (tapBlock) tapBlock();
}

@end




@implementation UIView (DLLayer)

- (void)dl_layoutSubviews {
//    [self dl_layoutSubviews];
    [self dl_updateCustomMaskIfNeed];
    [self dl_updateShadowPathIfNeed];
}

- (void)dl_setCorner:(UIRectCorner)corner radius:(CGFloat)radius {
    self.layer.cornerRadius = radius;
    if (@available(iOS 11.0, *)) {
        self.layer.maskedCorners = (CACornerMask)corner;
    } else {
        // Fallback on earlier versions
    }
    
    if (radius > 0 && self.layer.shadowOpacity == 0) {
        self.layer.masksToBounds = YES;
    }
}

- (void)dl_setTopCornerWithRadius:(CGFloat)radius {
    [self dl_setCorner:UIRectCornerTopLeft | UIRectCornerTopRight radius:radius];
}

- (void)dl_setBottomCornerWithRadius:(CGFloat)radius {
    [self dl_setCorner:UIRectCornerBottomLeft | UIRectCornerBottomRight radius:radius];
}

- (void)dl_setLeftCornerWithRadius:(CGFloat)radius {
    [self dl_setCorner:UIRectCornerTopLeft | UIRectCornerBottomLeft radius:radius];
}

- (void)dl_setRightCornerWithRadius:(CGFloat)radius;{
    [self dl_setCorner:UIRectCornerTopRight | UIRectCornerBottomRight radius:radius];
}

- (void)dl_setCornerRadiusForTopLeft:(CGFloat)tlRadius topRight:(CGFloat)trRadius bottomLeft:(CGFloat)blRadius bottomRight:(CGFloat)brRadius {
    CGRect maskRadiusValues = CGRectMake(tlRadius, trRadius, blRadius, brRadius);
    [self dl_setAssociatedObject:@(maskRadiusValues) forKey:@"maskRadiusValues"];
    
    [self dl_updateCustomMaskIfNeed];
}

- (void)dl_updateCustomMaskIfNeed {
    NSValue *maskRadiusValues = [self dl_associatedObjectForKey:@"maskRadiusValues"];
    if (!maskRadiusValues) return;
    
    CGRect maskRadiusRect = [maskRadiusValues CGRectValue];
    CGFloat tlRadius = maskRadiusRect.origin.x;
    CGFloat trRadius = maskRadiusRect.origin.y;
    CGFloat blRadius = maskRadiusRect.size.width;
    CGFloat brRadius = maskRadiusRect.size.height;

    UIBezierPath *maskPath = [UIBezierPath dl_bezierPathWithRoundedRect:self.bounds topLeftRadius:tlRadius topRightRadius:trRadius bottomLeft:blRadius bottomRight:brRadius];

    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)dl_updateShadowPathIfNeed {
    if (![[self dl_associatedObjectForKey:@"needShadowPath"] boolValue]) {
        return;
    }
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                     byRoundingCorners:(UIRectCorner)self.layer.maskedCorners
                                                           cornerRadii:CGSizeMake(self.layer.cornerRadius, self.layer.cornerRadius)];
    self.layer.shadowPath = shadowPath.CGPath;
}

- (void)dl_setShadowOpacity:(CGFloat)opacity radius:(CGFloat)radius {
    [self dl_setShadowOpacity:opacity radius:radius offset:CGSizeZero];
}

- (void)dl_setShadowOpacity:(CGFloat)opacity radius:(CGFloat)radius offset:(CGSize)offset {
    self.layer.shadowOffset = offset;
    self.layer.shadowOpacity = opacity;
    self.layer.shadowRadius = radius;
    
    if (opacity > 0 && radius > 0) {
        self.layer.masksToBounds = NO;
    }
    
    [self dl_setAssociatedObject:@(opacity>0? YES: NO) forKey:@"needShadowPath"];
    [self dl_updateShadowPathIfNeed];
}

- (void)dl_setBorderWidth:(CGFloat)width color:(UIColor *)color {
    self.layer.borderWidth = width;
    self.layer.borderColor = color.CGColor;
}

@end




@implementation UIView (DLCons)

- (void)dl_pinWidth:(CGFloat)width height:(CGFloat)height {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    if (!isnan(width)) {
        [self.widthAnchor constraintEqualToConstant:width].active = YES;
    }
    
    if (!isnan(height)) {
        [self.heightAnchor constraintEqualToConstant:height].active = YES;
    }
}

@end




@implementation UIView (DLSubViews)

- (void)dl_addSubview:(UIView *)view insets:(UIEdgeInsets)insets {
    [self addSubview:view];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    if (!isnan(insets.top)) {
        [view.topAnchor constraintEqualToAnchor:self.topAnchor constant:insets.top].active = YES;
    }
    
    if (!isnan(insets.left)) {
        [view.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:insets.left].active = YES;
    }
    
    if (!isnan(insets.bottom)) {
        [view.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-insets.bottom].active = YES;
    }
    
    if (!isnan(insets.right)) {
        [view.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-insets.right].active = YES;
    }
}

- (void)dl_addSubview:(UIView *)view insets:(UIEdgeInsets)insets height:(CGFloat)height {
    [self dl_addSubview:view insets:insets];
    if (!isnan(height)) {
        [view.heightAnchor constraintEqualToConstant:height].active = YES;
    }
}

- (void)dl_addSubview:(UIView *)view centerOffset:(CGPoint)offset {
    [self addSubview:view];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    if (!isnan(offset.x)) {
        [view.centerXAnchor constraintEqualToAnchor:self.centerXAnchor constant:offset.x].active = YES;
    }
    
    if (!isnan(offset.y)) {
        [view.centerYAnchor constraintEqualToAnchor:self.centerYAnchor constant:offset.y].active = YES;
    }
}

-(NSArray *)dl_getRecursiveSubviewsWithClass:(Class)targetClass {
    NSMutableArray *arr = [NSMutableArray array];
    
    for (UIView *subview in self.subviews) {
        if (!targetClass || [subview isKindOfClass:targetClass]) {
            [arr addObject:subview];
        }
        
        [arr addObjectsFromArray:[subview dl_getRecursiveSubviewsWithClass:targetClass]];
    }
    
    return arr;
}

- (void)dl_removeAllSubViews {
    for (UIView *sv in self.subviews) {
        [sv removeFromSuperview];
    }
}

@end





@implementation UIView (DLSnapShot)

- (UIImage *)dl_snapshot {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snap;
}

@end





@implementation UIView (DLCreation)

+ (instancetype)dl_loadFromXib {
    return [[NSBundle bundleForClass:self] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
}

+ (instancetype)dl_loadFromXibInBundle:(NSString *)bundleName {
    NSBundle *bundle = Bundle(bundleName)?: [NSBundle bundleForClass:self];
    return [bundle loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
}

- (instancetype)dl_copy {
    id data = [NSKeyedArchiver archivedDataWithRootObject:self];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [UIView dl_swizzleInstanceSelector:@selector(pointInside:withEvent:) withOtherSelector:@selector(dl_pointInside:withEvent:)];
        [UIView dl_swizzleInstanceSelector:@selector(layoutSubviews) withOtherSelector:@selector(dl_layoutSubviews)];
    });
}

@end

