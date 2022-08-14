//
//  MDSvgaAnimationManager.m
//  shop
//
//  Created by 陈芳 on 2022/1/20.
//

#import "MDSvgaAnimationManager.h"
#import <SVGAPlayer/SVGAParser.h>
#import <SVGAPlayer/SVGAPlayer.h>
#import <SVGAPlayer/SVGAVideoEntity.h>

@interface MDSvgaAnimationManager () <SVGAPlayerDelegate>

@property (nonatomic, strong) SVGAPlayer *svgaPlayer;
@property (nonatomic, strong) SVGAParser *svgaParser;
@end

@implementation MDSvgaAnimationManager

- (void)showAnimation:(NSString *)svgaName
{
    if (!IsString(svgaName)) {
        return;
    }
    [self.svgaParser parseWithNamed:svgaName
                           inBundle:[NSBundle mainBundle]
                    completionBlock:^(SVGAVideoEntity *_Nonnull videoItem) {
        self.svgaPlayer.frame = self.svgaPlayerView.frame;
        self.svgaPlayer.videoItem = videoItem;
        [self.svgaPlayer startAnimation];
    } failureBlock:nil];
}
- (void)showAnimation:(NSString *)svgaName withFrame:(CGRect)frame
{
    [self.svgaParser parseWithNamed:svgaName
                           inBundle:nil
                    completionBlock:^(SVGAVideoEntity *_Nonnull videoItem) {
                        self.svgaPlayer.videoItem = videoItem;
                        [self.svgaPlayer startAnimation];
                    }
                       failureBlock:nil];

    self.svgaPlayer.frame = frame;
}
- (void)reSetFrame:(CGRect)frame
{
    self.svgaPlayer.frame = frame;
}
- (SVGAPlayer *)svgaPlayer
{
    if (!_svgaPlayer) {
        _svgaPlayer = [[SVGAPlayer alloc] init];
        [self.svgaPlayerView addSubview:_svgaPlayer];
        [self.svgaPlayerView bringSubviewToFront:_svgaPlayer];
        _svgaPlayer.delegate = self;
        _svgaPlayer.loops = self.loops;
        _svgaPlayer.clearsAfterStop = YES;
        _svgaPlayer.contentMode = UIViewContentModeScaleAspectFill;
        _svgaPlayer.userInteractionEnabled = NO;
    }
    return _svgaPlayer;
}

- (void)svgaPlayerDidFinishedAnimation:(SVGAPlayer *)player
{
    if (self.loops != MAXFLOAT) {
        [self stopAnimation];
    }
    if (self.completionHandler) {
        self.completionHandler();
    }
}

- (void)stopAnimation
{
    [self.svgaPlayer stopAnimation];
    [self.svgaPlayer removeFromSuperview];
    self.svgaPlayer = nil;
}

- (void)pauseAnimate {
    [self.svgaPlayer pauseAnimation];
}

- (void)startAnimate {
    [self.svgaPlayer startAnimation];
}

- (SVGAParser *)svgaParser
{
    if (!_svgaParser) {
        _svgaParser = [[SVGAParser alloc] init];
    }
    return _svgaParser;
}
@end
