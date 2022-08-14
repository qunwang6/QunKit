//
//  NSAttributedString+MD.m
//  shop
//
//  Created by 陈芳 on 2021/12/14.
//

#import "NSAttributedString+MD.h"
#import "MDFoundation.h"
#import "NSString+MD.h"
#import "NSObject+MD.h"

@implementation NSAttributedString (MD)

- (CGSize)dl_sizeWithMaxWidth:(CGFloat)maxWidth {
    CGRect rect = [self boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                     context:NULL];
    
    return CGSizeMake(ceilf(rect.size.width), ceilf(rect.size.height));
}

@end


@implementation NSMutableAttributedString (DLChain)

- (NSMutableIndexSet *)dl_effectedRanges {
    NSMutableIndexSet *effectedRanges = [self dl_associatedObjectForKey:@"effectedRanges"];
    if (!effectedRanges) {
        effectedRanges = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.string.length)];
        [self dl_setEffectedRanges:effectedRanges];
    }
    return effectedRanges;
}

- (void)dl_setEffectedRanges:(NSMutableIndexSet *)effectedRanges {
    [self dl_setAssociatedObject:effectedRanges forKey:@"effectedRanges"];
}

- (void)dl_applyAttribute:(NSString *)name withValue:(id)value {
    if (self.dl_effectedRanges.count && value) {
        [self.dl_effectedRanges enumerateRangesUsingBlock:^(NSRange range, BOOL * _Nonnull stop) {
            [self addAttribute:name value:value range:range];
        }];
    }
}

- (void)dl_setParagraphStyleValue:(id)value forKey:(NSString *)key {
    NSRange range = NSMakeRange(0, self.string.length);
    NSParagraphStyle *style = [self attribute:NSParagraphStyleAttributeName atIndex:0 effectiveRange:NULL];
    NSMutableParagraphStyle *mutableStyle = nil;
    
    if (style) {
        mutableStyle = [style mutableCopy];
    } else {
        mutableStyle = [NSMutableParagraphStyle new];
//        mutableStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    
    [mutableStyle setValue:value forKey:key];
    [self addAttribute:NSParagraphStyleAttributeName value:mutableStyle range:range];
}
- (NSMutableAttributedString * _Nonnull (^)(CGFloat))cusfnt {
    return ^(CGFloat fontSize) {
        UIFont *font = CusFnt(fontSize);
        [self dl_applyAttribute:NSFontAttributeName withValue:font];
        return self;
    };
}

- (NSMutableAttributedString * _Nonnull (^)(CGFloat))fnt {
    return ^(CGFloat fontSize) {
        UIFont *font = Fnt(fontSize);
        [self dl_applyAttribute:NSFontAttributeName withValue:font];
        return self;
    };
}

- (NSMutableAttributedString * _Nonnull (^)(CGFloat))boldFnt {
    return ^(CGFloat fontSize) {
        UIFont *font = BoldFnt(fontSize);
        [self dl_applyAttribute:NSFontAttributeName withValue:font];
        return self;
    };
}

- (NSMutableAttributedString * _Nonnull (^)(CGFloat))lineGap {
    return ^(CGFloat spacing) {
        [self dl_setParagraphStyleValue:@(spacing) forKey:@"lineSpacing"];
        return self;
    };
}

- (NSMutableAttributedString * _Nonnull (^)(NSTextAlignment))align {
    return ^(NSTextAlignment alignment) {
        [self dl_setParagraphStyleValue:@(alignment) forKey:@"alignment"];
        return self;
    };
}

- (NSMutableAttributedString * _Nonnull (^)(CGFloat))offset {
    return ^(CGFloat offset) {
        [self dl_applyAttribute:NSBaselineOffsetAttributeName withValue:@(offset)];
        return self;
    };
}

- (NSMutableAttributedString * _Nonnull (^)(id _Nonnull))textColor {
    return ^(id color) {
        UIColor *realColor = Color(color);
        [self dl_applyAttribute:NSForegroundColorAttributeName withValue:realColor];
        return self;
    };
}

- (NSMutableAttributedString * _Nonnull (^)(id _Nonnull))bgColor {
    return ^(id color) {
        UIColor *realColor = Color(color);
        [self dl_applyAttribute:NSBackgroundColorAttributeName withValue:realColor];
        return self;
    };
}

- (NSMutableAttributedString * _Nonnull (^)(void))underline {
    return ^() {
        [self dl_applyAttribute:NSUnderlineStyleAttributeName withValue:@(NSUnderlineStyleSingle)];
        return self;
    };
}

- (NSMutableAttributedString * _Nonnull (^)(void))strikeThrough {
    return ^() {
        [self dl_applyAttribute:NSStrikethroughStyleAttributeName withValue:@(NSUnderlineStyleSingle)];
        return self;
    };
}

- (NSMutableAttributedString * _Nonnull (^)(void))toLink {
    return ^() {
        [self dl_applyAttribute:NSLinkAttributeName withValue:@"abc"];
        return self;
    };
}



- (NSArray *)matchesWithRegExp:(id)regExp {
    NSRegularExpression *exp = nil;
    
    if ([regExp isKindOfClass:NSRegularExpression.class]) {
        exp = (id)regExp;
        
    } else if ([regExp isKindOfClass:NSString.class]) {
        exp = [[NSRegularExpression alloc] initWithPattern:regExp options:0 error:nil];
        
    } else if ([regExp isKindOfClass:NSNumber.class]) {
        switch ([regExp integerValue]) {
            case DLMatchTypeURL: exp = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil]; break;
            case DLMatchTypeNumber: exp = [[NSRegularExpression alloc] initWithPattern:@"\\d+(\\.\\d+)?" options:0 error:nil]; break;
            case DLMatchTypeHashTag: exp = [[NSRegularExpression alloc] initWithPattern:@"(?<!\\w)#([\\w\\_]+)?" options:0 error:nil]; break;
            case DLMatchTypeAtTag: exp = [[NSRegularExpression alloc] initWithPattern:@"(?<!\\w)@([\\w\\_]+)?" options:0 error:nil]; break;
        }
    }
    
    NSArray *matches = [exp matchesInString:self.string options:0 range:NSMakeRange(0, self.string.length)];
    return matches?: @[];
}

