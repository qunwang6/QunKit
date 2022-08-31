//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol MHMagnifiedViewDelegate <NSObject>

- (void)handleMagnify:(NSInteger)type withIsMenu:(BOOL)isMenu;

- (void)takePhoto;

- (void)clickPackUp;
@end
@interface MHMagnifiedView : UIView
@property (nonatomic, weak) id<MHMagnifiedViewDelegate> delegate;
@property (nonatomic, assign) BOOL isHiddenHead;
@end

NS_ASSUME_NONNULL_END
