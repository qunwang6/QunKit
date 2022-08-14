//
//  MDStringUtils.m
//  shop
//
//  Created by 陈芳 on 2021/12/14.
//
#import <CoreText/CoreText.h>
#import "MDStringUtils.h"
#import <sys/utsname.h>

@implementation MDStringUtils
+ (BOOL)containsDigit:(NSString *)string {
    id regex = [NSRegularExpression regularExpressionWithPattern:@"[0-9]" options:NSRegularExpressionCaseInsensitive error:nil];
    return ([regex rangeOfFirstMatchInString:string options:0 range:NSMakeRange(0, string.length)].location != NSNotFound);
}

+ (BOOL)containsOnlyDigit:(NSString *)string {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"[0-9]*"];
    return [pred evaluateWithObject:string];
}

+ (BOOL)containsAlphabet:(NSString *)string {
    id regex = [NSRegularExpression regularExpressionWithPattern:@"[a-zA-Z]" options:NSRegularExpressionCaseInsensitive error:nil];
    return ([regex rangeOfFirstMatchInString:string options:0 range:NSMakeRange(0, string.length)].location != NSNotFound);
}

+ (BOOL)containsOnlyAlphabet:(NSString *)string {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"[a-zA-Z]*"];
    return [pred evaluateWithObject:string];
}
           
+ (BOOL)containsChinese:(NSString *)string {
    id regex = [NSRegularExpression regularExpressionWithPattern:@"[\u4e00-\u9fa5]" options:NSRegularExpressionCaseInsensitive error:nil];
    return ([regex rangeOfFirstMatchInString:string options:0 range:NSMakeRange(0, string.length)].location != NSNotFound);
}

+ (BOOL)containsOnlyChinese:(NSString *)string {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"(^[\u4e00-\u9fa5]+$)"];
    return [pred evaluateWithObject:string];
}

+ (BOOL)containsEmoji:(NSString *)string {
    static CFMutableCharacterSetRef set = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        CTFontRef fontRef = CTFontCreateWithName(CFSTR("AppleColorEmoji"), 0.0, NULL);
        CFCharacterSetRef charSetRef = CTFontCopyCharacterSet(fontRef);
        set = CFCharacterSetCreateMutableCopy(kCFAllocatorDefault, charSetRef);
        CFCharacterSetRemoveCharactersInString(set, CFSTR(" 0123456789#*"));
        CFRelease(charSetRef);
        CFRelease(fontRef);
    });
    
    return CFStringFindCharacterFromSet((CFStringRef)string, set, CFRangeMake(0, string.length), 0, NULL);
}

+ (BOOL)isValidMobileNumber:(NSString *)string {
    id regex = @"^((13[0-9])|(14[0-9])|(15[0-9])|(18[0-9])|(17[0-9])|(16[0-9])|(19[0-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:string];
}

+ (BOOL)isValidIdNumber:(NSString *)string {
    NSString *regex = @"\\d{15}|\\d{17}[0-9Xx]";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:string];
}

#pragma mark -- 判断手机型号
+ (NSString *)iphoneType {
    struct utsname systemInfo;
     
    uname(&systemInfo);
     
    NSString *phoneType = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
     
    if ([phoneType isEqualToString:@"i386"])   return @"Simulator";
        
    if ([phoneType isEqualToString:@"x86_64"])  return @"Simulator";
        
    //  常用机型  不需要的可自行删除
        
    if([phoneType  isEqualToString:@"iPhone5,3"])  return @"iPhone 5c";
        
    if([phoneType  isEqualToString:@"iPhone5,4"])  return @"iPhone 5c";
        
    if([phoneType  isEqualToString:@"iPhone6,1"])  return @"iPhone 5s";
        
    if([phoneType  isEqualToString:@"iPhone6,2"])  return @"iPhone 5s";
        
    if([phoneType  isEqualToString:@"iPhone7,1"])  return @"iPhone 6 Plus";
        
    if([phoneType  isEqualToString:@"iPhone7,2"])  return @"iPhone 6";
        
    if([phoneType  isEqualToString:@"iPhone8,1"])  return @"iPhone 6s";
        
    if([phoneType  isEqualToString:@"iPhone8,2"])  return @"iPhone 6s Plus";
        
    if([phoneType  isEqualToString:@"iPhone8,4"])  return @"iPhoneSE";
        
    if([phoneType  isEqualToString:@"iPhone9,1"] || [phoneType  isEqualToString:@"iPhone9,3"])  return @"iPhone7";
        
    if([phoneType  isEqualToString:@"iPhone9,2"])  return @"iPhone7Plus";
        
    if([phoneType  isEqualToString:@"iPhone10,1"]) return @"iPhone8";
        
    if([phoneType  isEqualToString:@"iPhone10,4"]) return @"iPhone8";
        
    if([phoneType  isEqualToString:@"iPhone10,2"]) return @"iPhone8Plus";
        
    if([phoneType  isEqualToString:@"iPhone10,5"]) return @"iPhone8Plus";
        
    if([phoneType  isEqualToString:@"iPhone10,3"]) return @"iPhone X";
        
    if([phoneType  isEqualToString:@"iPhone10,6"]) return @"iPhone X";
        
    if([phoneType  isEqualToString:@"iPhone11,8"]) return @"iPhone XR";
        
    if([phoneType  isEqualToString:@"iPhone11,2"]) return @"iPhone XS";
        
    if([phoneType  isEqualToString:@"iPhone11,4"]) return @"iPhone XS Max";
        
    if([phoneType  isEqualToString:@"iPhone11,6"]) return @"iPhone XS Max";
     
    if([phoneType  isEqualToString:@"iPhone12,1"])  return @"iPhone 11";
        
    if ([phoneType isEqualToString:@"iPhone12,3"])  return @"iPhone 11 Pro";
        
    if ([phoneType isEqualToString:@"iPhone12,5"])   return @"iPhone 11 Pro Max";
        
    if ([phoneType isEqualToString:@"iPhone12,8"])   return @"iPhoneSE2";

    if ([phoneType isEqualToString:@"iPhone13,1"])   return @"iPhone 12 mini";

    if ([phoneType isEqualToString:@"iPhone13,2"])   return @"iPhone 12";
        
    if ([phoneType isEqualToString:@"iPhone13,3"])   return @"iPhone 12  Pro";

    if ([phoneType isEqualToString:@"iPhone13,4"])   return @"iPhone 12  Pro Max";
        
    if ([phoneType isEqualToString:@"iPhone14,4"])   return @"iPhone 13 mini";
        
    if ([phoneType isEqualToString:@"iPhone14,5"])   return @"iPhone 13";
        
    if ([phoneType isEqualToString:@"iPhone14,2"])   return @"iPhone 13  Pro";
        
    if ([phoneType isEqualToString:@"iPhone14,3"])   return @"iPhone 13  Pro Max";
     
    return phoneType;
     
}


@end
