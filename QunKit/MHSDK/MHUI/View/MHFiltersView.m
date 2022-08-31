//
//  MHFiltersView.m

//滤镜

#import "MHFiltersView.h"
#import "MHBeautyMenuCell.h"
#import "MHBeautyParams.h"
#import "MHBeautiesModel.h"
#define kFilterName @"kFilterName"
@interface MHFiltersView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, assign) NSInteger lastIndex;

@end
@implementation MHFiltersView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.collectionView];
        self.lastIndex = 0;
    }
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.array.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
     MHBeautyMenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MHFilterCell" forIndexPath:indexPath];
    cell.quickModel = self.array[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(([UIScreen mainScreen].bounds.size.width-20) /MHFilterItemColumn, MHFilterCellHeight);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.lastIndex == indexPath.row) {
        return;
    }
    MHBeautiesModel *model = self.array[indexPath.row];
    model.isSelected = !model.isSelected;
    
    if ([self.delegate respondsToSelector:@selector(handleFiltersEffect: filterName:)]) {
        [self.delegate handleFiltersEffect:model.type filterName:model.imgName];
    }
    
    if (isSaveFilter) {
        NSDictionary *filerInfo = @{@"kFilterType":@(model.type),
                                    @"kFilterName":model.imgName
        };
        [[NSUserDefaults standardUserDefaults] setObject:filerInfo forKey:kMHFilter];
    }
    MHBeautiesModel *lastModel = self.array[self.lastIndex];
    lastModel.isSelected = !lastModel.isSelected;
    
    [self.collectionView reloadData];
    self.lastIndex = indexPath.row;
}

#pragma mark - lazy


-(NSMutableArray *)array {
    if (!_array) {
    
        NSMutableArray * selectedItemArray = [MHSDK shareInstance].filterArray;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"MHFilterParams" ofType:@"plist"];
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
            MHBeautiesModel *model = [MHBeautiesModel new];
            model.imgName = itemDic[@"imageName"];
            model.beautyTitle = itemDic[@"name"];
            model.isSelected = i == 0 ? YES : NO;
            model.type = [itemDic[@"type"] integerValue];
            model.menuType = MHBeautyMenuType_Filter;
            
            if (!isSaveFilter) {
                model.isSelected = i == 0 ? YES : NO;
                self.lastIndex = 0;
            }else{
                NSDictionary *data = [[NSUserDefaults standardUserDefaults] objectForKey:kMHFilter];
                if (data && ![data isKindOfClass:[NSString class]]) {
                    NSString *imgName = [data objectForKey:@"kFilterName"];
                    if ([model.imgName isEqualToString:imgName]) {
                        model.isSelected = YES;
                        self.lastIndex = i;
                    }else{
                        model.isSelected = NO;
                    }
                }else{
                    model.isSelected = i == 0 ? YES : NO;
                    self.lastIndex = 0;
                }
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
        layout.minimumInteritemSpacing = 15;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, window_width,self.frame.size.height) collectionViewLayout:layout];
        ///修改MHUI
        _collectionView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:MHBlackAlpha];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[MHBeautyMenuCell class] forCellWithReuseIdentifier:@"MHFilterCell"];
    }
    return _collectionView;
}

@end
