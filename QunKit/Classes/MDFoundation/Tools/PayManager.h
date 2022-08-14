//
//  PayManager.h
//  shop
//
//  Created by 陈芳 on 2022/1/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PayManager : NSObject

+ (PayManager *)sharedManager;
//支付状态
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *orderId;//订单ID
@property (nonatomic, copy) NSString *orderType;//订单类型 1 盲盒提取 2 盲盒支付 3 现金支付 4 奇豆支付
@property (nonatomic, copy) NSString *orderPrice;//支付金额
@property (nonatomic, assign) NSInteger payType;//支付类型 1：支付宝2 微信(h5) 3微信(小程序) 4招商支付宝  7支付宝h5
@property (nonatomic, copy) NSString *idfaString;//idfa广告标识符
@property (nonatomic, copy) NSString * netType;//网络状态

@end

NS_ASSUME_NONNULL_END
