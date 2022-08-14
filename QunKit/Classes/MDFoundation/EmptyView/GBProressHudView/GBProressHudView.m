//
//  VSProressHudView.m
//  VidSai
//
//  Created by 陈芳 on 2017/12/21.
//  Copyright © 2017年 Vidsai. All rights reserved.
//

#import "GBProressHudView.h"

@implementation GBProressHudView

///正在加载中
- (void)show
{
    [self showWithMessage:@"正在加载中"];
}

/**
 自定义提示语的加载
 
 @param message 自定义提示语
 */
- (void)showWithMessage:(NSString *)message
{
    self.messageLabel.text = message;
    self.messageLabel.font = Bold(16);
    self.indicatorViewSize = CGSizeMake(80, 80);
    self.refreshButton.hidden = YES;
    if (!self.superview && self.showSuperView) {
        [self.showSuperView addSubview:self];
    }
    [self showAtView:self.superview hudType:JHUDLoadingTypeCircle];
}

///无数据显示
- (void)showNoData
{
    [self showNoDataWithImg:@"order_list" message:@"没有任何数据耶~"];
}

///默认的加载失败
- (void)showError
{
    [self showErrorWithImg:@"serverError" message:@"服务器出现异常~"];
}

///无网络的加载失败
- (void)showErrorWithNoNet
{
    [self showErrorWithImg:@"icon_notice_no_net" message:@"网络请求失败~"];
}

/**
 自定义图片和提示语的无数据显示
 
 @param imgStr 图片名称
 @param message 提示语
 */
- (void)showNoDataWithImg:(NSString *)imgStr message:(NSString *)message
{
    self.indicatorViewSize = CGSizeMake(125, 125);
    self.messageLabel.text = message;
    self.customImage = [UIImage imageNamed:imgStr.length==0?@"order_list":imgStr];
    if (!self.superview && self.showSuperView) {
        [self.showSuperView addSubview:self];
    }
    self.messageLabel.font = Medium(16);
    self.messageLabel.textColor = Color(@"#666666");
    self.showSuperView.backgroundColor = Color(@"#C7C3BC");
    [self showAtView:self.superview hudType:JHUDLoadingTypeNoData];
}

/**
 加载失败-自定义错误提示

 @param msg 错误提示语
 */
- (void)showErrorWithImg:(NSString *)imgStr message:(NSString *)msg
{
    [self showErrorWithImg:imgStr.length==0?@"order_list":imgStr message:msg buttonTitle:@"点击重新加载"];
}

/**
 加载失败-自定义错误提示
 @param imgStr 图片名称
 @param msg 错误提示语
 @param buttonTitle 按钮名称
 */
- (void)showErrorWithImg:(NSString *)imgStr message:(NSString *)msg buttonTitle:(NSString *)buttonTitle
{
    [self showErrorWithImg:imgStr message:msg buttonTitle:buttonTitle buttonWidth:186];
}

/**
 加载失败-自定义错误提示
 @param imgStr 图片名称
 @param msg 错误提示语
 @param buttonTitle 按钮名称
 @param buttonWidth 按钮宽度
 */
- (void)showErrorWithImg:(NSString *)imgStr message:(NSString *)msg buttonTitle:(NSString *)buttonTitle buttonWidth:(CGFloat)buttonWidth
{
    self.indicatorViewSize = CGSizeMake(125, 125);
    self.messageLabel.text = msg;
    [self.refreshButton setTitle:buttonTitle.length==0?@"点击重新加载":buttonTitle forState:UIControlStateNormal];
    self.refreshButtonWidth = buttonWidth;
    self.customImage = [UIImage imageNamed:imgStr.length==0?@"order_list":imgStr];
    if (!self.superview && self.showSuperView) {
        [self.showSuperView addSubview:self];
    }
    self.messageLabel.font = Medium(16);
    self.messageLabel.textColor = Color(@"#666666");
    self.showSuperView.backgroundColor = Color(@"#C7C3BC");
    [self showAtView:self.superview hudType:JHUDLoadingTypeFailure];
}

///隐藏
- (void)dismiss
{
    [self hide];
}

///点击重新加载
-(void)refreshButtonClick
{
    [self.loadingView removeSubLayer];
    
    if (_blockType == HudBlockTypeCompleteInfo) {
        if (self.GBProressHudViewCompleteInfoBlock) {
            self.GBProressHudViewCompleteInfoBlock();
        }
    }else if (_blockType == HudBlockTypeMakeWish) {
        if (self.GBProressHudViewMakeWishBlock) {
            self.GBProressHudViewMakeWishBlock();
        }
    }
    else
    {
        if (self.GBProressHudViewReloadBlock) {
            self.GBProressHudViewReloadBlock();
        }
    }
}

@end
