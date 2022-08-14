//
//  JHUD.m
//  JHudViewDemo
//
//  Created by 晋先森 on 16/7/11.
//  Copyright © 2016年 晋先森. All rights reserved.
//  https://github.com/jinxiansen
//

#import "JHUD.h"
#import "UIImage+JHUD.h"

#define KLastWindow [[UIApplication sharedApplication].windows lastObject]

//#define JHUDMainThreadAssert() NSAssert([NSThread isMainThread], @"JHUD needs to be accessed on the main thread.");


#pragma mark -  JHUD Class

@interface JHUD ()

@property (nonatomic) JHUDLoadingType hudType;

@property (nonatomic,strong) UIImageView  *imageView;

@end

@implementation JHUD

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureBaseInfo];
        [self configureSubViews];
    }
    return self;
}

-(void)configureBaseInfo
{
    self.backgroundColor = [UIColor whiteColor];
    self.indicatorViewSize = CGSizeMake(100, 100);
}

-(void)configureSubViews
{
    [self addSubview:self.indicatorView];
    
    [self addSubview:self.messageLabel];
    
    [self addSubview:self.refreshButton];
    
    [self.indicatorView addSubview:self.loadingView];
    [self.indicatorView addSubview:self.imageView];
}

#pragma mark - show method 

-(void)showAtView:(UIView *)view hudType:(JHUDLoadingType)hudType
{
    self.hidden = NO;
    
    NSAssert(![self isEmptySize], @"啊! JHUD 的 size 没有设置正确 ！self.frame not be nil(JHUD)");
    
    self.hudType = hudType;
    
    [self hide];
    
    [self setupSubViewsWithHudType:hudType];
    
    [self dispatchMainQueue:^{
        
        view ? [view addSubview:self]:[KLastWindow addSubview:self];
        [self.superview bringSubviewToFront:self];
    }];
}

+(void)showAtView:(UIView *)view message:(NSString *)message
{
    [self showAtView:view message:message hudType:JHUDLoadingTypeCircle];
}

+(void)showAtView:(UIView *)view message:(NSString *)message hudType:(JHUDLoadingType)hudType
{
    JHUD * hud = [[self alloc]initWithFrame:view.bounds];
    hud.messageLabel.text = message;

    [hud showAtView:view hudType:hudType];
}

+(void)hideForView:(UIView *)view
{
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:self]) {
            JHUD * hud = (JHUD *)subview;
            [hud hide];
        }
    }
}

-(void)hide
{
    [self dispatchMainQueue:^{
        if (self.superview) {
            [self removeFromSuperview];
            [self.loadingView removeSubLayer];
        }
    }];
}

-(void)hideAfterDelay:(NSTimeInterval)afterDelay
{
    [self performSelector:@selector(hide) withObject:nil afterDelay:afterDelay];
}

-(void)setGifImageData:(NSData *)gifImageData
{
    _gifImageData = gifImageData;

    UIImage * image = [UIImage jHUDImageWithSmallGIFData:gifImageData scale:1];
    self.imageView.image = image;
}

-(void)setindicatorViewSize:(CGSize)indicatorViewSize
{
    _indicatorViewSize = indicatorViewSize;
    
    [self setNeedsUpdateConstraints];
}

-(void)setCustomAnimationImages:(NSArray *)customAnimationImages
{
    _customAnimationImages = customAnimationImages;
    
    if (customAnimationImages.count>1) {
        self.imageView.animationImages = _customAnimationImages;
        [self.imageView startAnimating];
    }
    [self setNeedsUpdateConstraints];
}

-(void)setCustomImage:(UIImage *)customImage
{
    _customImage = customImage;
    
    [self.imageView stopAnimating];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.image = customImage;
}

-(void)setIndicatorBackGroundColor:(UIColor *)indicatorBackGroundColor
{
    _indicatorBackGroundColor = indicatorBackGroundColor;

    self.loadingView.defaultBackGroundColor = _indicatorBackGroundColor;
}

-(void)setIndicatorForegroundColor:(UIColor *)indicatorForegroundColor
{
    _indicatorForegroundColor = indicatorForegroundColor;
    
    self.loadingView.foregroundColor = _indicatorForegroundColor;
}

+(BOOL)requiresConstraintBasedLayout
{
    return YES;
}

- (void)setupSubViewsWithHudType:(JHUDLoadingType)hudType
{
    hudType == JHUDLoadingTypeFailure ? [self isShowRefreshButton:YES]:
                                        [self isShowRefreshButton:NO];
    
    if ( hudType >2 ) {
        self.imageView.hidden = NO;
        [self.loadingView removeFromSuperview];
        
    }else
    {
        self.imageView.hidden = YES;
        
        //The size of the fixed loadingView .
//        self.indicatorViewSize = CGSizeMake(100, 100);

        if (!self.loadingView.superview) {
            [self.indicatorView addSubview:self.loadingView];
        }
    }
    
    switch (hudType) {
        case JHUDLoadingTypeCircle:
            [self.loadingView showAnimationAtView:self animationType:JHUDAnimationTypeCircle];
            break;
        case JHUDLoadingTypeCircleJoin:
            [self.loadingView showAnimationAtView:self animationType:JHUDAnimationTypeCircleJoin];
            break;
        case JHUDLoadingTypeDot:
            [self.loadingView showAnimationAtView:self animationType:JHUDAnimationTypeDot];
            break;
        case JHUDLoadingTypeCustomAnimations:
            break;
        case JHUDLoadingTypeGifImage:
            break;
        case JHUDLoadingTypeFailure:
            break;

        default:
            break;
    }
    
}

