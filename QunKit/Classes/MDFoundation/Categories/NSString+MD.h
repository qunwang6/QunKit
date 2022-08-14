//
//  NSString+MD.h
//  shop
//
//  Created by 陈芳 on 2021/12/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (MD)
///拼接URL
- (NSString *)dl_stringByAppendingURLComponent:(NSString *)path;

///计算字符串的大小
- (CGSize)dl_sizeWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth;

///计算字符串的宽度
- (CGFloat)withString:(UIFont *)font;

@end

NS_ASSUME_NONNULL_END
