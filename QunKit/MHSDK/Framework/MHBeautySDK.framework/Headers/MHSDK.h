//
//  MHSDK.h


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MHSDK : NSObject

+ (instancetype)shareInstance;

@property (nonatomic, strong) NSMutableArray * menuArray;
@property (nonatomic, strong) NSMutableArray * beautyAssembleArr;
@property (nonatomic, strong) NSMutableArray * stickerArray;
@property (nonatomic, strong) NSMutableArray * makeupArray;
@property (nonatomic, strong) NSMutableArray * effectMenuArray;
@property (nonatomic, strong) NSMutableArray * magnifiedArray;
@property (nonatomic, strong) NSMutableArray * meunMagnifiedArray;
@property (nonatomic, strong) NSMutableArray * skinArray;
@property (nonatomic, strong) NSMutableArray * faceArr;
@property (nonatomic, strong) NSMutableArray * completeBeautyArray;
@property (nonatomic, strong) NSMutableArray * filterArray;
@property (nonatomic, strong) NSMutableArray * specificEffectArray;
@property (nonatomic, strong) NSMutableArray * actionArray;
/**
 appID：授权appID，请联系美狐工作人员获取（Please contact the staff of Meihu for appID）
 appKey：授权key，请联系美狐工作人员获取（Please contact the staff of Meihu for appKey）
 */
- (void)initWithAppID:(NSString *)appID key:(NSString *)appKey;

- (void)dataTaskWithURLKey:(NSString *)urlKey responseCompletionHandler:(void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler;
/**
 sdk Type：（0 Customized 1 Streamlined 2 Basic 3  Standard 4 Professional）
 */
- (int)getSDKLevel;
//允许输出打印信息，要在调用initWithAppID方法后调用该方法
- (void)configEnableLog;
@end

NS_ASSUME_NONNULL_END
