//
//  MHBottomView.m
//  TXLiteAVDemo_UGC
//
//  Created by Apple on 2021/2/27.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "MHBottomView.h"
@interface MHBottomView ()
@property (nonatomic, strong) UIButton * takePhotoBtn;
@property (nonatomic, strong) UIButton * packUpBtn;
@end
@implementation MHBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createSubviews];

    }
    return self;
}


#pragma mark - 穿透点击
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = [super hitTest:point withEvent:event];

        if (hitView == self) {
            return nil; // 此处返回空即不相应任何事件
        }
        return hitView;
}

#pragma mark - 创建子视图
- (void)createSubviews{
    CGFloat width = self.frame.size.width;
    CGFloat takePhotoWidth = 50;
    CGFloat takePhotoHeight = takePhotoWidth;
    CGFloat packUpWidth = 17;
    CGFloat packUpHeight = packUpWidth/11*6;
    CGFloat leftMargin = 45;
    
    
    _takePhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _takePhotoBtn.frame = CGRectMake((width-takePhotoWidth)/2, 0, takePhotoWidth, takePhotoHeight);
    _takePhotoBtn.tag = 1000;
    UIImage * cameraImage  = BundleImg(@"beautyCamera");
    [_takePhotoBtn setBackgroundImage:cameraImage forState:UIControlStateNormal];
    [_takePhotoBtn addTarget:self action:@selector(cameraAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_takePhotoBtn];
    
   
    UIImage *imgClose  = BundleImg(@"packUp");
    UIImageView *imgCloseView = [[UIImageView alloc] initWithImage:imgClose];
    imgCloseView.frame = CGRectMake(leftMargin, (takePhotoHeight - packUpHeight)/2, 20, 20);
    imgCloseView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:imgCloseView];
    _packUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _packUpBtn.frame = CGRectMake(leftMargin, 5, 60, 60);
    _packUpBtn.tag = 1001;
    [_packUpBtn addTarget:self action:@selector(cameraAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_packUpBtn];
    
    NSString *currentLan = [[NSUserDefaults standardUserDefaults] valueForKey:kLanguage];
    if ([currentLan isEqualToString:kLanguage_EN]) {
        cameraImage  = FoxBundleImg(@"camera_fox");
        [_takePhotoBtn setBackgroundImage:cameraImage forState:UIControlStateNormal];
        imgClose = FoxBundleImg(@"closeArrow");
        imgCloseView.image = imgClose;
    }
}

//- (void)setIsSticker:(BOOL)isSticker{
//    _isSticker = isSticker;
//    //_packUpBtn.hidden = _isSticker;
//}

- (void)cameraAction:(UIButton*)sender{
    if (sender.tag == 1000) {
        _clickBtn(YES);
    }else{
        _clickBtn(NO);
    }
}

@end
