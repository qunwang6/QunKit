//
//  NSString+MD.m
//  shop
//
//  Created by 陈芳 on 2021/12/14.
//

#import "NSString+MD.h"
#import "MDFoundation.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
@implementation NSString (MD)
- (NSString *)dl_stringByAppendingURLComponent:(NSString *)path {
    if (!path.length) return self;
    
    NSString *s1 = ([self hasSuffix:@"/"]? [self substringToIndex:self.length - 1]: self);
    NSString *s2 = ([path hasPrefix:@"/"]? [path substringFromIndex:1]: path);
    return [NSString stringWithFormat:@"%@/%@", s1, s2];
}

- (CGSize)dl_sizeWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth {
    id attrs = @{NSFontAttributeName : font};

    CGRect rect = [self boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:attrs
                                     context:nil];
    
    return CGSizeMake(ceilf(rect.size.width), ceilf(rect.size.height));
}

- (CGFloat)withString:(UIFont *)font
{

    //根据字体得到nsstring的尺寸
    CGSize size = [self sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
    //名字的高
//    CGFloat nameH = size.height;
    //名字的宽
    CGFloat nameW = size.width;
    
    return nameW>SCREEN_WIDTH?SCREEN_WIDTH-20:nameW;
}



@end
