//
//  MHBeautyAssembleView.m

//美颜

#import "MHBeautyAssembleView.h"
#import "MHBeautyFaceView.h"
#import "MHFiltersView.h"
#import "MHBeautyView.h"
#import "WNSegmentControl.h"
#import "MHBeautyParams.h"
#import "MHCompleteBeautyView.h"
#import "MHBeautySlider.h"
#import "MHBeautiesModel.h"
#import "MHBottomView.h"
#import <MHBeautySDK/MHSDK.h>
@interface MHBeautyAssembleView()<MHBeautyViewDelegate,MHBeautyFaceViewDelegate,MHFiltersViewDelegate,MHCompleteBeautyViewDelegate>
@property (nonatomic, strong) WNSegmentControl *segmentControl;
@property (nonatomic, strong) MHBeautyView *beautyView;//美颜
@property (nonatomic, strong) MHBeautyFaceView *faceView;//美型
@property (nonatomic, strong) MHCompleteBeautyView *completeView;//一键美颜
@property (nonatomic, strong) MHFiltersView *filtersView;//滤镜
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) NSMutableArray *viewsArray;
@property (nonatomic, strong) UIView *lastView;
@property (nonatomic, strong) MHBeautySlider *slider;
@property (nonatomic, assign) NSInteger beautyLevel;
@property (nonatomic, assign) NSInteger whiteLevel;
@property (nonatomic, assign) NSInteger ruddinessLevel;
@property (nonatomic, assign) NSInteger brightnessLevel;
@property (nonatomic, assign) MHBeautyAssembleType assembleType;
@property (nonatomic, assign) MHBeautyType beautyType;
@property (nonatomic, assign) MHBeautyFaceType faceType;
@property (nonatomic, strong) MHBeautiesModel *quickBeautyModel;
@property (nonatomic, strong) MHBottomView * bottomView;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, assign) int sdkLevelTYpe;///<sdk类型

@end
@implementation MHBeautyAssembleView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.faceType = -1;//默认不选择状态
        self.beautyType = -1;//默认不选择状态
        self.viewsArray = [NSMutableArray array];
        [self addSubview:self.slider];
        [self addSubview:self.nameLabel];
    }
    return self;
}


