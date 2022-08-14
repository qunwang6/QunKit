//
//  VSProressHudView.h
//  VidSai
//
//  Created by 陈芳 on 2017/12/21.
//  Copyright © 2017年 Vidsai. All rights reserved.
//

#import "JHUD.h"

/**
 加载遮罩层
 (对JHUD进行二次封装，目前只用到其中一种JHUDLoadingType)
 */

typedef enum : NSInteger{
    HudBlockTypeReload = 0,         //重新刷新
    HudBlockTypeCompleteInfo = 1,   //完善企业信息
    HudBlockTypeMakeWish = 2,
}HudBlockType;

@interface GBProressHudView : JHUD
///显示的superView
@property (nonatomic, strong) UIView *showSuperView;
@property (nonatomic) HudBlockType blockType;
@property (nonatomic,copy)  void(^GBProressHudViewCompleteInfoBlock)(void);
@property (nonatomic,copy)  void(^GBProressHudViewReloadBlock)(void);
@property (nonatomic,copy)  void(^GBProressHudViewMakeWishBlock)(void);

///正在加载中
- (void)show;

/**
 自定义提示语的加载
 
 @param message 自定义提示语
 */
- (void)showWithMessage:(NSString *)message;

///无数据显示
- (void)showNoData;

///默认的加载失败
- (void)showError;

///无网络的加载失败
- (void)showErrorWithNoNet;

/**
 自定义图片和提示语的无数据显示
 
 @param imgStr 图片名称
 @param message 提示语
 */
- (void)showNoDataWithImg:(NSString *)imgStr message:(NSString *)message;

/**
 加载失败-自定义错误提示
 @param imgStr 图片名称
 @param msg 错误提示语
 */
- (void)showErrorWithImg:(NSString *)imgStr message:(NSString *)msg;

/**
 加载失败-自定义错误提示
 @param imgStr 图片名称
 @param msg 错误提示语
 @param buttonTitle 按钮名称
 */
- (void)showErrorWithImg:(NSString *)imgStr message:(NSString *)msg buttonTitle:(NSString *)buttonTitle;

/**
 加载失败-自定义错误提示
 @param imgStr 图片名称
 @param msg 错误提示语
 @param buttonTitle 按钮名称
 @param buttonWidth 按钮宽度
 */
- (void)showErrorWithImg:(NSString *)imgStr message:(NSString *)msg buttonTitle:(NSString *)buttonTitle buttonWidth:(CGFloat)buttonWidth;

///隐藏
- (void)dismiss;

@end

