//MHBeautyView.m

//美颜页面

#import "MHBeautyView.h"
#import "MHBeautyMenuCell.h"
#import "MHBeautyParams.h"
#import "MHBeautiesModel.h"

@interface MHBeautyView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, assign) NSInteger lastIndex;
@property (nonatomic, assign) NSInteger beautyType;
@property (nonatomic, strong) NSMutableArray *arr;
@end
@implementation MHBeautyView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.collectionView];
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:MHBlackAlpha];
        self.lastIndex = -1;
    }
    return self;
}

- (void)clearAllBeautyEffects {
    for (int i = 0; i<self.array.count; i++) {
        NSString *beautKey = [NSString stringWithFormat:@"beauty_%ld",(long)i];
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:beautKey];
        MHBeautiesModel *model = self.array[i];
        if (i == 0) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"kBeauty_%@",model.beautyTitle]];
            model.isSelected = YES;
        }else{
            model.isSelected = NO;
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:[NSString stringWithFormat:@"kBeauty_%@",model.beautyTitle]];
        }
       
    }
    [self.collectionView reloadData];
}

- (void)cancelSelectedBeautyType:(NSInteger)type {
    for (int i = 0; i<self.array.count; i++) {
        MHBeautiesModel *model = self.array[i];
        if (model.type == type) {
            model.isSelected = NO;
        }
    }
    self.lastIndex = -1;
    [self.collectionView reloadData];
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
    
    return CGSizeMake((window_width-40)/5, MHMeiyanMenusCellHeight);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.lastIndex == indexPath.row) {
        return;
    }
    MHBeautiesModel *currentModel = self.array[indexPath.row];
    currentModel.isSelected = YES;
//    if (self.lastIndex >= 0) {
//        MHBeautiesModel *lastModel = self.array[self.lastIndex];
//        lastModel.isSelected = NO;
//    }
    NSString *key = [NSString stringWithFormat:@"kBeauty_%@",currentModel.beautyTitle];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:key];
    
    if (indexPath.row == 0) {
        [self clearAllBeautyEffects];
    }else{
        MHBeautiesModel *firstModel = self.array[0];
        firstModel.isSelected = NO;
        NSString *key = [NSString stringWithFormat:@"kBeauty_%@",firstModel.beautyTitle];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:key];
        
    }
    
    self.lastIndex = indexPath.row;
    [self.collectionView reloadData];
    self.beautyType = currentModel.type;
    
    NSString *beautKey = [NSString stringWithFormat:@"beauty_%ld",(long)self.beautyType];
    NSInteger currentValue = [[NSUserDefaults standardUserDefaults] integerForKey:beautKey];
    
    if ([self.delegate respondsToSelector:@selector(handleBeautyEffects:sliderValue:name:)]) {
        [self.delegate handleBeautyEffects:self.beautyType sliderValue:currentValue name:currentModel.beautyTitle];
    }
}

#pragma mark - lazy
- (NSMutableArray *)array {
    if (!_array) {
        NSMutableArray * selectedItemArray = [MHSDK shareInstance].skinArray;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"MHBeautyParams" ofType:@"plist"];
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
            model.menuType = MHBeautyMenuType_Beauty;
            model.type = [itemDic[@"type"] integerValue];
            model.originalValue =  itemDic[@"value"];
            model.isSelected = [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"kBeauty_%@",model.beautyTitle]];
//            NSString *beautKey = [NSString stringWithFormat:@"beauty_%ld",model.type];
//            NSInteger originalValue = [[NSUserDefaults standardUserDefaults] integerForKey:beautKey];
//            if (originalValue > 0) {
//                model.originalValue = [NSString stringWithFormat:@"%ld",originalValue];
//                [[NSUserDefaults standardUserDefaults] setInteger:originalValue forKey:beautKey];
//            }
            [_array addObject:model];
        }
    }
    return _array;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionInset = UIEdgeInsetsMake(20, 20,20,20);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, window_width,self.frame.size.height) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[MHBeautyMenuCell class] forCellWithReuseIdentifier:@"MHBeautyMenuCell"];
    }
    return _collectionView;
}

- (NSInteger)currentIndex{
    return _lastIndex;
}



@end