- (NSMutableAttributedString * _Nonnull (^)(id _Nonnull))select {
    return ^(id regExp) {
        
        [self dl_setEffectedRanges:[NSMutableIndexSet indexSet]];
        NSMutableArray *matches = [NSMutableArray array];
        
        if ([regExp isKindOfClass:NSArray.class]) {
            for (id obj in regExp) {
                [matches addObjectsFromArray:[self matchesWithRegExp:obj]];
            }
            
        } else {
            [matches addObjectsFromArray:[self matchesWithRegExp:regExp]];
        }
        
        for (NSTextCheckingResult *result in matches) {
            [self.dl_effectedRanges addIndexesInRange:result.range];
        }

        return self;
    };
}

- (NSMutableAttributedString * _Nonnull (^)(NSInteger, NSInteger))selectRange {
    return ^(NSInteger location, NSInteger length) {
        if (location != NSNotFound) {
            [self dl_setEffectedRanges:[NSMutableIndexSet indexSet]];
            [self.dl_effectedRanges addIndexesInRange:NSMakeRange(location, length)];
        }
        return self;
    };
}


- (NSMutableAttributedString * _Nonnull (^)(DLMatchType))match {
    return ^(DLMatchType type) {
        id regExp = nil;
        
        switch (type) {
            case DLMatchTypeURL: regExp = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil]; break;
            case DLMatchTypeNumber: regExp = @"\\d+(\\.\\d+)?"; break;
            case DLMatchTypeHashTag: regExp = @"(?<!\\w)#([\\w\\_]+)?"; break;
            case DLMatchTypeAtTag: regExp = @"(?<!\\w)@([\\w\\_]+)?"; break;
            case DLMatchTypeAll: self.selectRange(0, self.string.length); break;
        }
        
        if (regExp) {
            self.select(regExp);
        }
        return self;
    };
}

@end
