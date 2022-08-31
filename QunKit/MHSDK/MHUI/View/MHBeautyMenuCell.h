//
//  MHBeautyMenuCell.h


#import <UIKit/UIKit.h>
@class MHBeautiesModel;
NS_ASSUME_NONNULL_BEGIN

@interface MHBeautyMenuCell : UICollectionViewCell

@property (nonatomic, strong) MHBeautiesModel *menuModel;
@property (nonatomic, strong) MHBeautiesModel *beautyModel;
@property(nonatomic,strong)MHBeautiesModel *quickModel;
@property(nonatomic,strong)MHBeautiesModel *watermarkModel;
@property(nonatomic,strong)MHBeautiesModel *hahaModel;
@property (nonatomic, assign) BOOL isSimplification;///<精简版

- (void)takePhotoAnimation;
- (void)changeRecordState:(BOOL)isRecording;
@end

NS_ASSUME_NONNULL_END
