//
//  ATImageTopButton.h
//  Postre
//
//  Created by CoderLT on 2017/5/22.
//  Copyright © 2017年 CoderLT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATHightlightButton.h"

typedef NS_ENUM(NSInteger, UIButtonImagePosition) {
    UIBUttonImagePositionLeft,
    UIBUttonImagePositionRight,
    UIBUttonImagePositionTop,
    UIBUttonImagePositionBottom,
};

@interface UIButton (ImagePosition)
- (void)setImagePosition:(UIButtonImagePosition)postion spaceToTitle:(CGFloat)space;
@end


@interface ATImageTopButton : ATHightlightButton
@property (nonatomic, assign) IBInspectable CGFloat imageMarning;

@end

@interface ATImageRightButton : ATHightlightButton
@property (nonatomic, assign) IBInspectable CGFloat imageMarning;
@end

@interface ATMargingButton : ATHightlightButton
@property (nonatomic, assign) IBInspectable CGFloat imageMarning;
@end

@interface ATBorderButton : ATMargingButton
@end