- (void)configureUI {
    
    NSMutableArray * selectedItem = [MHSDK shareInstance].beautyAssembleArr;
    
    NSMutableArray * nameArr = [NSMutableArray array];
    for (int i = 0; i < selectedItem.count; i ++) {
        NSDictionary * itemDic = selectedItem[i];
        NSString * itemName = itemDic[@"name"];
        [nameArr addObject:itemName];
    }
    if (_segmentControl) {
        return;
    }
    _segmentControl = [[WNSegmentControl alloc] initWithTitles:nameArr];
    CGFloat bottom =  _slider.frame.origin.y + _slider.frame.size.height;
    _segmentControl.frame = CGRectMake(0, bottom+20, window_width, MHStickerSectionHeight);
    ///修改MHUI
    _segmentControl.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:MHBlackAlpha];
    [_segmentControl setTextAttributes:@{NSFontAttributeName: Font_12, NSForegroundColorAttributeName: FontColorBlackNormal}
                              forState:UIControlStateNormal];
    [_segmentControl setTextAttributes:@{NSFontAttributeName: Font_12, NSForegroundColorAttributeName: FontColorSelected}
                              forState:UIControlStateSelected];
    _segmentControl.selectedSegmentIndex = 0;
    _segmentControl.widthStyle = WNSegmentedControlWidthStyleFixed;
    [_segmentControl addTarget:self action:@selector(switchList:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_segmentControl];
    
    [self addSubview:self.lineView];
    
    NSArray * items =  @[@{@"美颜":self.beautyView},@{@"美型":self.faceView},@{@"一键美颜":self.completeView},@{@"滤镜":self.filtersView}];
    for (int i = 0; i < selectedItem.count; i ++) {
        NSDictionary * itemDic = selectedItem[i];
        NSString * itemName = itemDic[@"name"];
        for (int j = 0; j < items.count; j ++) {
            NSDictionary * itemDic = items[j];
            if ([itemDic.allKeys[0] isEqual:itemName]) {
                [_viewsArray addObject:itemDic.allValues[0]];
            }
        }
    }
    
    if (_viewsArray.count> 0) {
        [self addSubview:_viewsArray[0]];
        self.lastView = _viewsArray[0];
    }
    
    ///修改MHUI
    if (isNeedBottom) {
        [self addSubview:self.bottomView];
    }
    
    self.slider.maximumValue = 9;
    NSInteger currentIndex = [self.beautyView currentIndex];
    if(currentIndex == 0 || currentIndex == -1){
        self.slider.hidden = YES;
    }
    
    [self.faceView configureFaceData];
    if (self.lastView == self.beautyView) {
        self.assembleType = 0;
    }else if (self.lastView == self.faceView){
        self.assembleType = 1;
    }else if (self.lastView == self.completeView){
        self.assembleType = 2;
    }
    
}
- (void)configureSlider{
   // self.slider.maximumValue = 9;
}
#pragma mark - Action
- (void)switchList:(WNSegmentControl *)segment {
    self.nameLabel.hidden = YES;
    UIView *view = [self.viewsArray objectAtIndex:segment.selectedSegmentIndex];
    self.slider.hidden = [view isEqual:self.filtersView];
    self.assembleType = segment.selectedSegmentIndex;
    if ([view isEqual:self.beautyView]) {
        NSInteger current = [self.beautyView currentIndex];
        if (current == 0 || current == -1){
            self.slider.hidden = YES;
            self.nameLabel.hidden = YES;
        }else{
            self.slider.hidden = NO;
            self.nameLabel.hidden = NO;
        }
        NSString *faceKey = [NSString stringWithFormat:@"beauty_%ld",(long)self.beautyType];
        NSInteger currentValue = [[NSUserDefaults standardUserDefaults] integerForKey:faceKey];
        [self.slider setValue:currentValue animated:YES];
        self.slider.maximumValue = 9;
    } else {
        self.slider.maximumValue = 100;
    }
    if ([view isEqual:self.faceView]) {
        NSInteger current = [self.faceView currentIndex];
        if (current == 0 || current == -1){
            self.slider.hidden = YES;
            self.nameLabel.hidden = YES;
        }else{
            self.slider.hidden = NO;
            self.nameLabel.hidden = NO;
        }
        [self.faceView configureFaceData];
        NSString *faceKey = [NSString stringWithFormat:@"face_%ld",(long)self.faceType];
        NSInteger currentValue = [[NSUserDefaults standardUserDefaults] integerForKey:faceKey];
        [self.slider setValue:currentValue animated:YES];
    }
    if ([view isEqual:self.completeView]) {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:kOneclickBeauty] isKindOfClass:[NSData class]]) {
            self.slider.hidden = NO;
            self.nameLabel.hidden = NO;
            [self configureOneclickDefaultData];
        }else{
            self.slider.hidden = YES;
            self.nameLabel.hidden = YES;
        }
    }
    if (![view isEqual:self.lastView]) {
        self.lastView.hidden = YES;
    }
    if ([view isDescendantOfView:self]) {
        view.hidden = NO;
    }else{
        [self addSubview:view];
    }
    self.lastView = view;
    ///修改MHUI
    [self bringSubviewToFront:self.bottomView];
    
}
- (void)configureOneclickDefaultData{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kOneclickBeauty];
    MHBeautiesModel *lastModel;
    NSSet *set = [NSSet setWithObjects:[NSString class],[NSNumber class],[MHBeautiesModel class], nil];
    if (data && ![data isKindOfClass:[NSString class]]) {
        if (@available(iOS 11.0,*)) {
            lastModel = [NSKeyedUnarchiver unarchivedObjectOfClasses:set fromData:data error:nil];
        }else{
            lastModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
        [self.slider setSliderValue:lastModel.defaultValue];
        [self.slider setValue:lastModel.defaultValue.integerValue animated:YES];
        self.nameLabel.text = lastModel.beautyTitle;
        [self handleCompleteEffect:lastModel defaultSliderValue:lastModel.defaultValue.integerValue];
    }
}
//slider 滑动修改对应的效果
- (void)handleBeautyAssembleEffectWithValue:(NSInteger)value {
    switch (self.assembleType) {
        case 0:{
            if (self.isTXSDK) {
                [self handleBeautyEffectsOfTXWithSliderValue:value];
            } else {
                [self handleBeautyEffectsWithSliderValue:value];
            }
        }
            break;
        case 1:
            [self handleFaceEffectsWithSliderValue:value];
            
            break;
        case 2:
            [self handleQuickBeautyWithSliderValue:value];
            break;
        default:
            break;
    }
}
#pragma mark - 底部按钮响应
- (void)cameraAction:(BOOL)isTakePhoto{
    NSLog(@"点击了拍照");
    if (isTakePhoto) {
        if ([self.delegate respondsToSelector:@selector(takePhoto)]) {
            [self.delegate takePhoto];
        }
    }else{
        if ([self.delegate respondsToSelector:@selector(clickPackUp)]) {
            [self.delegate clickPackUp];
        }
    }
}

