//
//  NSAttributedString+MD.h
//  shop
//
//  Created by 陈芳 on 2021/12/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, DLMatchType) {
    DLMatchTypeURL,         //匹配URL
    DLMatchTypeNumber,      //匹配带小数的数字
    DLMatchTypeHashTag,     //匹配#标签
    DLMatchTypeAtTag,       //匹配@标签
    DLMatchTypeAll,         //匹配全部字符串
};

@interface NSAttributedString (MD)
///计算字符串高度
- (CGSize)dl_sizeWithMaxWidth:(CGFloat)maxWidth;


@end

//使用链式语法来进行属性设置，默认对整串字符串进行处理，选中子串后后续操作只对子串生效
@interface NSMutableAttributedString (DLChain)

///字体
///cusfnt
///
@property (nonatomic, readonly) NSMutableAttributedString *(^cusfnt)(CGFloat fontSize);
@property (nonatomic, readonly) NSMutableAttributedString *(^fnt)(CGFloat fontSize);
@property (nonatomic, readonly) NSMutableAttributedString *(^boldFnt)(CGFloat fontSize);

///字体颜色（支持Color()所支持的所有参数类型）
@property (nonatomic, readonly) NSMutableAttributedString *(^textColor)(id color);
///背景颜色（支持Color()所支持的所有参数类型）
@property (nonatomic, readonly) NSMutableAttributedString *(^bgColor)(id color);

///下划线
@property (nonatomic, readonly) NSMutableAttributedString *(^underline)(void);
///删除线
@property (nonatomic, readonly) NSMutableAttributedString *(^strikeThrough)(void);
///变成链接（配合UITextView来使用）
@property (nonatomic, readonly) NSMutableAttributedString *(^toLink)(void);

///行间距
@property (nonatomic, readonly) NSMutableAttributedString *(^lineGap)(CGFloat lineSpacing);
///对齐方式
@property (nonatomic, readonly) NSMutableAttributedString *(^align)(NSTextAlignment alignemnt);
///baseline偏移量（正数往上移，负数往下移）
@property (nonatomic, readonly) NSMutableAttributedString *(^offset)(CGFloat baselineOffset);

///选中子串，后续操作将只对子串生效
@property (nonatomic, readonly) NSMutableAttributedString *(^select)(id regExp);        //regExp可以为单个正则表达式字符串或者正则表达式字符串数组
@property (nonatomic, readonly) NSMutableAttributedString *(^selectRange)(NSInteger location, NSInteger length);    //选中指定的范围
@property (nonatomic, readonly) NSMutableAttributedString *(^match)(DLMatchType type);  //选中特性的类型

@end


NS_ASSUME_NONNULL_END
