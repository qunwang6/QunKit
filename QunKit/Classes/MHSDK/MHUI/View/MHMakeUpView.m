//
//  MHMakeUpView.m
//  TXLiteAVDemo_UGC
//
//  Created by Apple on 2021/5/7.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import "MHMakeUpView.h"
#import "MHBeautyMenuCell.h"
#import "MHBeautyParams.h"
#import "MHBeautiesModel.h"
#import "WNSegmentControl.h"
#import "MHBottomView.h"
@interface MHMakeUpView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, assign) NSInteger lastIndex;
@property (nonatomic, assign) NSInteger beautyType;
@property (nonatomic, strong) WNSegmentControl *segmentControl;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) MHBottomView * bottomView;
@end
@implementation MHMakeUpView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.segmentControl];
        [self addSubview:self.lineView];
        [self addSubview:self.collectionView];
        if (isNeedBottom) {
            [self addSubview:self.bottomView];
        }
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:MHBlackAlpha];
        self.lastIndex = -1;
    }
    return self;
}

- (void)clearAllMakeupEffects {
    for (int i = 0; i<self.array.count; i++) {
        MHBeautiesModel * model = self.array[i];
        model.isSelected = i == 0;
        NSString *makeupKey = [NSString stringWithFormat:@"kMHMakeup_%ld",model.type];
        [[NSUserDefaults standardUserDefaults] setBool:model.isSelected forKey:makeupKey];
    }
    [self.collectionView reloadData];
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

#pragma mark - collectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.array.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MHBeautyMenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MHBeautyMenuCell" forIndexPath:indexPath];
    cell.beautyModel = self.array[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake((window_width-40)/4, MHMeiyanMenusCellHeight);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.lastIndex == indexPath.row) {
        return;
    }
    MHBeautiesModel *currentModel = self.array[indexPath.row];
    currentModel.isSelected = !currentModel.isSelected;
    
    if (indexPath.row == 0) {
        [self clearAllMakeupEffects];
    }else{
        MHBeautiesModel *model = self.array[0];
        model.isSelected = NO;
        [[NSUserDefaults standardUserDefaults] setBool:model.isSelected forKey:@"kMHMakeup_0"];
    }
    
    self.lastIndex = indexPath.row;
    [self.collectionView reloadData];
    self.beautyType = currentModel.type;
    if (isSaveMakeup) {
        if (self.beautyType != 0) {
            NSString *makeupKey = [NSString stringWithFormat:@"kMHMakeup_%ld",(long)self.beautyType];
            [[NSUserDefaults standardUserDefaults] setBool:currentModel.isSelected forKey:makeupKey];
        }
       
    }
    if ([self.delegate respondsToSelector:@selector(handleMakeUpType:withON:)]) {
        [self.delegate handleMakeUpType:currentModel.type withON:currentModel.isSelected];
    }
}

#pragma mark - lazy
- (NSMutableArray *)array {
    if (!_array) {
        NSMutableArray * selectedItemArray = [MHSDK shareInstance].makeupArray;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"MHMakeupParams" ofType:@"plist"];
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
            model.menuType = MHBeautyMenuType_MakeUp;
            model.type = [itemDic[@"type"] integerValue];
            if (isSaveMakeup) {
                NSString *makeUpKey = [NSString stringWithFormat:@"kMHMakeup_%ld",model.type];
                BOOL isSelected = [[NSUserDefaults standardUserDefaults] boolForKey:makeUpKey];
                model.isSelected = isSelected;
            }else{
                model.isSelected = i==0;
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
        [_collectionView registerClass:[MHBeautyMenuCell class] forCellWithReuseIdentifier:@"MHBeautyMenuCell"];
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}
///修改MHUI
- (WNSegmentControl *)segmentControl {
    if (!_segmentControl) {
        _segmentControl = [[WNSegmentControl alloc] initWithTitles:@[@"美妆"]];
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
        _bottomView.clickBtn = ^(BOOL isTakePhoto) {
            [weakSelf cameraAction:isTakePhoto];
        };
    }
    return _bottomView;
}
- (NSInteger)currentIndex{
    return _lastIndex;
}

@end
