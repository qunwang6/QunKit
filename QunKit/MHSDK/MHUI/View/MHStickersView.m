//
//  MHStickersView.m


#import "MHStickersView.h"
#import "MHStickerCell.h"
//#import "StickerManager.h"
//#import "StickerDataListModel.h"
#import "MHSectionStickersView.h"
#import "MHBeautyParams.h"
#import "MHBottomView.h"
#import <MHBeautySDK/MHBeautySDK.h>

#define kNetWorkPrefix @"https://data.facegl.com"

@interface MHStickersView ()<UIScrollViewDelegate,MHSectionStickersViewDelegate>
@property (nonatomic, assign) NSInteger lastIndex;//记录按钮的索引，以便更新UI
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *views;
@property(nonatomic,strong)NSArray *stickersArr;
@property (nonatomic, assign) NSInteger lastViewIndex;//记录View索引，取消选中贴纸
@property (nonatomic, assign) BOOL isFirstSelect;
@property (nonatomic, assign) NSInteger currentViewIndex;
@property (nonatomic, strong) NSMutableArray *titleBtnArr;
@property (nonatomic, strong) NSMutableArray *allArr;
@property (nonatomic, strong) NSMutableArray *urls;
@property (nonatomic, strong) MHBottomView * bottomView;
@property (nonatomic, assign) int sdkLevelTYpe;///<sdk类型


@end
@implementation MHStickersView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.lastViewIndex = -1;
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"selectedStickerIndex"];
        _urls = [NSMutableArray array];
        [self configureStickerTypes];
    }
    return self;
}

- (void)configureStickerTypes {
    for (UIView *subview in self.subviews){
        [subview removeFromSuperview];
    }
    NSMutableArray *titleBtns = [NSMutableArray array];
    [self.urls removeAllObjects];
    self.stickersArr = [MHSDK shareInstance].stickerArray;
    for (int i = 0; i < self.stickersArr.count; i++) {
        NSDictionary * itemDic1 = self.stickersArr[i];
        NSString * selectedItemName = itemDic1[@"name"];
        NSAttributedString *name = [self stringAttachment:selectedItemName textColor:i==0?FontColorSelected:FontColorBlackNormal];
        [titleBtns addObject:name];
        NSString * urlString = [NSString stringWithFormat:@"%@%@",kNetWorkPrefix,itemDic1[@"mark"]];
        NSData *data = [urlString dataUsingEncoding:NSUTF8StringEncoding];
         urlString = [data base64EncodedStringWithOptions:0];
        [_urls addObject:urlString];
    }
    self.allArr = [NSMutableArray arrayWithCapacity:titleBtns.count];
    self.titleBtnArr = [NSMutableArray arrayWithCapacity:titleBtns.count];
    self.views = [NSMutableArray arrayWithCapacity:titleBtns.count];
    UIButton *cancelBtn = [UIButton buttonWithType:0];
    UIImage * image = BundleImg(@"sticker_not");

    [cancelBtn setHighlighted:YES];
    cancelBtn.frame = CGRectMake(0, 0, MHStickerSectionHeight, MHStickerSectionHeight);
    cancelBtn.tag = 1108;
    [cancelBtn addTarget:self action:@selector(cancelStiker) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBtn];
    
    UIImageView * imageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, MHStickerSectionHeight - 20, MHStickerSectionHeight - 20)];
    imageV.image = image;
    [self addSubview:imageV];
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(MHStickerSectionHeight, 0, 0.5, MHStickerSectionHeight)];
    line.backgroundColor = LineColor;
    [self addSubview:line];
    
    for (int i = 0; i<titleBtns.count; i++) {
        UIButton *titleBtn = [UIButton buttonWithType:0];
        [titleBtn setAttributedTitle:titleBtns[i] forState:0];
        titleBtn.frame = CGRectMake(((window_width - MHStickerSectionHeight)/titleBtns.count)*i + MHStickerSectionHeight, 0, ((window_width - MHStickerSectionHeight)/titleBtns.count), MHStickerSectionHeight);
        titleBtn.tag = 1109+i;
        [titleBtn addTarget:self action:@selector(switchStickerOrMask:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:titleBtn];
        NSMutableArray *muArr = [NSMutableArray array];
        [self.allArr addObject:muArr];
        [self.titleBtnArr addObject:titleBtn];
        MHSectionStickersView *stickersView = [[MHSectionStickersView alloc] initWithFrame:CGRectMake(window_width * i, 0, window_width, self.frame.size.height - MHStickerSectionHeight-0.5)];
        stickersView.tag = [self.stickersArr[i][@"list_order"] integerValue] +1111;
        stickersView.lastTag = stickersView.tag;
        stickersView.delegate = self;
        [self.scrollView addSubview:stickersView];
        [self.views addObject:stickersView];
    }
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, MHStickerSectionHeight, window_width, 0.5)];
    _lineView.backgroundColor = LineColor;
    [self addSubview:_lineView];
    [self addSubview:self.scrollView];
    if (isNeedBottom) {
        [self addSubview:self.bottomView];
    }
