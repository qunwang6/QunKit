//
//  MDButton.m
//  shop
//
//  Created by 陈芳 on 2021/12/14.
//

#import "MDButton.h"
#import "MDFoundation.h"
#import "NSArray+MD.h"
#import "NSAttributedString+MD.h"
#import "DLViewCommonImpl.h"
#import "NSString+MD.h"


@interface MDButton ()

//线性渐变
@property (nonatomic, assign) MDGradientDirection gradientDirection;
@property (nonatomic, strong) NSArray *gradientColors;
@property (nonatomic, strong) IBInspectable UIColor *gradientStartColor;
@property (nonatomic, strong) IBInspectable UIColor *gradientEndColor;
@property (nonatomic, assign) IBInspectable NSUInteger gradientDirectionValue;  //0：上到下，1：左到右，2：左上到右下，3：左下到右上


@property (nonatomic, assign) IBInspectable NSUInteger imagePositionValue;

@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
@property (nonatomic, assign) IBInspectable NSInteger cornerPosition;

@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
@property (nonatomic, strong) IBInspectable UIColor *borderColor;

@property (nonatomic, assign) IBInspectable CGFloat touchExtend;
@property (nonatomic, assign) IBInspectable NSInteger zPosition;

@property (nonatomic, assign) IBInspectable CGFloat paddingLeft;
@property (nonatomic, assign) IBInspectable CGFloat paddingRight;
@property (nonatomic, assign) IBInspectable CGFloat paddingTop;
@property (nonatomic, assign) IBInspectable CGFloat paddingBottom;

@property (nonatomic, strong) UIColor *normalBackgroundColor;
@property (nonatomic, strong) IBInspectable UIColor *highlightedBackgroundColor;
@property (nonatomic, strong) IBInspectable UIColor *selectedBackgroundColor;
@property (nonatomic, strong) IBInspectable UIColor *disabledBackgroundColor;

@end


@implementation MDButton

DLVIEW_COMMON_IMPL();
DLVIEW_PADDING_IMPL([self layoutContents]);



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
        self.gradientColors = @[(id)self.gradientStartColor.CGColor, (id)self.gradientEndColor.CGColor];
        [self updateBackground];
//        self.gradientLayer.colors = self.gradientColors;
    } else {
        self.gradientColors = nil;
        [self updateBackground];
//        self.gradientLayer.colors = self.gradientColors;
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
    
    self.gradientColors = [colors dl_map:^id _Nonnull(id _Nonnull obj) {
        return ([obj isKindOfClass:UIColor.class]? (id)[obj CGColor]: obj);
    }];
    
    [self updateBackground];
}





- (void)setImagePosition:(MDButtonImagePosition)imagePosition {
    if (_imagePosition != imagePosition) {
        _imagePosition = imagePosition;
        [self layoutContents];
    }
}

- (void)setImagePositionValue:(NSUInteger)imagePositionValue {
    self.imagePosition = imagePositionValue;
}

