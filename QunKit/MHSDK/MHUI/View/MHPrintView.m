//
//  MHPrintView.m

//水印

#import "MHPrintView.h"
#import "MHBeautyParams.h"
#import "MHBeautiesModel.h"
#import "MHBeautyMenuCell.h"
//图片名称
static NSString *Cancel = @"print_cancel";
static NSString *TOP_LEFT = @"top_left";
static NSString *TOP_RIGHT = @"top_right";
static NSString *BOTTOM_LEFT = @"bottom_left";
static NSString *BOTTOM_RIGHT = @"bottom_right";
@interface MHPrintView()
<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, assign) NSInteger lastIndex;
@property (nonatomic, strong) NSMutableArray *printArr;
@end
@implementation MHPrintView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.collectionView];
    }
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.printArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MHBeautyMenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MHMagnifiedEffectCell" forIndexPath:indexPath];
    cell.watermarkModel = self.printArr[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    ///修改MHUI
    return CGSizeMake((window_width-60-10*3)/4, MHMeiyanMenusCellHeight);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.lastIndex == indexPath.row) {
        return;
    }
    MHBeautiesModel *model = self.printArr[indexPath.row];
    model.isSelected = !model.isSelected;
    
    MHBeautiesModel *lastModel = self.printArr[self.lastIndex];
    lastModel.isSelected = !lastModel.isSelected;
    NSIndexPath *lastpath = [NSIndexPath indexPathForRow:self.lastIndex inSection:0];
    [collectionView reloadItemsAtIndexPaths:@[indexPath,lastpath]];
    self.lastIndex = indexPath.row;
    if ([self.delegate respondsToSelector:@selector(handlePrint:)]) {
        [self.delegate handlePrint:model];
    }
    if (isSaveWatermark) {
        NSDictionary *info = @{@"KWatermarkName":model.imgName,
                               @"kWatermarkAliment":@(model.aliment)
        };
        [[NSUserDefaults standardUserDefaults] setObject:info forKey:kMHWatermark];
    }
}

-(NSMutableArray *)printArr {
    if (!_printArr) {
        NSArray *arr = @[Cancel,TOP_LEFT,TOP_RIGHT,BOTTOM_LEFT,BOTTOM_RIGHT];
        _printArr = [NSMutableArray array];
        for (int i = 0; i<arr.count; i++) {
            MHBeautiesModel *model = [[MHBeautiesModel alloc] init];
            model.imgName = arr[i];
            model.aliment = i;
            model.menuType = MHBeautyMenuType_Watermark;
            if (isSaveWatermark) {
                NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:kMHWatermark];
                if (dic) {
                    NSString *name = dic[@"KWatermarkName"];
                    if ([model.imgName isEqualToString:name]) {
                        model.isSelected = YES;
                        self.lastIndex = i;
                    }else{
                        model.isSelected = NO;
                    }
                }else{
                    model.isSelected = i == 0 ? YES : NO;
                }
            }else{
                model.isSelected = i == 0 ? YES : NO;
            }
            [_printArr addObject:model];
        }
    }
    return _printArr;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 0, 10);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, window_width, self.frame.size.height) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[MHBeautyMenuCell class] forCellWithReuseIdentifier:@"MHMagnifiedEffectCell"];
    }
    return _collectionView;
}
@end
