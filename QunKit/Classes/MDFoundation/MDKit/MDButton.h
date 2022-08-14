//
//  MDButton.h
//  shop
//
//  Created by 陈芳 on 2021/12/14.
//

#import <UIKit/UIKit.h>
#import "MDView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MDButtonImagePosition) {
    MDButtonImagePositionLeft       = 0,    //image在左边（默认）
    MDButtonImagePositionRight      = 1,    //image在右边
    MDButtonImagePositionTop        = 2,    //image在上面
    MDButtonImagePositionBottom     = 3,    //image在下面
};


@interface MDButton : UIButton


///内边距
@property (nonatomic, assign) UIEdgeInsets padding;

///image和title的间距
@property (nonatomic, assign) IBInspectable CGFloat spacing;

///image和title的位置
@property (nonatomic, assign) MDButtonImagePosition imagePosition;


///设置渐变背景
- (void)setGradientBackgroundWithStartColor:(UIColor *_Nullable)startColor endColor:(UIColor *_Nullable)endColor direction:(MDGradientDirection)direction;
- (void)setGradientBackgroundColors:(NSArray *)colors locations:(NSArray *)locations direction:(MDGradientDirection)direction;

- (void)rotate360DegreeWithImageView;

@end


#pragma mark - 链式访问

@interface MDButton (DLChain)

@property (nonatomic, readonly) MDButton *(^str)(id title);                     //title
@property (nonatomic, readonly) MDButton *(^selectedStr)(id title);             //selectedTitle
@property (nonatomic, readonly) MDButton *(^disabledStr)(id title);             //disabledTitle
@property (nonatomic, readonly) MDButton *(^color)(id color);                   //titleColor

@property (nonatomic, readonly) MDButton *(^img)(id image);                     //image
@property (nonatomic, readonly) MDButton *(^selectedImg)(id image);             //selectedImage
@property (nonatomic, readonly) MDButton *(^disabledImg)(id image);             //disabledImage

@property (nonatomic, readonly) MDButton *(^fnt)(CGFloat fontSize);             //titleFont
@property (nonatomic, readonly) MDButton *(^boldFnt)(CGFloat fontSize);         //bold textFont
@property (nonatomic, readonly) MDButton *(^gap)(CGFloat spacing);              //spacing

@property (nonatomic, readonly) MDButton *(^bg)(id color);                      //backgroundColor
@property (nonatomic, readonly) MDButton *(^highBg)(id color);                  //highlightedBackgroundColor
@property (nonatomic, readonly) MDButton *(^selectedBg)(id color);              //selectedBackgroundColor
@property (nonatomic, readonly) MDButton *(^disabledBg)(id color);              //disabledBackgroundColor

@property (nonatomic, readonly) MDButton *(^radius)(CGFloat cornerRadius);      //cornerRadius + masksToBounds
@property (nonatomic, readonly) MDButton *(^border)(CGFloat width, id color);   //borderWidth + boderColor

@property (nonatomic, readonly) MDButton *(^pinWH)(CGFloat width, CGFloat height);    //设置宽高约束, 传NAN表示不设置

@end


NS_ASSUME_NONNULL_END