- (void)setSpacing:(CGFloat)spacing {
    if (_spacing != spacing) {
        _spacing = spacing;
        [self layoutContents];
    }
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state {
    [super setImage:image forState:state];
    if ([self isVerticalLayout]) {
        [self layoutContents];
    }
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    [super setTitle:title forState:state];
    if ([self isVerticalLayout]) {
        [self layoutContents];
    }
}

- (BOOL)isVerticalLayout {
    return (self.imagePosition == MDButtonImagePositionTop || self.imagePosition == MDButtonImagePositionBottom);
}

- (void)layoutContents {
    UIEdgeInsets imageInsets = UIEdgeInsetsZero;
    UIEdgeInsets titleInsets = UIEdgeInsetsZero;
    UIEdgeInsets contentInsets = self.padding;
    
    CGFloat halfSpacing = self.spacing / 2;
    
    if ([self isVerticalLayout]) {
        UIImage *image = [self imageForState:self.state];
        NSString *title = [self titleForState:self.state];
        
        if (image && title.length) {
            NSAttributedString *attTitle = [self attributedTitleForState:self.state];
            CGSize imageSize = [self imageForState:self.state].size;
            CGSize titleSize = CGSizeZero;
            
            if (attTitle) {
                titleSize = [attTitle dl_sizeWithMaxWidth:MAXFLOAT];
            } else if (title) {
                titleSize = [title dl_sizeWithFont:self.titleLabel.font maxWidth:MAXFLOAT];
            }
            
            CGFloat totalWidth = imageSize.width + titleSize.width;
            CGFloat totalHeight = (imageSize.height + titleSize.height + self.spacing);
            
            if (self.imagePosition == MDButtonImagePositionTop) {
                imageInsets.top = - (totalHeight - imageSize.height);
                imageInsets.right = - titleSize.width;
                titleInsets.left = - imageSize.width;
                titleInsets.bottom = - (totalHeight - titleSize.height);
                
            } else if (self.imagePosition == MDButtonImagePositionBottom) {
                imageInsets.bottom = - (totalHeight - imageSize.height);
                imageInsets.right = - titleSize.width;
                titleInsets.top = - (totalHeight - titleSize.height);
                titleInsets.left = - imageSize.width;
            }
            
            CGFloat deltaHeight = (totalHeight - MAX(imageSize.height, titleSize.height)) / 2;
            CGFloat deltaWidth = (totalWidth - MAX(imageSize.width, titleSize.width)) / 2;
            
            contentInsets.top += deltaHeight;
            contentInsets.bottom += deltaHeight;
            contentInsets.left -= deltaWidth;
            contentInsets.right -= deltaWidth;
        }
        
    } else {
        imageInsets = UIEdgeInsetsMake(0, -halfSpacing, 0, halfSpacing);
        titleInsets = UIEdgeInsetsMake(0, halfSpacing, 0, -halfSpacing);
        
        contentInsets.left += halfSpacing;
        contentInsets.right += halfSpacing;
    }

    self.imageEdgeInsets = imageInsets;
    self.titleEdgeInsets = titleInsets;
    self.contentEdgeInsets = contentInsets;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.imagePosition == MDButtonImagePositionRight) {
        CGRect imageRect = self.imageView.frame;
        CGRect titleRect = self.titleLabel.frame;

        if (imageRect.size.width && titleRect.size.width && imageRect.origin.x < titleRect.origin.x) {
            titleRect.origin.x = imageRect.origin.x;
            imageRect.origin.x = CGRectGetMaxX(titleRect) + self.spacing;

            self.imageView.frame = imageRect;
            self.titleLabel.frame = titleRect;
        }
    }
}

- (void)setHighlightedBackgroundColor:(UIColor *)highlightedBackgroundColor {
    _highlightedBackgroundColor = highlightedBackgroundColor;
    if (self.highlighted) [self updateBackground];
}

- (void)setSelectedBackgroundColor:(UIColor *)selectedBackgroundColor {
    _selectedBackgroundColor = selectedBackgroundColor;
    if (self.selected) [self updateBackground];
}

- (void)setDisabledBackgroundColor:(UIColor *)disabledBackgroundColor {
    _disabledBackgroundColor = disabledBackgroundColor;
    if (!self.enabled) [self updateBackground];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    _normalBackgroundColor = backgroundColor;
    [self updateBackground];
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    [self updateBackground];
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    [self updateBackground];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self updateBackground];
}

- (void)updateBackground {
    if (self.enabled) {
        if (self.selected) {
            if (self.selectedBackgroundColor) {
                self.layer.backgroundColor = self.selectedBackgroundColor.CGColor;
                self.gradientLayer.colors = nil;
            }
            
        } else if (self.highlighted) {
            if (self.highlightedBackgroundColor) {
                self.layer.backgroundColor = self.highlightedBackgroundColor.CGColor;
                self.gradientLayer.colors = nil;
            }
            
        } else {
            if (_normalBackgroundColor) {
                self.layer.backgroundColor = self.normalBackgroundColor.CGColor;
            }
            self.gradientLayer.colors = self.gradientColors;
        }
        
    } else {
        if (self.disabledBackgroundColor) {
            self.layer.backgroundColor = self.disabledBackgroundColor.CGColor;
            self.gradientLayer.colors = nil;
        }
    }
}


- (void)rotate360DegreeWithImageView{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath: @"transform" ];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    //围绕Z轴旋转，垂直与屏幕
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI/2.0, 0.0, 0.0, 1.0) ];
    animation.duration = 1;
    //旋转效果累计，先转180度，接着再旋转180度，从而实现360旋转
    animation.cumulative = YES;
    animation.repeatCount = MAXFLOAT;
    CGRect imageRrect = CGRectMake(0, 0,self.imageView.frame.size.width, self.imageView.frame.size.height);
    UIGraphicsBeginImageContext(imageRrect.size);
    //在图片边缘添加一个像素的透明区域，去图片锯齿

    [self.currentImage drawInRect:CGRectMake(0,0,self.imageView.frame.size.width,self.imageView.frame.size.height)];
    [self setImage: UIGraphicsGetImageFromCurrentImageContext() forState:UIControlStateNormal];
    UIGraphicsEndImageContext();
    [self.layer addAnimation:animation forKey:nil];

}

