//
//  NSArray+MD.m
//  shop
//
//  Created by 陈芳 on 2021/12/14.
//

#import "NSArray+MD.h"

@implementation NSArray (MD)

- (NSArray *)dl_filter:(BOOL(^)(id obj))block {
    NSMutableArray *ret = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (block(obj)) [ret addObject:obj];
    }];
    return ret;
}

- (NSArray *)dl_map:(id(^)(id obj))block {
    NSMutableArray *ret = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [ret addObject:block(obj)];
    }];
    return ret;
}

- (id)dl_reduce:(id(^)(id obj, id current))block withInitializer:(id<NSCopying>)initializer {
    __block id ret = [((NSObject *)initializer) copy];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ret = block(obj, ret);
    }];
    return ret;
}

- (NSArray *)dl_forEach:(void(^)(id obj))block {
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (block) block(obj);
    }];
    return self;
}

- (NSString *)dl_toJSONString {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:nil];
    if (!jsonData) return nil;
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
