//
//  MDBaseAlert.m
//  shop
//
//  Created by 陈芳 on 2021/12/24.
//

#import "MDBaseAlert.h"

@interface MDBaseAlert()
@property (nonatomic, weak) UIView *bodyView;
@property (nonatomic, weak) UIView *maskingView;
@end
@implementation MDBaseAlert

static NSMutableArray *alertQueues = nil;


+ (instancetype)show {
    return [self showInView:app.window];
}

+ (instancetype)showInView:(UIView *)parentView {
    return [self showInView:parentView origin:CGPointMake(MAXFLOAT, MAXFLOAT)];
}

+ (instancetype)showInView:(UIView *)parentView origin:(CGPoint)origin {
    UIControl *mask = [[UIControl alloc] initWithFrame:parentView.bounds];
    mask.hidden = YES;
    [parentView addSubview:mask];

    UIView *body = [self bodyView];
    MDBaseAlert *contentView = (id)body;

    body.translatesAutoresizingMaskIntoConstraints = NO;
    body.layer.cornerRadius = [self bodyCornerRadius];
    
    if (body.layer.cornerRadius > 0) {
        body.layer.masksToBounds = YES;
    }

    contentView.bodyView = body;
    contentView.maskingView = mask;

    [mask addSubview:body];
    
    if ([self supportsTapToDismiss]) {
        [mask addTarget:contentView action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    

    CGFloat bodyWidth = body.width;
    CGFloat bodyHeight = body.height;
    CGFloat margin = [self bodyMarginToEdge];
    CGPoint centerOffset = [self bodyCenterOffset];
    
    if (margin > 0) {
        bodyWidth = SCREEN_WIDTH - margin * 2;
    }
    
    if (origin.x > 100000 && origin.y > 100000) {
        [body.centerXAnchor constraintEqualToAnchor:mask.centerXAnchor constant:centerOffset.x].active = YES;
        [body.centerYAnchor constraintEqualToAnchor:mask.centerYAnchor constant:centerOffset.y].active = YES;
        [body.widthAnchor constraintEqualToConstant:bodyWidth].active = YES;
        
    } else {
        [body.leftAnchor constraintEqualToAnchor:mask.leftAnchor constant:origin.x].active = YES;
        [body.rightAnchor constraintEqualToAnchor:mask.rightAnchor constant:origin.y].active = YES;
        [body.widthAnchor constraintEqualToConstant:bodyWidth].active = YES;
    }

    [mask layoutIfNeeded];
    
    CGSize bodySize = [body systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    if (bodySize.height == 0) {
        [body.heightAnchor constraintEqualToConstant:bodyHeight].active = YES;
    }
    
    [contentView configBodyForDisplay:NO];
    [contentView configMaskForDisplay:NO];
    
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        alertQueues = [NSMutableArray array];
    });
    
    if ([self showInOrder]) {
        [alertQueues addObject:contentView];
        [self displayFirstAlert];
    } else {
        [contentView displayWithAnimation];
    }

    return contentView;
}




+ (CGFloat)bodyCornerRadius {
    return 8;
}

+ (CGFloat)bodyMarginToEdge {
    return 0;
}

+ (UIColor *)maskColor {
    return [[UIColor blackColor] colorWithAlphaComponent:0.6];
}

+ (BOOL)supportsTapToDismiss {
    return NO;
}

+ (BOOL)showInOrder {
    return YES;
}

+ (CGPoint)bodyCenterOffset {
    return CGPointZero;
}

+ (instancetype)bodyView {
    return [self.class dl_loadFromXib];
}

+ (void)displayFirstAlert {
    MDBaseAlert *alert = alertQueues.firstObject;
    if (alert) {
        [alert displayWithAnimation];
    }
}

- (void)displayWithAnimation {
    if (self.maskingView.hidden == NO) {
        return;
    }
    
#ifdef DEBUG
    NSLog(@"%@ show", NSStringFromClass(self.class));
#endif
    
    self.maskingView.hidden = NO;
    [self.maskingView.superview bringSubviewToFront:self.maskingView];
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0.0 options:0 animations:^{
        [self configBodyForDisplay:YES];
    } completion:nil];
    
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self configMaskForDisplay:YES];
    } completion:nil];
}

- (IBAction)dismiss {
#ifdef DEBUG
    NSLog(@"%@ dismiss", NSStringFromClass(self.class));
#endif
    
    [UIView animateWithDuration:0.15 animations:^{
        [self configBodyForDisplay:NO];
        [self configMaskForDisplay:NO];
    } completion:^(BOOL finished) {
        [self.maskingView removeFromSuperview];
        [alertQueues removeObject:self];
        [self.class displayFirstAlert];
        PostNotification(@"alertDissMissView");
    }];
}

- (void)configBodyForDisplay:(BOOL)display {
    if (display) {
        self.bodyView.alpha = 1;
        self.bodyView.transform = CGAffineTransformIdentity;
    } else {
        self.bodyView.alpha = 0;
        self.bodyView.transform = CGAffineTransformMakeScale(0.9, 0.9);
    }
}

- (void)configMaskForDisplay:(BOOL)display {
    if (display) {
        self.maskingView.backgroundColor = [self.class maskColor];
    } else {
        self.maskingView.backgroundColor = [UIColor clearColor];
    }
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.bodyView.transform = CGAffineTransformMakeTranslation(0, -keyboardFrame.size.height / 2);
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.bodyView.transform = CGAffineTransformMakeTranslation(0, 0);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    ListenNotification(UIKeyboardWillShowNotification, self, @selector(keyboardWillShow:));
    ListenNotification(UIKeyboardWillHideNotification, self, @selector(keyboardWillHide:));
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