@end



@implementation MDButton (DLChain)

- (MDButton * (^)(id))str {
    return ^(id title) {
        if ([title isKindOfClass:NSString.class]) {
            [self setTitle:title forState:UIControlStateNormal];
        } else if ([title isKindOfClass:NSAttributedString.class]) {
            [self setAttributedTitle:title forState:UIControlStateNormal];
        }
        return self;
    };
}

- (MDButton * (^)(id))selectedStr {
    return ^(id title) {
        if ([title isKindOfClass:NSString.class]) {
            [self setTitle:title forState:UIControlStateSelected];
        } else if ([title isKindOfClass:NSAttributedString.class]) {
            [self setAttributedTitle:title forState:UIControlStateSelected];
        }
        return self;
    };
}

- (MDButton * (^)(id))disabledStr {
    return ^(id title) {
        if ([title isKindOfClass:NSString.class]) {
            [self setTitle:title forState:UIControlStateDisabled];
        } else if ([title isKindOfClass:NSAttributedString.class]) {
            [self setAttributedTitle:title forState:UIControlStateDisabled];
        }
        return self;
    };
}

- (MDButton * (^)(id))img {
    return ^(id image) {
        [self setImage:Img(image) forState:UIControlStateNormal];
        return self;
    };
}

- (MDButton * (^)(id))selectedImg {
    return ^(id image) {
        [self setImage:Img(image) forState:UIControlStateSelected];
        return self;
    };
}

- (MDButton * (^)(id))disabledImg {
    return ^(id image) {
        [self setImage:Img(image) forState:UIControlStateDisabled];
        return self;
    };
}

- (MDButton * (^)(id))color {
    return ^(id color) {
        [self setTitleColor:Color(color) forState:UIControlStateNormal];
        return self;
    };
}

- (MDButton * (^)(CGFloat))fnt {
    return ^(CGFloat fontSize) {
        self.titleLabel.font = Fnt(fontSize);
        return self;
    };
}

- (MDButton * (^)(CGFloat))boldFnt {
    return ^(CGFloat fontSize) {
        self.titleLabel.font = BoldFnt(fontSize);
        return self;
    };
}

- (MDButton * (^)(CGFloat))gap {
    return ^(CGFloat spacing) {
        self.spacing = spacing;
        return self;
    };
}

- (MDButton * (^)(id))bg {
    return ^(id color) {
        if ([color isKindOfClass:UIImage.class]) {
            UIImage *image = (id)color;
            [self setBackgroundImage:image forState:UIControlStateNormal];
            
            if (image && CGRectEqualToRect(self.frame, CGRectZero)) {
                self.frame = CGRectMake(0, 0, image.size.width, image.size.height);
            }
        } else {
            self.backgroundColor = Color(color);
        }
        return self;
    };
}

- (MDButton * (^)(id))highBg {
    return ^(id color) {
        if ([color isKindOfClass:UIImage.class]) {
            [self setBackgroundImage:color forState:UIControlStateHighlighted];
        } else {
            self.highlightedBackgroundColor = Color(color);
        }
        return self;
    };
}

- (MDButton * (^)(id))selectedBg {
    return ^(id color) {
        if ([color isKindOfClass:UIImage.class]) {
            [self setBackgroundImage:color forState:UIControlStateSelected];
        } else {
            self.selectedBackgroundColor = Color(color);
        }
        return self;
    };
}

- (MDButton * (^)(id))disabledBg {
    return ^(id color) {
        if ([color isKindOfClass:UIImage.class]) {
            [self setBackgroundImage:color forState:UIControlStateDisabled];
        } else {
            self.disabledBackgroundColor = Color(color);
        }
        return self;
    };
}

- (MDButton * _Nonnull (^)(CGFloat))radius {
    return ^(CGFloat radius) {
        self.cornerRadius = radius;
        return self;
    };
}

- (MDButton * _Nonnull (^)(CGFloat, id _Nonnull))border {
    return ^(CGFloat width, id color) {
        self.borderWidth = width;
        self.borderColor = Color(color);
        return self;
    };
}

- (MDButton * _Nonnull (^)(CGFloat, CGFloat))pinWH {
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

