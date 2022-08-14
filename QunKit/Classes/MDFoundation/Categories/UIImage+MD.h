//
//  UIImage+MD.h
//  shop
//
//  Created by 陈芳 on 2021/12/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (MD)
///从指定bundle里读取图片
+ (UIImage *)dl_imageNamed:(NSString *)named inBundle:(NSString *)bundleName;

///1pt大小指定颜色的图片
+ (UIImage *)dl_imageWithColor:(UIColor *)color;


///缩放到指定的大小
- (UIImage *)dl_imageWithSize:(CGSize)size;
///根据指定的宽度等比缩小
- (UIImage *)dl_imageWithMaxWidth:(CGFloat)maxWidth;
///等比缩小到指定的最大宽高值，如果宽高值都小于maxDimension，则返回原始图片
- (UIImage *)dl_imageWithMaxDimension:(CGFloat)maxDimension;
//压缩到多少kb
+ (UIImage *)scaleImage:(NSInteger)kb;

///模糊图片
- (UIImage *)dl_blurWithValue:(CGFloat)blurAmount;
@end

NS_ASSUME_NONNULL_END
