//MHStickersView.h
//贴纸UI


#import <UIKit/UIKit.h>
@class StickerDataListModel;

@protocol MHStickersViewDelegate <NSObject>
@required
- (void)handleStickerEffect:(NSString *)stickerContent sticker:(StickerDataListModel *)model withLevel:(NSInteger)level;
/// 照相按钮
- (void)takePhoto;
- (void)clickPackUp;
@end
@interface MHStickersView : UIView
@property (nonatomic, weak) id<MHStickersViewDelegate> delegate;


- (void)configureStickers:(NSArray *)arr;

- (void)configureStickerTypes;
- (void)clearStikerUI;
- (void)cancelStiker;
@end


