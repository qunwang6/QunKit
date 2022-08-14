//
//  DLFoundation.h
//  Pods
//
//  Created by cyp on 2021/5/8.
//


#import <UIKit/UIKit.h>
#import "UIColor+MD.h"
#import "UIImage+MD.h"

NS_ASSUME_NONNULL_BEGIN


#pragma mark - 宏定义

///创建指定对象的weak引用
///DLWeakify(self) -> weak_self
#define DLWeakify(obj)      typeof(obj) __weak weak_##obj = obj




#pragma mark - 常用Block定义

typedef void (^MDSimpleBlock)(void);
typedef void (^MDObjectBlock)(id _Nullable object);
typedef void (^MDStringBlock)(NSString *_Nullable string);
typedef void (^MDIntBlock)(NSInteger value);
typedef void (^MDFloatBlock)(CGFloat value);
typedef void (^MDObjectWithBoolBlock)(id _Nullable object,BOOL scuess);



#pragma mark - 常用类型创建

///格式化字符串：Str("%d", 20)
extern NSString *Str(NSString *format, ...);

///Int->String
CG_INLINE NSString *IntStr(NSInteger n) { return [@(n) description]; }



/**
 创建一个NSAttributedString, 配合NSAttributedString+DL.h里的方法来设置属性。obj支持格式：
 (1)NSString
 (2)UIImage
 (3)HTML内容的NSData
 */
extern NSMutableAttributedString *AttStr(id obj);



///系统常规字体
extern UIFont *Fnt(CGFloat fontSize);
///系统加粗字体
extern UIFont *BoldFnt(CGFloat fontSize);
///苹方常规字体
extern UIFont* PFFnt(CGFloat fontSize);
///苹方加粗字体
extern UIFont* BoldPFFnt(CGFloat fontSize);

///自定义字体
extern UIFont* CusFnt(CGFloat fontSize);

/**
 创建一个UIColor，colorString支持格式：
 (1)hex: "#FF0000", "#FF0000,0.7"
 (2)rgb: "255,0,0", "255,0,0,0.7"
 (3)xcassets颜色名
 (4)UIColor颜色的字符串："red", "blue", ...
 */
extern UIColor *_Nullable Color(id _Nullable colorString);



/**
 创建一个UIImage，obj支持格式：
 (1)NSString: "nav", "DLKit/nav"
 (2)UIColor：返回1px大小的指定颜色图片
 */
extern UIImage *_Nullable Img(id _Nullable obj);



///返回对应的Bundle，支持frameworks和非frameworks模式
extern NSBundle *_Nullable Bundle(NSString *_Nullable bundleName);



#pragma mark - 类型判断

/**
 是否是字符串，object为以下条件均为非字符串：
 是nil, 非NSString类, 长度为0
 */
extern BOOL IsString(id _Nullable object);

/**
 是否是数组，object为以下条件均为非数组：
 是nil, 非NSArray类, 长度为0
 */
extern BOOL IsArray(id _Nullable object);

/**
 是否是字典，object为以下条件均为非字典：
 是nil, 非NSDictionary, key数量为0
 */
extern BOOL IsDictionary(id _Nullable object);




#pragma mark - 通知相关
///监听通知
extern void ListenNotification(NSString *name, id object, SEL selector);

///发送通知
extern void PostNotification(NSString *name);
extern void PostNotificationInfo(NSString *name, NSDictionary *_Nullable userInfo);
extern void PostNotificationObject(NSString *name, id _Nullable object);


NS_ASSUME_NONNULL_END
