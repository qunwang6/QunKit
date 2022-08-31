
//
//  MHBeautyMenuCell.m


#import "MHBeautyMenuCell.h"
#import "MHBeautyParams.h"
#import "MHBeautiesModel.h"
@interface MHBeautyMenuCell()
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *beautyLabel;
@property (nonatomic, strong) UIImageView *animationView;
@property (nonatomic, strong) UIImageView *selectedImgView;
@property (nonatomic, strong) UIButton *effectBtn;
@property (nonatomic, strong) UIView * bgView;
@property (nonatomic, strong) UIView * markView;
@property(nonatomic,strong)UILabel *selectedLabel;
@property (nonatomic, strong) UIView * bgLabel;
@end
@implementation MHBeautyMenuCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.imgView];
        [self addSubview:self.beautyLabel];
    }
    return self;
}

- (void)setMenuModel:(MHBeautiesModel *)menuModel {
    if (!menuModel) {
        return;
    }
    _menuModel = menuModel;
    self.beautyLabel.text = menuModel.beautyTitle;
    if (menuModel.menuType == MHBeautyMenuType_Menu) {
        if ([menuModel.beautyTitle isEqualToString:@""]) {//仅限菜单页，@""的时候是相机功能
            UIImage * img  = BundleImg(@"beautyCamera")
            self.imgView.image = img;
            self.imgView.frame = CGRectMake((self.frame.size.width - 60)/2, (self.frame.size.height - 60)/2, 60, 60);
        }
        //短视频拍摄
        else if([menuModel.beautyTitle isEqualToString:@"单击拍"]){
            UIImage *img = [UIImage imageNamed:menuModel.imgName];
            self.imgView.image = img;
            self.imgView.frame = CGRectMake((self.frame.size.width - 60)/2, (self.frame.size.height - 60)/2, 60, 60);
            CGFloat bottom =  self.imgView.frame.origin.y + self.imgView.frame.size.height;
            CGRect rect = self.beautyLabel.frame;
            self.beautyLabel.frame = CGRectMake(rect.origin.x, bottom + 10, rect.size.width, rect.size.height);
            self.beautyLabel.text = @"";
            self.beautyLabel.hidden = YES;
        }
        else {
            for (UIView *subview in self.imgView.subviews){
                [subview removeFromSuperview];
            }
            self.imgView.image = BundleImg(menuModel.imgName);
            self.imgView.frame = CGRectMake((self.frame.size.width - 35)/2, self.isSimplification?(self.frame.size.height - 35)/2:15, 35, 35);
//            if (!self.isSimplification) {
                CGFloat bottom =  self.imgView.frame.origin.y + self.imgView.frame.size.height;
                CGRect rect = self.beautyLabel.frame;
                self.beautyLabel.frame = CGRectMake(rect.origin.x, bottom, rect.size.width, rect.size.height);
//                self.beautyLabel.hidden = NO;
//            }else{
//                self.beautyLabel.hidden = YES;
//            }
        }
    }
    
}


