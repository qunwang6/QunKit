//
//  NSObject+MD.h
//  shop
//
//  Created by 陈芳 on 2021/12/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (MD)
///判断是否重写了父类的方法
+ (BOOL)dl_isOverridingSuperclassMethod:(SEL)method;


///替换类方法
+ (void)dl_swizzleClassSelector:(SEL)originalSelector withOtherSelector:(SEL)otherSelector;
///替换成员方法
+ (void)dl_swizzleInstanceSelector:(SEL)originalSelector withOtherSelector:(SEL)otherSelector;


///存储关联属性
- (nullable id)dl_associatedObjectForKey:(NSString *)key;
///访问存储的关联属性
- (void)dl_setAssociatedObject:(nullable id)object forKey:(NSString *)key;


///获取所有属性名
- (NSArray<NSString *> *)dl_getAllProperties;


@end

NS_ASSUME_NONNULL_END