#pragma mark  --  Lazy method

-(JHUDAnimationView *)loadingView
{
    if (_loadingView) {
        return _loadingView;
    }
    _loadingView = [[JHUDAnimationView alloc]init];
    _loadingView.translatesAutoresizingMaskIntoConstraints = NO;
    _loadingView.backgroundColor = [UIColor clearColor];
    
    return _loadingView;
}

-(UIView *)indicatorView
{
    if (_indicatorView) {
        return _indicatorView;
    }
    _indicatorView = [[UIView alloc]init];
    _indicatorView.translatesAutoresizingMaskIntoConstraints = NO;
    _indicatorView.backgroundColor = [UIColor clearColor];
    
    return _indicatorView;
}

-(UIImageView *)imageView
{
    if (_imageView) {
        return _imageView;
    }
    _imageView = [[UIImageView alloc]init];
    _imageView.translatesAutoresizingMaskIntoConstraints = NO ;
    _imageView.animationDuration = 1;
    _imageView.animationRepeatCount = 0;
    
    return _imageView;
}

-(UILabel *)messageLabel
{
    if (_messageLabel) {
        return _messageLabel;
    }
    _messageLabel = [UILabel new];
    _messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _messageLabel.textAlignment = NSTextAlignmentCenter ;
    _messageLabel.text = @"正在加载中";
    _messageLabel.textColor = Color(@"A3A3A3");
    _messageLabel.font = Bold(14);
    _messageLabel.backgroundColor = [UIColor clearColor];
    _messageLabel.numberOfLines = 0;
    
    return _messageLabel;
}

-(UIButton *)refreshButton
{
    if (_refreshButton) {
        return _refreshButton;
    }
    _refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _refreshButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_refreshButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_refreshButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    _refreshButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    _refreshButton.titleLabel.font = Regular(16);
    [_refreshButton setTitle:@"点击重新加载" forState:UIControlStateNormal];
    _refreshButton.layer.cornerRadius = 24.5;
    [_refreshButton setBackgroundColor:Color(@"#FF8827")];
    [_refreshButton addTarget:self action:@selector(refreshButtonClick) forControlEvents:UIControlEventTouchUpInside];
    return _refreshButton;
}


#pragma mark  --  updateConstraints 

-(void)updateConstraints
{
    [self removeAllConstraints];
    
    [self.refreshButton removeAllConstraints];
    [self.messageLabel removeConstraintWithAttribte:NSLayoutAttributeWidth];
    [self.indicatorView removeAllConstraints];
    [self.loadingView removeAllConstraints];
    [self.imageView removeAllConstraints];
    
    // messageLabel.constraint
    [self addConstraintCenterXToView:self.messageLabel centerYToView:self.messageLabel];
    [self.messageLabel addConstraintWidth:SCREEN_WIDTH - 30 height:0];
    
    // indicatorView.constraint
    if (_isSmallView) {
        self.messageLabel.hidden = YES;
        [self addConstraintCenterXToView:self.indicatorView centerYToView:self.indicatorView];
    }else{
        [self addConstraintCenterXToView:self.indicatorView centerYToView:nil];
        [self addConstarintWithTopView:self.indicatorView toBottomView:self.messageLabel constarint:20];
    }
    [self.indicatorView addConstraintWidth:self.indicatorViewSize.width height:self.indicatorViewSize.height];
    // imageView.constraint
    [self.indicatorView addConstraintCenterXToView:self.imageView centerYToView:self.imageView];
    [self.imageView addConstraintWidth:self.indicatorViewSize.width height:self.indicatorViewSize.height];
    
    // loadingView.constraint
    if (self.loadingView.superview) {
        [self.indicatorView addConstraintCenterXToView:self.loadingView centerYToView:self.loadingView];
        [self.loadingView addConstraintWidth:self.indicatorViewSize.width height:self.indicatorViewSize.height];
        
    }
    // refreshButton..constraint
    [self addConstraintCenterXToView:self.refreshButton centerYToView:nil];
    [self addConstarintWithTopView:self.messageLabel toBottomView:self.refreshButton constarint:30];
    [self.refreshButton addConstraintWidth:_refreshButtonWidth==0?160:_refreshButtonWidth height:49];
    
    //    NSLog(@"self.constraint.count %lu ",self.constraints.count);
    
    [super updateConstraints];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

#pragma mark - other method

-(void)isShowRefreshButton:(BOOL)isShowRefreshButton
{
    if (isShowRefreshButton) {
        
        self.refreshButton.hidden = NO;
    } else {
        self.refreshButton.hidden = YES;
    }
}

// When JHUDLoadingType >2, there will be a "refresh" button, and the method.
-(void)refreshButtonClick
{
    [self.loadingView removeSubLayer];
    
    if (self.JHUDReloadButtonClickedBlock) {
        self.JHUDReloadButtonClickedBlock();
    }
}

-(BOOL)isEmptySize
{
    if (self.frame.size.width>0 && self.frame.size.height >0) {
        return NO;
    }
    return YES;
}

@end

#pragma mark - UIView (MainQueue)

@implementation UIView (MainQueue)

-(void)dispatchMainQueue:(dispatch_block_t)block
{
    dispatch_async(dispatch_get_main_queue(), ^{
        block();
    });
}

@end






