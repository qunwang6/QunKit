//
//  NSArray+MD.h
//  shop
//
//  Created by 陈芳 on 2021/12/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (MD)

//map, filter, reduce
- (NSArray *)dl_map:(id(^)(id obj))block;
- (NSArray *)dl_filter:(BOOL(^)(id obj))block;
- (id)dl_reduce:(id(^)(id obj, id current))block withInitializer:(id<NSCopying>)initializer;

///遍历数组
- (NSArray *)dl_forEach:(void(^)(id obj))block;


///转成JSON字符串
- (NSString *_Nullable)dl_toJSONString;

@end

NS_ASSUME_NONNULL_END