#pragma mark - 美颜-腾讯直播用
- (void)handleBeautyEffectsOfTXWithSliderValue:(NSInteger)value {
    switch (self.beautyType) {
        case MHBeautyType_Original:{
            self.beautyLevel = 0;
            self.whiteLevel = 0;
            self.ruddinessLevel = 0;
            self.brightnessLevel = 50;//默认
        }
            break;
        case MHBeautyType_White:
            self.whiteLevel = value;
            break;
        case MHBeautyType_Mopi:
            self.beautyLevel = value;
            break;
        case MHBeautyType_Ruddiess:
            self.ruddinessLevel = value;
            break;
        case MHBeautyType_Brightness:
            self.brightnessLevel = value*100/9.0;
            break;
        default:
            break;
    }
//    if (self.beautyType != MHBeautyType_Brightness) {
//        self.brightnessLevel = 57;
//    }
    if (self.brightnessLevel > 90){
        self.brightnessLevel = 90;
    }
    if (self.brightnessLevel < 10){
        self.brightnessLevel = 10;
    }
    
    if ([self.delegate respondsToSelector:@selector(beautyLevel:whitenessLevel:ruddinessLevel: brightnessLevel:)]) {
        NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"hasSelectedQuickBeauty"];
        if ([str isEqualToString:@"YES"]) {
            //2020-07-04 现在相机有默认美颜效果，取消一键美颜时需要恢复默认的美颜效果
            //[self.delegate beautyLevel:0 whitenessLevel:0 ruddinessLevel:0 brightnessLevel:50];//为了取消一键美颜的效果
            [self.delegate beautyLevel:5 whitenessLevel:5 ruddinessLevel:7 brightnessLevel:57];
            [self.completeView cancelQuickBeautyEffect:self.quickBeautyModel];
            [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"hasSelectedQuickBeauty"];//保证只执行一次
        }
         
        [self.delegate beautyLevel:self.beautyLevel whitenessLevel:self.whiteLevel ruddinessLevel:self.ruddinessLevel brightnessLevel:self.brightnessLevel];
    }
    NSString *beautKey = [NSString stringWithFormat:@"beauty_%ld",(long)self.beautyType];
    [[NSUserDefaults standardUserDefaults] setInteger:value forKey:beautKey];
}
#pragma mark - 美颜slider
- (void)handleBeautyEffectsWithSliderValue:(NSInteger)value {
    if ([self.delegate respondsToSelector:@selector(handleBeautyWithType:level:)]) {
        NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"hasSelectedQuickBeauty"];
        if ([str isEqualToString:@"YES"]) {
            [self.delegate handleBeautyWithType:0 level:0];//为了取消一键美颜的效果
            [self.completeView cancelQuickBeautyEffect:self.quickBeautyModel];
            [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"hasSelectedQuickBeauty"];//保证只执行一次
        }
        if (self.beautyType == MHBeautyType_Brightness) {
            [self.delegate handleBeautyWithType:self.beautyType level:value*10];
        }else{
            [self.delegate handleBeautyWithType:self.beautyType level:value/9.0];
        }
        
    }
    NSString *beautKey = [NSString stringWithFormat:@"beauty_%ld",(long)self.beautyType];
    [[NSUserDefaults standardUserDefaults] setInteger:value forKey:beautKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 美型slider
- (void)handleFaceEffectsWithSliderValue:(NSInteger)value {
    if ([self.delegate respondsToSelector:@selector(handleFaceBeautyWithType:sliderValue:)]) {
        NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"hasSelectedQuickBeauty"];
        if ([str isEqualToString:@"YES"]) {
            [self.delegate handleFaceBeautyWithType:0 sliderValue:0];//为了取消一键美颜的效果
            [self.completeView cancelQuickBeautyEffect:self.quickBeautyModel];//为了取消一键美颜的效果
            [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"hasSelectedQuickBeauty"];//保证只执行一次
        }
        [self.delegate handleFaceBeautyWithType:self.faceType sliderValue:value];
    }
    NSString *faceKey = [NSString stringWithFormat:@"face_%ld",(long)self.faceType];
    [[NSUserDefaults standardUserDefaults] setInteger:value forKey:faceKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 一键美颜slider
- (void)handleQuickBeautyWithSliderValue:(NSInteger)value {
    if ([self.delegate respondsToSelector:@selector(handleQuickBeautyWithSliderValue: quickBeautyModel:)]) {
        [self.delegate handleQuickBeautyWithSliderValue:value quickBeautyModel:self.quickBeautyModel];
    }
    if (isSaveOneclickBeauty) {
        if (self.quickBeautyModel) {
            self.quickBeautyModel.defaultValue = [NSString stringWithFormat:@"%ld",(long)value];
            if (@available(iOS 11.0,*)) {
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.quickBeautyModel requiringSecureCoding:YES error:nil];
                [[NSUserDefaults standardUserDefaults] setObject:data forKey:kOneclickBeauty];
            }else{
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.quickBeautyModel];
                [[NSUserDefaults standardUserDefaults] setObject:data forKey:kOneclickBeauty];
            }
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    
}

#pragma mark - delegate
//美颜
- (void)handleBeautyEffects:(NSInteger)type sliderValue:(NSInteger)value name:(nonnull NSString *)name{
    //点击原图时slider隐藏
    if (type == 0){
        _slider.hidden = YES;
        _nameLabel.hidden = YES;
    }else{
        _slider.hidden = NO;
        _nameLabel.hidden = NO;
    }
    self.beautyType = type;
    [self.slider setSliderValue:[NSString stringWithFormat:@"%ld",(long)value]];
    [self.slider setValue:(NSInteger)value animated:YES];
    self.nameLabel.text = name;
}
//美型
- (void)handleFaceEffects:(NSInteger)type sliderValue:(NSInteger)value name:(nonnull NSString *)name{
    if (type == 0){
        _slider.hidden = YES;
        _nameLabel.hidden = YES;
    }else{
        _slider.hidden = NO;
        _nameLabel.hidden = NO;
    }
    self.faceType = type;
    [self.slider setSliderValue:[NSString stringWithFormat:@"%ld",(long)value]];
    [self.slider setValue:(NSInteger)value animated:YES];
    self.nameLabel.text = name;
}

//一键美颜
- (void)handleCompleteEffect:(MHBeautiesModel *)model defaultSliderValue:(NSInteger)defaultValue {
    if ([model.beautyTitle isEqualToString:@"原图"]){
        _slider.hidden = YES;
        _nameLabel.hidden = YES;
    }else{
        _slider.hidden = NO;
        _nameLabel.hidden = NO;
    }
    if ([model.beautyTitle isEqualToString:@"原图"]) {
        self.quickBeautyModel = nil;
    }
    self.quickBeautyModel = model;
    if ([self.delegate respondsToSelector:@selector(handleQuickBeautyValue:)]) {
        [self.delegate handleQuickBeautyValue:model];
    }
     //取消美颜美型的选中状态
    if (self.faceType != -1) {
        [self.faceView clearAllFaceEffects];
        //[self.faceView cancelSelectedFaceType:self.faceType];
        self.faceType = -1;
    }
    if (self.beautyType != -1) {
        [self.beautyView clearAllBeautyEffects];
        //[self.beautyView cancelSelectedBeautyType:self.beautyType];
        self.beautyType = -1;
    }
    _nameLabel.text = model.beautyTitle;
    [self.slider setSliderValue:[NSString stringWithFormat:@"%ld",(long)defaultValue]];
    [self.slider setValue:defaultValue animated:YES];
}

//滤镜
- (void)handleFiltersEffect:(NSInteger)filterType filterName:(nonnull NSString *)filtetName {
    if ([self.delegate respondsToSelector:@selector(handleFiltersEffectWithType: withFilterName:)]) {
        [self.delegate handleFiltersEffectWithType:filterType withFilterName:filtetName];
    }
}



#pragma mark - lazy
- (MHBeautyView *)beautyView {
    if (!_beautyView) {
        CGFloat bottom =  _lineView.frame.origin.y + _lineView.frame.size.height;
        _beautyView = [[MHBeautyView alloc] initWithFrame:CGRectMake(0, bottom, window_width, MHBeautyAssembleViewHeight -bottom - MHBottomViewHeight)];
        _beautyView.delegate = self;
    }
    return _beautyView;
}
///修改MHUI
- (MHBeautyFaceView *)faceView {
    if (!_faceView) {
        ///修改MHUI
        CGFloat bottom =  _lineView.frame.origin.y + _lineView.frame.size.height;
//        CGFloat bottom =  _segmentControl.frame.origin.y + _segmentControl.frame.size.height;
        _faceView = [[MHBeautyFaceView alloc] initWithFrame:CGRectMake(0, bottom, window_width, MHBeautyAssembleViewHeight-bottom-MHBottomViewHeight)];
        _faceView.delegate = self;
    }
    return _faceView;
}

- (MHFiltersView *)filtersView {
    if (!_filtersView) {
        CGFloat bottom =  _lineView.frame.origin.y + _lineView.frame.size.height;
        _filtersView = [[MHFiltersView alloc] initWithFrame:CGRectMake(0, bottom, window_width, MHBeautyAssembleViewHeight-bottom-MHBottomViewHeight)];
        _filtersView.delegate = self;
    }
    return _filtersView;
}
///修改MHUI
- (MHCompleteBeautyView *)completeView {
    if (!_completeView) {
        ///修改MHUI
        CGFloat bottom =  _lineView.frame.origin.y + _lineView.frame.size.height;
        _completeView = [[MHCompleteBeautyView alloc] initWithFrame:CGRectMake(0, bottom  , window_width, MHBeautyAssembleViewHeight-bottom-MHBottomViewHeight)];
        _completeView.delegate = self;
        
    }
    return _completeView;
}

- (UIView *)lineView {
    if (!_lineView) {
        CGFloat bottom =  _segmentControl.frame.origin.y + _segmentControl.frame.size.height;
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, bottom, window_width, 0.5)];
        _lineView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:MHBlackAlpha];
        UIView * view = [[UIView alloc] initWithFrame:_lineView.bounds];
        [_lineView addSubview:view];
        view.backgroundColor = LineColor;
    }
    return _lineView;
}
///修改MHUI
- (MHBottomView*)bottomView{
    
    if (!_bottomView) {
        __weak typeof(self) weakSelf = self;
        CGFloat bottom =  _beautyView.frame.origin.y + _beautyView.frame.size.height;
        _bottomView = [[MHBottomView alloc] initWithFrame:CGRectMake(0, bottom, window_width, MHBottomViewHeight)];
        _bottomView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _bottomView.clickBtn = ^(BOOL isTakePhoto) {
            [weakSelf cameraAction:isTakePhoto];
        };
    }
    return _bottomView;
}


