//
//  NSObject+MD.m
//  shop
//
//  Created by 陈芳 on 2021/12/14.
//

@import ObjectiveC;
#import "NSObject+MD.h"

@implementation NSObject (MD)
+ (BOOL)dl_isOverridingSuperclassMethod:(SEL)method {
    IMP imp = class_getMethodImplementation(self, method);
    if (!imp) return NO;
    
    Class superClass = self;
    
    do {
        superClass = class_getSuperclass(superClass);
        IMP superImp = class_getMethodImplementation(superClass, method);
        if (superImp) {
            return imp != superImp;
        }
        
    } while(superClass);
    
    return NO;
}

+ (void)dl_swizzleClassSelector:(SEL)originalSelector withOtherSelector:(SEL)otherSelector {
    [object_getClass(self) dl_swizzleInstanceSelector:originalSelector withOtherSelector:otherSelector];
}

+ (void)dl_swizzleInstanceSelector:(SEL)originalSelector withOtherSelector:(SEL)otherSelector {
    Class class = [self class];
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method otherMethod = class_getInstanceMethod(class, otherSelector);
    
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(otherMethod), method_getTypeEncoding(otherMethod));
    if (didAddMethod) {
        class_replaceMethod(class, otherSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, otherMethod);
    }
}

- (id)dl_associatedObjectForKey:(NSString *)key {
    NSMutableDictionary *objects = objc_getAssociatedObject(self, _cmd);
    return [objects objectForKey:key];
}

- (void)dl_setAssociatedObject:(id)object forKey:(NSString *)key {
    NSMutableDictionary *map = objc_getAssociatedObject(self, @selector(dl_associatedObjectForKey:));
    
    if (!map) {
        map = [[NSMutableDictionary alloc] init];
        objc_setAssociatedObject(self, @selector(dl_associatedObjectForKey:), map, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    if (object) {
        [map setObject:object forKey:key];
    } else {
        [map removeObjectForKey:key];
    }
}

- (NSArray<NSString *> *)dl_getAllProperties {
   u_int count;
   objc_property_t *properties = class_copyPropertyList([self class], &count);
   NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];

   for (int i = 0; i<count; i++) {
       const char *propertyName = property_getName(properties[i]);
       [propertiesArray addObject:[NSString stringWithUTF8String: propertyName]];
    }

   free(properties);
   return propertiesArray;
}
@end
