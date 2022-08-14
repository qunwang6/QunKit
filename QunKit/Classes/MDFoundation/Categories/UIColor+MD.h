//
//  UIColor+MD.h
//  shop
//
//  Created by 陈芳 on 2021/12/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (MD)
///"#FFFFFF", "#FFFFFF,0.5"
+ (UIColor *_Nullable)dl_colorWithHEX:(NSString *)hex;

///"255,255,255", "255,255,255,0.5"
+ (UIColor *_Nullable)dl_colorWithRGB:(NSString *)rgb;

@end

NS_ASSUME_NONNULL_END
