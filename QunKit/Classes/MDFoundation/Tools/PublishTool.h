//
//  PublishTool.h
//  shop
//
//  Created by 陈芳 on 2022/2/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PublishTool : NSObject
//截屏
+ (UIImage*)screenShotWithView:(UIView*)view;
//URL 包含的参数转字典
+(NSDictionary *)parameterWithURL:(NSURL *)url;
@end

NS_ASSUME_NONNULL_END
