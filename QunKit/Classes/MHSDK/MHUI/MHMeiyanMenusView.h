//
//  MHMeiyanMenusView.h


#import <UIKit/UIKit.h>
#import <MHBeautySDK/MHBeautySDK.h>
NS_ASSUME_NONNULL_BEGIN
@protocol MHMeiyanMenusViewDelegate <NSObject>
/**
美颜，只适用于腾讯直播/短视频。在该方法中实现腾讯的美颜方法
 @param beauty 磨皮 0-9，数值越大，效果越明显
 @param white 美白 0-9，数值越大，效果越明显
 @param ruddiness 红润 0-9，数值越大，效果越明显
 */
- (void)beautyEffectWithLevel:(NSInteger)beauty whitenessLevel:(NSInteger)white ruddinessLevel:(NSInteger)ruddiness;
- (void)cameraAction;
//短视频录制按键回调
- (void)recordAction;
@end
@interface MHMeiyanMenusView : UIView

/// 初始化美颜菜单（推荐使用）
/// @param frame frame
/// @param superView 所要添加到的视图
/// @param manager  美颜管理器，完成初始化后传入
/// 该方法默认使用美狐相关功能，不需要实现MHMeiyanMenusViewDelegate中的美颜方法
- (instancetype)initWithFrame:(CGRect)frame superView:(UIView *)superView beautyManager:(MHBeautyManager *)manager;

/// 初始化美颜菜单
/// @param frame frame
/// @param superView 所要添加到的视图
/// @param delegate 代理
/// @param manager  美颜管理器，完成初始化后传入
///该方法中美颜（美白磨皮默认使用腾讯美颜）即需要实现MHMeiyanMenusViewDelegate中的美颜方法
- (instancetype)initWithTXBeautyFrame:(CGRect)frame superView:(UIView *)superView delegate:(id<MHMeiyanMenusViewDelegate>)delegate beautyManager:(MHBeautyManager *)manager;

/// 初始化美颜菜单
/// @param frame frame
/// @param superView 所要添加到的视图
/// @param delegate 代理
/// @param manager  美颜管理器，完成初始化后传入
/// @param isTx 是否使用腾讯直播默认美颜（美白磨皮红润），NO表示使用美狐功能，YES表示
/// 使用腾讯直播的美颜。即需要实现MHMeiyanMenusViewDelegate中的美颜方法
/// 2.5.3及之前的版本使用，2.5.3之后的版本不建议使用，会逐步废弃该方法
- (instancetype)initWithFrame:(CGRect)frame superView:(UIView *)superView delegate:(id<MHMeiyanMenusViewDelegate>)delegate beautyManager:(MHBeautyManager *)manager isTXSDK:(BOOL)isTx;

///调用上次设置的美颜数据，实现保存美颜的功能
- (void)setupDefaultBeautyAndFaceValue;

/**
 控制美颜菜单显示

 @param show YES表示显示，NO表示隐藏
 */
- (void)showMenuView:(BOOL)show;

@property (nonatomic, weak) id<MHMeiyanMenusViewDelegate> delegate;

/**
 获取当前美颜菜单显示状态，YES：显示，NO：隐藏
 */
@property (nonatomic, assign,getter=isShow) BOOL show;

/**
是否是腾讯直播SDK，YES：是，NO：其他直播SDK
*/

@property (nonatomic, assign) BOOL isTX;

/*
 美狐sdk底部选项框内容信息数组
 */
@property (nonatomic, strong) NSMutableArray *array;

/*
 是否隐藏除拍摄按钮外的其他按钮
 */
- (void)showMenusWithoutRecord:(BOOL)show;

- (void)animationOfTakingPhoto;



@end

NS_ASSUME_NONNULL_END