//    self.frame.origin.y
    ///修改MHUI
    CGFloat bottom = self.lineView.frame.origin.y + self.lineView.frame.size.height;
//    CGFloat bottom = MHStickerSectionHeight;
    CGRect rect = self.scrollView.frame;
    self.scrollView.frame = CGRectMake(rect.origin.x, bottom, rect.size.width, rect.size.height);
    self.scrollView.contentSize = CGSizeMake(window_width * titleBtns.count, self.frame.size.height - bottom);
}

- (void)switchStickerOrMask:(UIButton *)btn {
    NSInteger tag = btn.tag - 1109;
    [self.scrollView setContentOffset:CGPointMake(window_width * tag, 0) animated:YES];
    [self switchViewToRequestData:tag];
}

- (void)switchSelectedBtnUI:(NSInteger)index textColor:(UIColor *)color {
    UIButton *curentBtn = self.titleBtnArr[index];
    NSAttributedString *str = curentBtn.currentAttributedTitle;
    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithAttributedString:str];
    [str2 addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, str.length)];
    [curentBtn setAttributedTitle:str2 forState:0];
    
}

- (void)clearStikerUI{
    if (self.lastIndex >= 0) {
        if ([MHSDK shareInstance].stickerArray.count == 0) {
            return;
        }
       
        NSMutableArray *currentArr = self.allArr[self.currentViewIndex];
        MHSectionStickersView *currentSubView = self.views[self.currentViewIndex];
        NSString *la = [[NSUserDefaults standardUserDefaults] objectForKey:@"selectedStickerIndex"];
        if (la != nil && ![la isEqualToString:@""]) {
            NSInteger laindex = la.integerValue;
            if (laindex < currentArr.count) {
                StickerDataListModel *model = currentArr[laindex+1];
                model.isSelected = NO;
                currentSubView.lastIndex = -1;
                [currentSubView.collectionView reloadData];
            }
        }else{
            [currentArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                StickerDataListModel *model = obj;
                model.isSelected = NO;
                if (stop) {
                    [currentSubView.collectionView reloadData];
                }
            }];
        }
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

#pragma mark - delegate
- (void)handleSelectedStickerEffect:(NSString *)stickerContent stickerModel:(nonnull StickerDataListModel *)model{
    //NSLog(@"sss---%@",stickerContent);
    if (!IsStringWithAnyText(model.name) && !IsStringWithAnyText(model.resource) ) {
        if ([self.delegate respondsToSelector:@selector(handleStickerEffect: sticker:withLevel:)]) {
            [self.delegate handleStickerEffect:@"" sticker:nil withLevel:0];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kMHSticker];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(handleStickerEffect: sticker:withLevel:)]) {
            NSDictionary * itemDic = self.stickersArr[self.currentViewIndex];
            NSInteger level = [itemDic[@"id"] integerValue];
            [self.delegate handleStickerEffect:stickerContent sticker:model withLevel:level];
            if (isSaveSticker) {
                NSDictionary *info = @{@"content":stickerContent,
                                       @"kLevel":@(level)};
                [[NSUserDefaults standardUserDefaults] setObject:info forKey:kMHSticker];
            }
           
        }
    }
}

//当切换分类后，点击贴纸，取消上一个分类下贴纸的选中效果
- (void)reloadLastStickerSelectedStatus:(BOOL)needReset {
    if (!self.isFirstSelect) {
        self.lastViewIndex = 0;
        self.isFirstSelect = YES;
    }
    MHSectionStickersView *lastSubView = self.views[self.lastViewIndex];

    NSMutableArray *lastArr = self.allArr[self.lastViewIndex];
    NSString *la = [[NSUserDefaults standardUserDefaults] objectForKey:@"selectedStickerIndex"];
    if (la != nil && ![la isEqualToString:@""]) {
        NSInteger laindex = la.integerValue;
        if (laindex < lastArr.count) {
            StickerDataListModel *model = lastArr[laindex];
            model.isSelected = !needReset;
            [lastSubView.collectionView reloadData];
        }
    }
    MHSectionStickersView *subView = self.views[self.currentViewIndex];
    subView.lastTag = subView.tag;
    self.lastViewIndex = self.currentViewIndex;
}
#pragma mark - 取消贴纸
- (void)cancelStiker{
    StickerDataListModel * model = [[StickerDataListModel alloc] init];
    model.resource = @"";
    [self handleSelectedStickerEffect:model.name stickerModel:model];
    [self clearStikerUI];
}


#pragma mark - data
- (void)configureStickers:(NSArray *)arr {
    NSMutableArray *muArr = self.allArr.firstObject;
    [muArr addObjectsFromArray:arr];
    MHSectionStickersView *stickersView = self.views.firstObject;
    [stickersView configureData:arr];
}

- (BOOL)stickerIsExistWithStickerName:(NSString * )stickerName{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"sticker"];
    NSString * path1 = [path stringByAppendingPathComponent:stickerName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path1]) {
        return NO;
    }
    
    return YES;
}



