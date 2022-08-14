//
//  MDLabel.m
//  shop
//
//  Created by 陈芳 on 2021/12/18.
//

#import "MDLabel.h"

@implementation MDLabel
+ (UILabel *)dl_labelWithText:(NSString *)string textColor:(UIColor *)textColor font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] init];
    label.text = string;
    label.textColor = textColor;
    label.font = font;
    return label;
}
@end