- (MHBeautySlider *)slider {
    if (!_slider) {
        _slider = [[MHBeautySlider alloc] initWithFrame:CGRectMake(80, MHSliderwTop, self.frame.size.width - 80*2, MHSliderwHeight)];
        _slider.minimumValue = 0;
        _slider.maximumValue = 100;
        UIImage *minImg = BundleImg(@"wire")
        [_slider setMinimumTrackImage:minImg forState:UIControlStateNormal];
        UIImage *maxImg = BundleImg(@"wire drk");
        [_slider setMaximumTrackImage:maxImg forState:UIControlStateNormal];
        UIImage *pointImg = BundleImg(@"sliderButton");
        [_slider setThumbImage:pointImg forState:UIControlStateNormal];
        _slider.continuous = YES;
        __weak typeof(self) weakSelf = self;
        _slider.valueChanged = ^(MHBeautySlider * _Nonnull slider) {
            [weakSelf handleBeautyAssembleEffectWithValue:slider.value];
            weakSelf.slider.sliderValue = [NSString stringWithFormat:@"%ld", (long)slider.value];
        };
    }
    return _slider;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.frame = CGRectMake(20, MHSliderwTop, 60, MHSliderwHeight);
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}

-(int)sdkLevelTYpe{
    return [[MHSDK shareInstance] getSDKLevel];
}

@end