//美颜，美型，美妆,动作 使用
-(void)setBeautyModel:(MHBeautiesModel *)beautyModel{
    _beautyModel = beautyModel;
    self.beautyLabel.textColor = beautyModel.isSelected ? FontColorSelected : FontColorBlackNormal;
    self.beautyLabel.text = beautyModel.beautyTitle;
    if (beautyModel.isSelected) {
        NSString *name = [NSString stringWithFormat:@"%@_selected",beautyModel.imgName];
        UIImage *img = BundleImg(name);
        self.imgView.image = img;
    } else {
        self.imgView.image = BundleImg(beautyModel.imgName);
    }
}
//一键美颜,滤镜,特效使用
- (void)setQuickModel:(MHBeautiesModel *)quickModel{
    _quickModel = quickModel;
    self.beautyLabel.text = quickModel.beautyTitle;
    self.imgView.image = BundleImg(quickModel.imgName);
    self.imgView.frame = CGRectMake((self.frame.size.width - 50)/2, 10, 50, 70);
    self.beautyLabel.frame = CGRectMake((self.frame.size.width - 50)/2, 65, 50, 15);
    self.beautyLabel.backgroundColor = UIColor.whiteColor;
    self.beautyLabel.textColor = quickModel.isSelected ? [UIColor whiteColor] : FontColorBlackNormal1;
    self.selectedLabel.text = quickModel.beautyTitle;
    self.markView.hidden = !quickModel.isSelected;
    self.selectedImgView.hidden = !quickModel.isSelected;
}
//水印 使用
- (void)setWatermarkModel:(MHBeautiesModel *)watermarkModel{
    _watermarkModel = watermarkModel;
    self.imgView.image = [UIImage imageNamed:watermarkModel.imgName];
    self.selectedImgView.image = BundleImg(@"ic_border_selected");
    self.selectedImgView.hidden = !watermarkModel.isSelected;
    self.imgView.frame = CGRectMake((self.frame.size.width-30)/2, (self.frame.size.height-30)/2,30 ,30);
    self.selectedImgView.frame = CGRectMake((self.frame.size.width-50)/2, (self.frame.size.height-50)/2,50 ,50);
}
//哈哈镜 使用
-(void)setHahaModel:(MHBeautiesModel *)hahaModel{
    _hahaModel = hahaModel;
    self.imgView.image = BundleImg(hahaModel.imgName);
    self.selectedImgView.image = BundleImg(@"ic_border_selected");
    self.selectedImgView.hidden = !hahaModel.isSelected;
    self.beautyLabel.textColor = hahaModel.isSelected ? FontColorSelected : FontColorBlackNormal;
    self.beautyLabel.text = hahaModel.beautyTitle;
    self.selectedImgView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

- (void)takePhotoAnimation {
    [UIView animateWithDuration:0.2 animations:^{
        self.animationView.transform = CGAffineTransformMakeScale(0.9, 0.9);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            self.animationView.transform = CGAffineTransformMakeScale(1, 1);
        }];
    }];
}
#pragma mark - lazy
- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - 40)/2, (self.frame.size.height - 40 -23)/2, 40, 40)];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imgView;
}
- (UILabel *)beautyLabel {
    if (!_beautyLabel) {
        CGFloat bottom =  _imgView.frame.origin.y + _imgView.frame.size.height;
        _beautyLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, bottom+8, self.frame.size.width - 6, 15)];
        _beautyLabel.font = Font_10;
        _beautyLabel.textColor = [UIColor whiteColor];
        _beautyLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _beautyLabel;
}

- (UIImageView *)animationView {
    if (!_animationView) {
        UIImage *img = BundleImg(@"cameraPoint");
        _animationView = [[UIImageView alloc] initWithImage:img];
        _animationView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _animationView;
}
    
- (UIImageView *)selectedImgView {
    if (!_selectedImgView) {
        UIImage *img = BundleImg(@"filter_selected2");
        _selectedImgView = [[UIImageView alloc] initWithImage:img];
        _selectedImgView.hidden = YES;
        _selectedImgView.frame = CGRectMake((self.frame.size.width-30)/2, (self.frame.size.height-30)/2, 30, 30);
        _selectedImgView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_selectedImgView];
    }
    return _selectedImgView;
}

-(UIView *)markView{
    if (!_markView) {
        _markView = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width - 50)/2, 15, self.imgView.bounds.size.width, self.imgView.frame.size.height-5)];
        _markView.hidden = YES;
        _markView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:MHAlpha];
        [_markView addSubview:self.selectedLabel];
        [self addSubview:_markView];
    }
    return _markView;
}
-(UILabel *)selectedLabel{
    if (!_selectedLabel) {
        _selectedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,65-15 , 50, 15)];
        _selectedLabel.backgroundColor = UIColor.clearColor;
        _selectedLabel.font = Font_10;
        _selectedLabel.textColor = [UIColor whiteColor];
        _selectedLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _selectedLabel;
}
- (void)changeRecordState:(BOOL)isRecording
{
    if (isRecording){
        self.imgView.image = [UIImage imageNamed:@"record_pause"];
        self.beautyLabel.hidden = YES;
    }else{
        self.imgView.image = [UIImage imageNamed:@"record_start"];
        self.beautyLabel.hidden = NO;
    }
}

@end
