//
//  MDApp.m
//  shop
//
//  Created by 陈芳 on 2021/12/15.
//

#import "MDApp.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "UIImage+GIF.h"

MDApp *app = nil;

@interface MDApp ()

@property (nonatomic, copy) NSString *deviceUDID;
@property (nonatomic, weak) MBProgressHUD *loadingHUD;
@property (nonatomic, weak) MBProgressHUD *toastHUD;

@end
@implementation MDApp
+ (void)load {
    app = [MDApp new];
}
- (NSString *)name {
    NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    if (!appName) appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:(id)kCFBundleNameKey];
    return appName;
}

- (NSString *)version {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

- (NSString *)buildVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
}

- (NSString *)bundleIdentifier{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
}

- (UIImage *)icon {
    return Img(@"AppIcon60x60");
}
- (BOOL)hasNotch {
    return self.safeArea.bottom > 0;
}
- (UIEdgeInsets)safeArea {
    static UIEdgeInsets windowSafeArea;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        UIWindow *window = [UIWindow new];
        if (@available(iOS 11.0, *)) {
            windowSafeArea = window.safeAreaInsets;
        }
        if (windowSafeArea.top == 0 && windowSafeArea.bottom == 0 && self.window) {
            if (@available(iOS 11.0, *)) {
                windowSafeArea = self.window.safeAreaInsets;
            } else {
                // Fallback on earlier versions
            }
        }
    });
    
    return windowSafeArea;
}

@end

#pragma mark - 导航相关

@implementation MDApp (Controller)

- (UIWindow *)window {
    return [[[UIApplication sharedApplication] delegate] window];
}

- (UIWindow *)keyWindow {
    return [UIApplication sharedApplication].keyWindow;
}

- (UIViewController *)topVC {
    UIViewController *topVC = [self findTopVC:self.window.rootViewController];
    while (topVC.presentedViewController && ![topVC.presentedViewController isKindOfClass:UIAlertController.class]) {
        topVC = [self findTopVC:topVC.presentedViewController];
    }
    return topVC;
}

- (UIViewController *)findTopVC:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self findTopVC:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self findTopVC:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

- (void)pushVC:(UIViewController *)vc {
    [self pushVC:vc animated:YES];
}

- (void)pushVC:(UIViewController *)vc animated:(BOOL)animated {
    vc.hidesBottomBarWhenPushed = YES;
    [self.topVC.navigationController pushViewController:vc animated:animated];
}

- (void)popVCAnimated:(BOOL)animated {
    UINavigationController *topNC = self.topVC.navigationController;
    
    if (topNC.viewControllers.count > 1) {
        [topNC popViewControllerAnimated:animated];
    }else{
        [self dismissVCAnimated:animated completion:nil];
    }
}

- (BOOL)popToVCWithClass:(Class)vcClass animated:(BOOL)animated {
    
    UITabBarController *tabVC = nil;
    if ([self.window.rootViewController isKindOfClass:UITabBarController.class]) {
        tabVC = (id)self.window.rootViewController;
    }
    if (tabVC.viewControllers.count>0) {
        UINavigationController *nc = (UINavigationController *)tabVC.selectedViewController;        
        for (UIViewController *vc in nc.viewControllers) {
            if ([vc isKindOfClass:vcClass]) {
                [nc popToViewController:vc animated:animated];
                return YES;
            }
        }
        
    }
    
    
    return NO;
}

- (void)popToRootVCAnimated:(BOOL)animated {
    [self.topVC.navigationController popToRootViewControllerAnimated:animated];
}


- (void)presentVC:(UIViewController *)vc {
    [self presentVC:vc animated:YES completion:nil];
}

- (void)presentVC:(UIViewController *)vc animated:(BOOL)animated completion:(MDSimpleBlock)completion {
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.topVC presentViewController:vc animated:animated completion:completion];
}

- (void)dismissVC {
    [self dismissVCAnimated:YES completion:nil];
}
- (void)dismissVCAnimated:(BOOL)animated completion:(MDSimpleBlock)completion {
    [self.topVC dismissViewControllerAnimated:animated completion:completion];
}

- (void)selectTabWithIndex:(NSInteger)index {
    UITabBarController *tabVC = nil;
    if ([self.window.rootViewController isKindOfClass:UITabBarController.class]) {
        tabVC = (id)self.window.rootViewController;
    }
    
    if (!tabVC) {
        return;
    }
    if (tabVC.viewControllers.count>0) {
        UINavigationController *nc = (UINavigationController *)tabVC.selectedViewController;
        [nc popToRootViewControllerAnimated:NO];
    }
    tabVC.selectedIndex = index;
}

@end


#pragma mark - 提示

@implementation MDApp (Prompt)

- (MBProgressHUD *)lightHUD {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
    return hud;
}

- (MBProgressHUD *)darkHUD {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
    hud.contentColor = [UIColor whiteColor];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.65];
//    NSString * path = [[NSBundle mainBundle] pathForResource:@"loading" ofType:@"gif"];
//    NSData * data = [NSData dataWithContentsOfFile:path];
//    UIImage * dataImg = [UIImage imageWithData:data];
//    UIImageView * cusImageView = [[UIImageView alloc] initWithImage:dataImg];
//    hud.customView = cusImageView;
//    hud.mode = MBProgressHUDModeCustomView;
//    hud.removeFromSuperViewOnHide = YES;
    return hud;
}

