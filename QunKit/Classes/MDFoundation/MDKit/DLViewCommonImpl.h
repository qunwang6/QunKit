//
//  DLViewCommonImpl.h
//  DLKit
//
//  Created by cyp on 2021/5/17.
//

#import <Foundation/Foundation.h>
#import "UIView+DL.h"


#define DLVIEW_COMMON_IMPL()    \
- (CGFloat)cornerRadius {\
    return self.layer.cornerRadius;\
}\
\
- (void)setCornerRadius:(CGFloat)cornerRadius {\
    self.layer.cornerRadius = cornerRadius;\
    if (cornerRadius > 0 && !self.clipsToBounds) self.clipsToBounds = YES;\
}\
\
- (void)setCornerPosition:(NSInteger)cornerPosition {\
    _cornerPosition = cornerPosition;\
    \
    if (@available(iOS 11.0, *)) {\
        UIRectCorner corner = UIRectCornerAllCorners;\
        \
        if (cornerPosition == 1) {\
            corner = UIRectCornerTopLeft | UIRectCornerTopRight;\
        } else if (cornerPosition == 2) {\
            corner = UIRectCornerBottomLeft | UIRectCornerBottomRight;\
        } else if (cornerPosition == 3) {\
            corner = UIRectCornerTopLeft | UIRectCornerBottomLeft;\
        } else if (cornerPosition == 4) {\
            corner = UIRectCornerTopRight | UIRectCornerBottomRight;\
        }\
        \
        self.layer.maskedCorners = (CACornerMask)corner;\
    }\
}\
\
- (CGFloat)borderWidth {\
    return self.layer.borderWidth;\
}\
\
- (void)setBorderWidth:(CGFloat)borderWidth {\
    self.layer.borderWidth = (borderWidth == 0.5? (1.0 / [UIScreen mainScreen].scale): borderWidth);\
}\
\
- (UIColor *)borderColor {\
    return [UIColor colorWithCGColor:self.layer.borderColor];\
}\
\
- (void)setBorderColor:(UIColor *)borderColor {\
    self.layer.borderColor = borderColor.CGColor;\
}\
\
- (CGFloat)touchExtend {\
    return self.dl_touchExtends.top;\
}\
\
- (void)setTouchExtend:(CGFloat)touchExtend {\
    self.dl_touchExtends = UIEdgeInsetsMake(touchExtend, touchExtend, touchExtend, touchExtend);\
}\
\
- (NSInteger)zPosition {\
    return self.layer.zPosition;\
}\
\
- (void)setZPosition:(NSInteger)zPosition {\
    self.layer.zPosition = zPosition;\
}\



#define DLVIEW_PADDING_IMPL(statement)\
- (void)setPadding:(UIEdgeInsets)padding {\
    _padding = padding;\
    statement;\
    [self invalidateIntrinsicContentSize];\
}\
\
- (void)setPaddingLeft:(CGFloat)paddingLeft {\
    UIEdgeInsets padding = self.padding;\
    padding.left = paddingLeft;\
    self.padding = padding;\
}\
\
- (CGFloat)paddingLeft {\
    return self.padding.left;\
}\
\
- (void)setPaddingRight:(CGFloat)paddingRight {\
    UIEdgeInsets padding = self.padding;\
    padding.right = paddingRight;\
    self.padding = padding;\
}\
\
- (CGFloat)paddingRight {\
    return self.padding.right;\
}\
\
- (void)setPaddingTop:(CGFloat)paddingTop {\
    UIEdgeInsets padding = self.padding;\
    padding.top = paddingTop;\
    self.padding = padding;\
}\
\
- (CGFloat)paddingTop {\
    return self.padding.top;\
}\
\
- (void)setPaddingBottom:(CGFloat)paddingBottom {\
    UIEdgeInsets padding = self.padding;\
    padding.bottom = paddingBottom;\
    self.padding = padding;\
}\
\
- (CGFloat)paddingBottom {\
    return self.padding.bottom;\
}
