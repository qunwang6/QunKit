//
//  UIView+DL.h
//  DLFoundation
//
//  Created by cyp on 2021/5/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


#pragma mark - 点击事件相关

@interface UIView (DLTouch)

///扩大点击区域
@property (nonatomic, assign) UIEdgeInsets dl_touchExtends;

///点击回调
- (void)onTap:(void(^)(void))callback;

@end




#pragma mark - Layer相关

@interface UIView (DLLayer)

///单独设置顶部两个圆角
- (void)dl_setTopCornerWithRadius:(CGFloat)radius;
///单独设置底部两个圆角
- (void)dl_setBottomCornerWithRadius:(CGFloat)radius;
///单独设置左侧两个圆角
- (void)dl_setLeftCornerWithRadius:(CGFloat)radius;
///单独设置右侧两个圆角
- (void)dl_setRightCornerWithRadius:(CGFloat)radius;
///设置指定位置的圆角（使用系统方法，圆角大小必须相同）
- (void)dl_setCorner:(UIRectCorner)corner radius:(CGFloat)radius;
///设置指定位置的圆角（使用maskLayer，圆角大小可以不同）
- (void)dl_setCornerRadiusForTopLeft:(CGFloat)tlRadius topRight:(CGFloat)trRadius bottomLeft:(CGFloat)blRadius bottomRight:(CGFloat)brRadius;

///设置阴影
- (void)dl_setShadowOpacity:(CGFloat)opacity radius:(CGFloat)radius;    //offset默认为CGSizeZero
- (void)dl_setShadowOpacity:(CGFloat)opacity radius:(CGFloat)radius offset:(CGSize)offset;

///设置边框
- (void)dl_setBorderWidth:(CGFloat)width color:(UIColor *_Nullable)color;

@end




#pragma mark - 约束

@interface UIView (DLCons)

///添加宽高约束（NAN时表示不设置约束）
- (void)dl_pinWidth:(CGFloat)width height:(CGFloat)height;

@end




#pragma mark - 子视图相关

@interface UIView (DLSubViews)

///添加子视图并设置四周约束（insets属性值为NAN时表示该方向不设置约束）
- (void)dl_addSubview:(UIView *)view insets:(UIEdgeInsets)insets;
- (void)dl_addSubview:(UIView *)view insets:(UIEdgeInsets)insets height:(CGFloat)height;

///添加子视图并设置中心点约束
- (void)dl_addSubview:(UIView *)view centerOffset:(CGPoint)offset;


///递归获取所有指定类型的子视图，targetClass传nil则返回所有子视图
-(NSArray *)dl_getRecursiveSubviewsWithClass:(Class)targetClass;

///删除所有子视图
- (void)dl_removeAllSubViews;

@end




#pragma mark - 截图

@interface UIView (DLSnapShot)

///截图
- (UIImage *)dl_snapshot;

@end




#pragma mark - 创建View

@interface UIView (DLCreation)

///从xib加载
+ (instancetype)dl_loadFromXib;
///从指定bundle里的xib加载
+ (instancetype)dl_loadFromXibInBundle:(NSString *)bundleName;

///拷贝一份完全一样的view（注意不支持runtime attribute）
- (instancetype)dl_copy;

@end


NS_ASSUME_NONNULL_END