- (void)showLoading {
    if (!self.loadingHUD) {
        self.loadingHUD = [self darkHUD];
    }
    self.loadingHUD.tag++;
    self.loadingHUD.label.text = nil;
}

- (void)showLoading:(NSString *)msg {
    [self showLoading];
    
    if (msg.length) {
        self.loadingHUD.label.text = msg;
        self.loadingHUD.label.numberOfLines = 0;
    }
}

- (void)hideLoading {
    self.loadingHUD.tag--;
    if (self.loadingHUD.tag <= 0) {
        [self.loadingHUD hideAnimated:YES];
    }
}

- (void)showLightLoading;{
    if (!self.loadingHUD) {
        self.loadingHUD = [self lightHUD];
    }
    self.loadingHUD.tag++;
    self.loadingHUD.label.text = nil;
}

- (void)showLightLoading:(NSString *)msg;{
    [self showLightLoading];
    
    if (msg.length) {
        self.loadingHUD.label.text = msg;
        self.loadingHUD.label.numberOfLines = 0;
    }
}

- (void)showToast:(id)msg {
    NSString *text = nil;
    if ([msg isKindOfClass:NSError.class]) {
        text = ((NSError *)msg).localizedDescription;
    } else {
        text = [msg description];
    }

    if (text.length) {
        [self hideToast];
        
        MBProgressHUD *hud = nil;
        hud = [self darkHUD];
        hud.offset = CGPointMake(0.f, SCREEN_WIDTH / 2 - (app.hasNotch? 100: 80));
        hud.mode = MBProgressHUDModeText;
        hud.label.text = text;
        hud.label.numberOfLines = 0;
        hud.margin = 12;
        hud.userInteractionEnabled = NO;
        [hud hideAnimated:YES afterDelay:2];
        
        self.toastHUD = hud;
    }
}

- (void)hideToast {
    [self.toastHUD hideAnimated:YES];
}

- (UIAlertController *)showAlert:(id)message okTitle:(NSString *)okTitle okClick:(MDSimpleBlock)okClick {
    return [self showAlert:message okTitle:okTitle okClick:okClick cancelTitle:@"" cancelClick:nil];
}

- (UIAlertController *)showAlert:(id)message okTitle:(NSString *)okTitle okClick:(MDSimpleBlock)okClick cancelTitle:(NSString *)cancelTitle cancelClick:(MDSimpleBlock)cancelClick {
    
    NSString *title = nil;
    NSString *msg = nil;
    
    if ([message isKindOfClass:NSArray.class]) {
        title = [message firstObject];
        msg = [message lastObject];
    } else {
        msg = [message description];
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];

    if (okTitle.length) {
        [alert addAction:[UIAlertAction actionWithTitle:okTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (okClick) okClick();
        }]];
    }
    
    if (cancelTitle.length) {
        [alert addAction:[UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (cancelClick) cancelClick();
        }]];
    }
    
    [self presentVC:alert];
    return alert;
}

- (UIAlertController *)showActionSheet:(id)message optionTitles:(NSArray *)optionTitles optionClick:(void (^)(NSInteger index))optionClick cancelTitle:(NSString *)cancelTitle cancelClick:(MDSimpleBlock)cancelClick {
    return [self showActionSheet:message optionTitles:optionTitles optionClick:optionClick destructiveTitle:nil destructiveClick:nil cancelTitle:cancelTitle cancelClick:cancelClick];
}

- (UIAlertController *)showActionSheet:(id)message optionTitles:(NSArray *)optionTitles optionClick:(void (^)(NSInteger index))optionClick destructiveTitle:(NSString *)destructiveTitle destructiveClick:(MDSimpleBlock)destructiveClick {
    return [self showActionSheet:message optionTitles:optionTitles optionClick:optionClick destructiveTitle:destructiveTitle destructiveClick:destructiveClick cancelTitle:nil cancelClick:nil];
}

- (UIAlertController *)showActionSheet:(id)message optionTitles:(NSArray *)optionTitles optionClick:(void (^)(NSInteger index))optionClick destructiveTitle:(NSString *)destructiveTitle destructiveClick:(MDSimpleBlock)destructiveClick cancelTitle:(NSString *)cancelTitle cancelClick:(MDSimpleBlock)cancelClick {
    
    NSString *title = nil;
    NSString *msg = nil;
    
    if ([message isKindOfClass:NSArray.class]) {
        title = [message firstObject];
        msg = [message lastObject];
    } else {
        msg = [message description];
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (id optionTitle in optionTitles) {
        [alert addAction:[UIAlertAction actionWithTitle:optionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (optionClick) optionClick([optionTitles indexOfObject:optionTitle]);
        }]];
    }
    
    if (destructiveTitle) {
        [alert addAction:[UIAlertAction actionWithTitle:destructiveTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            if (destructiveClick) destructiveClick();
        }]];
    }
    
    if (cancelTitle) {
        [alert addAction:[UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (cancelClick) cancelClick();
        }]];
    }
    
    [self presentVC:alert];
    return alert;
}

@end
