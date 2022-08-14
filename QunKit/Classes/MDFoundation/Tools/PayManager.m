//
//  PayManager.m
//  shop
//
//  Created by 陈芳 on 2022/1/7.
//

#import "PayManager.h"

@implementation PayManager

+ (PayManager *)sharedManager
{
    static PayManager *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}

@end