- (void)switchViewToRequestData:(NSInteger)index {
    
    NSInteger currentIndex = MIN(index, self.allArr.count);
    NSMutableArray *arr = self.allArr[currentIndex];
    [arr removeAllObjects];
    MHSectionStickersView *currentSubView = self.views[currentIndex];
    NSString *url = self.urls[currentIndex];
    
    NSDictionary * itemDic = [MHSDK shareInstance].stickerArray[index];
    NSString * oldStickerVersion = [[NSUserDefaults standardUserDefaults] objectForKey:OldStickerVesion];
    NSString * stickerVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"sticker_version"];
    NSArray * stickerArr = [[NSUserDefaults standardUserDefaults] objectForKey:itemDic[@"name"]];
    NSMutableArray * stickerMutArr = [NSMutableArray array];
    StickerDataListModel *model;
    NSSet *set = [NSSet setWithObjects:[NSString class],[NSNumber class],[StickerDataListModel class], nil];
    for (NSData * data in stickerArr) {
        if (data && ![data isKindOfClass:[NSString class]]) {
            if (@available(iOS 11.0,*)) {
                model = [NSKeyedUnarchiver unarchivedObjectOfClasses:set fromData:data error:nil];
            }else{
                model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            }
            model.is_downloaded = [self stickerIsExistWithStickerName:model.name]?@"1":@"0";
            [stickerMutArr addObject:model];
        }
    }
    if ((oldStickerVersion && oldStickerVersion.length > 0) && (stickerMutArr && stickerMutArr.count > 0)&& ([oldStickerVersion isEqual:stickerVersion])) {
        [currentSubView configureData:stickerMutArr];
        [arr addObjectsFromArray:stickerMutArr];
        [self.allArr replaceObjectAtIndex:index withObject:arr];
    } else {
        [[StickerManager sharedManager] requestStickersListWithUrl:url
            Success:^(NSArray<StickerDataListModel *> * _Nonnull stickerArray) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [arr addObjectsFromArray:stickerArray];
                [self.allArr replaceObjectAtIndex:index withObject:arr];
                [currentSubView configureData:arr];
                NSMutableArray * dataArray = [NSMutableArray arrayWithCapacity:stickerArray.count];
                for (StickerDataListModel * model in stickerArray) {
                    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:model requiringSecureCoding:YES error:nil];
                    [dataArray addObject:data];
                }
                [[NSUserDefaults standardUserDefaults] setObject:dataArray forKey:itemDic[@"name"]];
                [[NSUserDefaults standardUserDefaults] setObject:stickerVersion forKey:OldStickerVesion];
            });
                                                    
        } Failed:^{
                                                               
        }];
    }
    if (!self.isFirstSelect) {
        self.lastViewIndex = 0;
        self.isFirstSelect = YES;
        self.lastIndex = 0;
    }
    
    MHSectionStickersView *lastSubView = self.views[self.lastViewIndex];
    currentSubView.lastTag = lastSubView.tag;
    
    [self switchSelectedBtnUI:currentIndex textColor:FontColorSelected];
    if (self.lastIndex != currentIndex) {
        [self switchSelectedBtnUI:self.lastIndex textColor:FontColorBlackNormal];
    }
    self.lastIndex = currentIndex;
    self.currentViewIndex = currentIndex;
}

#pragma mark - scrollDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / window_width;
    [self switchViewToRequestData:index];
}

#pragma mark - lazy
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, window_width, self.frame.size.height - MHStickerSectionHeight-0.5)];
        _scrollView.pagingEnabled = YES;
        ///修改MHUI
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
        _scrollView.scrollsToTop = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

///修改MHUI
- (MHBottomView*)bottomView{

    if (!_bottomView) {
        __weak typeof(self) weakSelf = self;
        CGFloat bottom =  self.frame.size.height - MHBottomViewHeight;
        _bottomView = [[MHBottomView alloc] initWithFrame:CGRectMake(0, bottom, window_width, MHBottomViewHeight)];
        _bottomView.isSticker = YES;
//        _bottomView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _bottomView.clickBtn = ^(BOOL isTakePhoto) {
            [weakSelf cameraAction:isTakePhoto];
        };
    }
    return _bottomView;
}

- (NSAttributedString *)stringAttachment:(NSString *)content textColor:(UIColor *)color {
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:content];
    [string addAttributes:@{NSForegroundColorAttributeName:color,NSFontAttributeName:Font_12} range:NSMakeRange(0, string.length)];
    if ([content containsString:@"基础"]) {
        return string;
    }
    NSTextAttachment *attchment = [[NSTextAttachment alloc]init];
    attchment.bounds = CGRectMake(0, 2.5,18,10);//设置frame
    UIImage *img = BundleImg(@"pro");
    attchment.image = img;//设置需要插入的图片
    NSAttributedString *attchmentString = [NSAttributedString attributedStringWithAttachment:attchment];
    [string appendAttributedString:attchmentString];
    return string;
}

- (int)sdkLevelTYpe{
    return [[MHSDK shareInstance] getSDKLevel];
}
@end
