//
//  MHMagnifiedView.m

//哈哈镜

#import "MHMagnifiedView.h"
#import "MHBeautyMenuCell.h"
#import "MHBeautiesModel.h"
#import "MHBeautyParams.h"
#import "WNSegmentControl.h"
#import "MHBottomView.h"
@interface MHMagnifiedView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, assign) NSInteger lastIndex;
///修改MHUI
@property (nonatomic, strong) WNSegmentControl *segmentControl;
@property (nonatomic, strong) UIView *lineView;
///修改MHUI
@property (nonatomic, strong) MHBottomView * bottomView;
@end
@implementation MHMagnifiedView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        ///修改MHUI
//        [self addSubview:self.segmentControl];
//        [self addSubview:self.lineView];
        [self addSubview:self.collectionView];
        ///修改MHUI
        if (isNeedBottom) {
            [self addSubview:self.bottomView];
        }
    }
    return self;
}

- (void)setIsHiddenHead:(BOOL)isHiddenHead{
    _isHiddenHead = isHiddenHead;
    _segmentControl.hidden = _isHiddenHead;
    if (_isHiddenHead) {
        [_lineView removeFromSuperview];
        [_bottomView removeFromSuperview];
        self.collectionView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.array.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MHBeautyMenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MHMagnifiedEffectCell" forIndexPath:indexPath];
    cell.hahaModel = self.array[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((window_width-20)/4.5, 100);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.lastIndex == indexPath.row) {
        return;
    }
    MHBeautiesModel *model = self.array[indexPath.row];
    model.isSelected = !model.isSelected;
    MHBeautiesModel *lastModel = self.array[self.lastIndex];
    lastModel.isSelected = !lastModel.isSelected;
    [self.collectionView reloadData];
    self.lastIndex = indexPath.row;
    if ([self.delegate respondsToSelector:@selector(handleMagnify:withIsMenu:)]) {
        [self.delegate handleMagnify:model.type withIsMenu:!_isHiddenHead];
    }
    if (isSaveHaHaMirror) {
        [[NSUserDefaults standardUserDefaults] setInteger:model.type forKey:kMHHaHaMirror];
    }
}

#pragma mark - lazy
-(NSMutableArray *)array {
    if (!_array) {
        NSMutableArray * selectedItemArray = [NSMutableArray array];
        if (_isHiddenHead) {
            selectedItemArray = [MHSDK shareInstance].magnifiedArray;
        }else{
            selectedItemArray = [MHSDK shareInstance].meunMagnifiedArray;
        }
        NSString *path = [[NSBundle mainBundle] pathForResource:@"MHMagnifiedEffectParams" ofType:@"plist"];
        NSArray *items = [NSArray arrayWithContentsOfFile:path];
        
        NSMutableArray * selectedItems = [NSMutableArray array];
        for (int i = 0; i < selectedItemArray.count; i ++) {
            NSDictionary * selectedItemDic = selectedItemArray[i];
            NSString * selectedName = selectedItemDic[@"name"];
            for (int j = 0; j < items.count; j++) {
                NSDictionary * itemDic = items[j];
                NSString * itemName = itemDic[@"name"];
                if ([selectedName isEqual:itemName]) {
                    [selectedItems addObject:itemDic];
                }
            }
        }
        _array = [NSMutableArray array];
        for (int i = 0; i<selectedItems.count; i++) {
            NSDictionary * itemDic = selectedItems[i];
            MHBeautiesModel *model = [[MHBeautiesModel alloc] init];
            model.imgName = itemDic[@"imageName"];
            model.beautyTitle = itemDic[@"name"];
            model.type = [itemDic[@"type"] integerValue];
            model.menuType = MHBeautyMenuType_Magnify;
            if (isSaveHaHaMirror) {
                NSNumber *type = [[NSUserDefaults standardUserDefaults] objectForKey:kMHHaHaMirror];
                if (model.type == type.integerValue) {
                    model.isSelected = YES;
                    self.lastIndex = i;
                }else{
                    model.isSelected = NO;
                }
            }else{
                model.isSelected = i == 0 ? YES : NO;
            }
            [_array addObject:model];
        }
    }
    return _array;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 0, 10);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        ///修改MHUI
        CGFloat bottom = _lineView.frame.origin.y + _lineView.frame.size.height;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, bottom, window_width, self.frame.size.height - bottom - MHBottomViewHeight) collectionViewLayout:layout];
        ///修改MHUI
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[MHBeautyMenuCell class] forCellWithReuseIdentifier:@"MHMagnifiedEffectCell"];
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}
///修改MHUI
- (WNSegmentControl *)segmentControl {
    if (!_segmentControl) {
        _segmentControl = [[WNSegmentControl alloc] initWithTitles:@[@"哈哈镜"]];
        _segmentControl.frame = CGRectMake(0, 0, window_width, MHStickerSectionHeight);
        _segmentControl.backgroundColor = [UIColor clearColor];
        [_segmentControl setTextAttributes:@{NSFontAttributeName: Font_12, NSForegroundColorAttributeName: FontColorNormal}
                                  forState:UIControlStateNormal];
        [_segmentControl setTextAttributes:@{NSFontAttributeName: Font_12, NSForegroundColorAttributeName: FontColorSelected}
                                  forState:UIControlStateSelected];
        _segmentControl.selectedSegmentIndex = 0;
        _segmentControl.widthStyle = WNSegmentedControlWidthStyleFixed;
//        [_segmentControl addTarget:self action:@selector(switchList:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentControl;
}
- (UIView *)lineView {
    if (!_lineView) {
        CGFloat bottom = _segmentControl.frame.origin.y + _segmentControl.frame.size.height;
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, bottom, window_width, 0.5)];
        _lineView.backgroundColor = LineColor;
    }
    return _lineView;
}

///修改MHUI
- (MHBottomView*)bottomView{

    if (!_bottomView) {
        __weak typeof(self) weakSelf = self;
        CGFloat bottom =  self.collectionView.frame.origin.y + self.collectionView.frame.size.height;
        _bottomView = [[MHBottomView alloc] initWithFrame:CGRectMake(0, bottom, window_width, MHBottomViewHeight)];
//        _bottomView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _bottomView.clickBtn = ^(BOOL isTakePhoto) {
            [weakSelf cameraAction:isTakePhoto];
        };
    }
    return _bottomView;
}
@end
