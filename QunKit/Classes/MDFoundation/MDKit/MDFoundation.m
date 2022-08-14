//
//  DLFoundation.m
//  DLFoundation
//
//  Created by cyp on 2021/5/19.
//

#import "MDFoundation.h"


NSString *Str(NSString *format, ...) {
    if (!format) return nil;
    
    va_list args;
    va_start(args, format);
    
    NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    
    return str;
}

NSMutableAttributedString *AttStr(id obj) {
    if ([obj isKindOfClass:NSAttributedString.class]) {
        return [obj mutableCopy];
        
    } else if ([obj isKindOfClass:NSArray.class]) {
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@""];
        for (id item in obj) {
            [att appendAttributedString:AttStr(item)];
        }
        return att;
        
    } else if ([obj isKindOfClass:UIImage.class]) {
        NSTextAttachment *attachment = [NSTextAttachment new];
        attachment.image = obj;
        id att = [NSAttributedString attributedStringWithAttachment:attachment];
        return [[NSMutableAttributedString alloc] initWithAttributedString:att];
        
    } else if ([obj isKindOfClass:NSData.class]) {
        id options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                       NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)};
        return [[NSMutableAttributedString alloc] initWithData:obj options:options documentAttributes:nil error:nil];
        
    } else {
        return [[NSMutableAttributedString alloc] initWithString:[obj description]];
    }
}

UIColor *Color(id colorString) {
    if ([colorString isKindOfClass:UIColor.class]) return colorString;
    if (![colorString isKindOfClass:NSString.class]) return nil;
    
    NSArray *components = [colorString componentsSeparatedByString:@","];
    
    if (components.count < 3) {
        UIColor *color = [UIColor dl_colorWithHEX:colorString];
        
        if (!color && components.count == 1) {
            color = [UIColor colorNamed:colorString];
            if (!color) {
                SEL sel = NSSelectorFromString([NSString stringWithFormat:@"%@Color", colorString]);
                if ([UIColor respondsToSelector:sel]) {
                    color = [UIColor performSelector:sel];
                }
            }
        }
        
        return color;

    } else {
        return [UIColor dl_colorWithRGB:colorString];
    }
}

UIImage *Img(id obj) {
    if ([obj isKindOfClass:UIImage.class]) {
        return obj;
        
    } else if ([obj isKindOfClass:NSString.class]) {
        NSArray *components = [obj componentsSeparatedByString:@"/"];
        
        if (components.count == 1) {
            return [UIImage imageNamed:obj];
        } else if (components.count == 2) {
            return [UIImage dl_imageNamed:components[1] inBundle:components[0]];
        } else {
            return nil;
        }
        
    } else if ([obj isKindOfClass:UIColor.class]) {
        return [UIImage dl_imageWithColor:obj];
        
    } else {
        return nil;
    }
}

NSBundle *Bundle(NSString *bundleName) {
    if (!bundleName.length) {
        return nil;
    }
    
    static NSMutableDictionary *bundleCaches = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bundleCaches = [NSMutableDictionary dictionary];
    });
    
    if (bundleCaches[bundleName]) {
        return bundleCaches[bundleName];
    }

    NSBundle *containerBundle = nil;
    NSURL *frameworksPath = [[NSBundle mainBundle] URLForResource:@"Frameworks" withExtension:nil];
    
    if (frameworksPath) {
        id containerURL = [frameworksPath URLByAppendingPathComponent:bundleName];
        containerURL = [containerURL URLByAppendingPathExtension:@"framework"];
        containerBundle = [NSBundle bundleWithURL:containerURL];
    }
    
    if (!containerBundle) {
        containerBundle = [NSBundle mainBundle];
    }
    
    NSURL *targetURL = [containerBundle URLForResource:bundleName withExtension:@"bundle"];
    
    if (targetURL) {
        id resourceBundle = [NSBundle bundleWithURL:targetURL];
        bundleCaches[bundleName] = resourceBundle;
        return resourceBundle;
    }

    return nil;
}


UIFont *Fnt(CGFloat fontSize) {
    return [UIFont systemFontOfSize:fontSize];
}

UIFont *BoldFnt(CGFloat fontSize) {
    return [UIFont boldSystemFontOfSize:fontSize];
}
UIFont *CusFnt(CGFloat fontSize) {
    return [UIFont fontWithName:@"YouSheBiaoTiHei" size:fontSize];
}

UIFont* PFFnt(CGFloat fontSize) {
    return [UIFont fontWithName:@"PingFangSC-Regular" size:fontSize];
}

UIFont* BoldPFFnt(CGFloat fontSize) {
    return [UIFont fontWithName:@"PingFangSC-Semibold" size:fontSize];
}


BOOL IsString(id _Nullable object) {
    if (object && [object isKindOfClass:[NSString class]] && ((NSString *)object).length > 0) {
        return YES;
    }
    return NO;
}

BOOL IsArray(id object) {
    if (object && [object isKindOfClass:[NSArray class]] && ((NSArray *)object).count > 0) {
        return YES;
    }
    return NO;
}

BOOL IsDictionary(id object) {
    if (object && [object isKindOfClass:[NSDictionary class]] && ((NSDictionary *)object).allKeys.count > 0) {
        return YES;
    }
    return NO;
}

void PostNotification(NSString *name) {
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil];
}

void PostNotificationInfo(NSString *name, NSDictionary *userInfo) {
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil userInfo:userInfo];
}

void PostNotificationObject(NSString *name, id object) {
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:object];
}

void ListenNotification(NSString *name, id object, SEL selector) {
    [[NSNotificationCenter defaultCenter] addObserver:object selector:selector name:name object:nil];
}
