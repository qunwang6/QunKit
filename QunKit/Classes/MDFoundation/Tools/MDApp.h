//
//  MDApp.h
//  shop
//
//  Created by 陈芳 on 2021/12/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MDApp;

///使用app全局变量来访问
extern MDApp *app;

@interface MDApp : NSObject

#pragma mark - App相关信息

///app名称
@property (nonatomic, readonly) NSString *name;
///app版本号
@property (nonatomic, readonly) NSString *version;
///build号
@property (nonatomic, readonly) NSString *buildVersion;
///包名
@property (nonatomic, readonly) NSString *bundleIdentifier;
//60*60的App图标
@property (nonatomic, readonly) UIImage *icon;

///是否是刘海屏
@property (nonatomic, readonly) BOOL hasNotch;

@property (nonatomic, copy) NSString * surprisedShareImags;
@property (nonatomic, copy) NSString * shareSeckillImags;
@property (nonatomic, assign) NSInteger switchBox;
@property (nonatomic, assign) NSInteger switchCoupon;
@property (nonatomic, assign) NSInteger switchPicked;
@property (nonatomic, assign) NSInteger switchSeckill;
@property (nonatomic, assign) NSInteger switchSign;
@property (nonatomic, assign) NSInteger switchSurprised;
@property (nonatomic, assign) NSInteger switchWish;
@property (nonatomic, copy) NSString * cardEmptyImags;//卡片无数据占位弹框图
@property (nonatomic, copy) NSString * couponEmptyImags;//优惠券无数据占位弹框图
@property (nonatomic, copy) NSString * signEmptyImags;//每日寻宝无数据占位弹框图
@property (nonatomic, assign) NSInteger limitBoxMoney;
@property (nonatomic, assign) CGFloat waitingPayTime;


@end

#pragma mark - 页面跳转

@interface MDApp (Controller)

///主widnow
@property (nonatomic, readonly) UIWindow *window;
///keyWidnow
@property (nonatomic, readonly) UIWindow *keyWindow;
///当前控制器
@property (nonatomic, readonly) UIViewController *topVC;

///push控制器
- (void)pushVC:(UIViewController *)vc;      //animated为YES
- (void)pushVC:(UIViewController *)vc animated:(BOOL)animated;

///pop控制器
- (void)popVCAnimated:(BOOL)animated;
- (BOOL)popToVCWithClass:(Class)vcClass animated:(BOOL)animated;    //pop到第一个指定类的控制器
- (void)popToRootVCAnimated:(BOOL)animated;

///present控制器
- (void)presentVC:(UIViewController *)vc;   //animated为YES
- (void)presentVC:(UIViewController *)vc animated:(BOOL)animated completion:(void(^_Nullable)(void))completion;

///dismiss控制器
- (void)dismissVC;                          //animated为YES
- (void)dismissVCAnimated:(BOOL)animated completion:(void(^_Nullable)(void))completion;

///切换tab控制器,跳转到对应的index
- (void)selectTabWithIndex:(NSInteger)index;

@end


#pragma mark - 提示相关

@interface MDApp (Prompt)

///Toast提示（2秒后自动消失）
- (void)showToast:(id)msg;
- (void)hideToast;

///Loading提示
- (void)showLoading;
- (void)showLoading:(NSString *)msg;
- (void)hideLoading;

- (void)showLightLoading;
- (void)showLightLoading:(NSString *)msg;

///系统弹窗，message可传字符串或数组 @[@"title", @"message"]
- (UIAlertController *)showAlert:(id)message
                         okTitle:(NSString *)okTitle
                         okClick:(void(^_Nullable)(void))okClick;

- (UIAlertController *)showAlert:(id)message
                         okTitle:(NSString *)okTitle
                         okClick:(void(^_Nullable)(void))okClick
                     cancelTitle:(NSString *)cancelTitle
                     cancelClick:(void(^_Nullable)(void))cancelClick;

///系统ActionSheet，message可传字符串或数组 @[@"title", @"message"]
- (UIAlertController *)showActionSheet:(id _Nullable)message
                          optionTitles:(NSArray *_Nullable)optionTitles
                           optionClick:(void (^_Nullable)(NSInteger index))optionClick
                           cancelTitle:(NSString *_Nullable)cancelTitle
                           cancelClick:(void(^_Nullable)(void))cancelClick;

- (UIAlertController *)showActionSheet:(id _Nullable)message
                          optionTitles:(NSArray *_Nullable)optionTitles
                           optionClick:(void (^_Nullable)(NSInteger index))optionClick
                      destructiveTitle:(NSString *_Nullable)destructiveTitle
                      destructiveClick:(void(^_Nullable)(void))destructiveClick
                           cancelTitle:(NSString *_Nullable)cancelTitle
                           cancelClick:(void(^_Nullable)(void))cancelClick;

@end

NS_ASSUME_NONNULL_END
