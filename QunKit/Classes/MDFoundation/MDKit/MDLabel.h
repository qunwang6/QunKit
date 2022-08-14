//
//  MDLabel.h
//  shop
//
//  Created by 陈芳 on 2021/12/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MDLabel : NSObject
+ (UILabel*)dl_labelWithText:(NSString * _Nullable)string textColor:(UIColor * _Nullable)textColor font:(UIFont *_Nullable)font;

@end

NS_ASSUME_NONNULL_END
