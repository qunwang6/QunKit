//
//  NSString+MD.m
//  shop
//
//  Created by 陈芳 on 2021/12/14.
//

#import "NSString+MD.h"

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

//格式化价格超过万的显示
- (NSAttributedString *)formatWithPrice:(float)bigFont middleFont:(float)middleFont
{
    NSAttributedString *returnString = [[NSMutableAttributedString alloc] initWithString:[self removeFloatAllZero]];
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler
                                           decimalNumberHandlerWithRoundingMode:NSRoundDown
                                           scale:2
                                           raiseOnExactness:NO
                                           raiseOnOverflow:NO
                                           raiseOnUnderflow:NO
                                           raiseOnDivideByZero:YES];
    float price = [self floatValue];
    if (price>=10000) {
        //舍掉小数点保留2位小数
        NSDecimalNumber *total = [[NSDecimalNumber decimalNumberWithString:self] decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:@"10000"] withBehavior:roundUp];
        NSString *priceStr = Str(@"￥%@万",total);
        NSArray *list = [priceStr componentsSeparatedByString:@"."];
        if (list.count>0) {
            if (list.count == 2) {
                returnString = AttStr(priceStr).select(list[0]).boldFnt(bigFont).select(@"￥").boldFnt(middleFont).select(list[1]).boldFnt(middleFont);
            }else
            {
                returnString = AttStr(priceStr).select(list[0]).boldFnt(bigFont).select(@"￥").boldFnt(middleFont);
            }
        }
        
    }else
    {
        NSString *priceStr = Str(@"￥%@",[self removeFloatAllZero]);
        NSArray *list = [priceStr componentsSeparatedByString:@"."];
        if (list.count>0) {
            if (list.count == 2) {
                returnString = AttStr(priceStr).select(list[1]).boldFnt(middleFont).select(list[0]).boldFnt(bigFont).select(@"￥").boldFnt(middleFont);
            }else
            {
                returnString = AttStr(priceStr).select(list[0]).boldFnt(bigFont).select(@"￥").boldFnt(middleFont);
            }
        }
    }
    return returnString;
}

- (NSAttributedString *)formatWithPriceDetail:(float)bigFont middleFont:(float)middleFont
{
    NSAttributedString *returnString = [[NSMutableAttributedString alloc] initWithString:self];
    
    NSString *priceStr = Str(@"￥%@",self);
    NSArray *list = [priceStr componentsSeparatedByString:@"."];
    if (list.count>0) {
        if (list.count == 2) {
            returnString = AttStr(priceStr).select(list[1]).boldFnt(middleFont).select(list[0]).boldFnt(bigFont).select(@"￥").boldFnt(middleFont);
        }else
        {
            returnString = AttStr(priceStr).select(list[0]).boldFnt(bigFont).select(@"￥").boldFnt(middleFont);
        }
    }
    return returnString;
}

//奇豆超过万的显示
- (NSString *)formatWithQidou
{
    NSInteger qidou = [self integerValue];
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler
                                           decimalNumberHandlerWithRoundingMode:NSRoundDown
                                           scale:2
                                           raiseOnExactness:NO
                                           raiseOnOverflow:NO
                                           raiseOnUnderflow:NO
                                           raiseOnDivideByZero:YES];
    if (qidou>=10000) {
        NSDecimalNumber *total = [[NSDecimalNumber decimalNumberWithString:self] decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:@"10000"] withBehavior:roundUp];
        NSString *priceStr = Str(@"%@万",total);
        return priceStr;
    }else
    {
        return self;
    }
    
}
//不四舍五入
- (NSString *)formatWithQidouTwoPoint
{
    NSInteger qidou = [self integerValue];
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler
                                           decimalNumberHandlerWithRoundingMode:NSRoundDown
                                           scale:2
                                           raiseOnExactness:NO
                                           raiseOnOverflow:NO
                                           raiseOnUnderflow:NO
                                           raiseOnDivideByZero:YES];
    if (qidou>=10000) {
        NSDecimalNumber *total = [[NSDecimalNumber decimalNumberWithString:self] decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:@"10000"] withBehavior:roundUp];
        NSString *priceStr = Str(@"%.2f万",[total floatValue]);
        return priceStr;
    }else
    {
        return self;
    }
    
}
//四舍五入
- (NSString *)formatWithQidouTwoPointByRounded
{
    NSInteger qidou = [self integerValue];
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler
                                           decimalNumberHandlerWithRoundingMode:NSRoundBankers
                                           scale:2
                                           raiseOnExactness:NO
                                           raiseOnOverflow:NO
                                           raiseOnUnderflow:NO
                                           raiseOnDivideByZero:YES];
    if (qidou>=10000) {
        NSDecimalNumber *total = [[NSDecimalNumber decimalNumberWithString:self] decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:@"10000"] withBehavior:roundUp];
        NSString *priceStr = Str(@"%.2f万",[total floatValue]);
        return priceStr;
    }else
    {
        return self;
    }
    
}


-(NSString*)removeFloatAllZero
{
    NSString * testNumber = self;
    NSString * outNumber = [NSString stringWithFormat:@"%@",@(testNumber.floatValue)];
    
    return outNumber;
    
}

@end
