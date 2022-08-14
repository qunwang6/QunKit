//
//  PublishTool.m
//  shop
//
//  Created by 陈芳 on 2022/2/8.
//

#import "PublishTool.h"

@implementation PublishTool
+ (UIImage*)screenShotWithView:(UIView*)view
{
//    NSLog(@"截屏的view大小:%@", NSStringFromCGRect(view.frame));
    UIGraphicsBeginImageContextWithOptions(view.frame.size, YES, [UIScreen mainScreen].scale);     //设置截屏大小
    [[view layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}

/**
 获取url的所有参数
 @param url 需要提取参数的url
 @return NSDictionary
 */
+(NSDictionary *)parameterWithURL:(NSURL *)url {
 
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
 
    //传入url创建url组件类
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:url.absoluteString];
 
    //回调遍历所有参数，添加入字典
    [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [parm setObject:obj.value forKey:obj.name];
    }];
 
    return parm;
}

//把多个json字符串转为一个json字符串

+ (NSString *)objArrayToJSON:(NSArray *)array {
    NSString *jsonStr = @"[";
    for (NSInteger i = 0; i < array.count; ++i) {
        if (i != 0) {
            jsonStr = [jsonStr stringByAppendingString:@","];
        }
        jsonStr = [jsonStr stringByAppendingString:array[i]];
    }
    jsonStr = [jsonStr stringByAppendingString:@"]"];
    return jsonStr;
}

@end
