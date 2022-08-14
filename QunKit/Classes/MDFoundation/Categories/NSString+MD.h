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

//格式化价格超过万的显示
- (NSAttributedString *)formatWithPrice:(float)bigFont middleFont:(float)middleFont;

- (NSAttributedString *)formatWithPriceDetail:(float)bigFont middleFont:(float)middleFont;

//奇豆超过万的显示
- (NSString *)formatWithQidou;
//奇豆超过万的显示，固定两位小数
- (NSString *)formatWithQidouTwoPoint;

//四舍五入
- (NSString *)formatWithQidouTwoPointByRounded;
//去掉小数点
-(NSString*)removeFloatAllZero;
@end

NS_ASSUME_NONNULL_END
