//
//  MDStringUtils.h
//  shop
//
//  Created by 陈芳 on 2021/12/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MDStringUtils : NSObject
///是否包含数字
+ (BOOL)containsDigit:(NSString *)string;
///是否只包含数字
+ (BOOL)containsOnlyDigit:(NSString *)string;

///是否包含英文字母
+ (BOOL)containsAlphabet:(NSString *)string;
///是否只包含英文字母
+ (BOOL)containsOnlyAlphabet:(NSString *)string;

///是否包含中文
+ (BOOL)containsChinese:(NSString *)string;
///是否只包含中文
+ (BOOL)containsOnlyChinese:(NSString *)string;

///是否包含emoji
+ (BOOL)containsEmoji:(NSString *)string;

///是否是有效的手机号码
+ (BOOL)isValidMobileNumber:(NSString *)string;
///是否是有效的身份证号码
+ (BOOL)isValidIdNumber:(NSString *)string;

#pragma mark -- 判断手机型号
+ (NSString *)iphoneType;
@end

NS_ASSUME_NONNULL_END
