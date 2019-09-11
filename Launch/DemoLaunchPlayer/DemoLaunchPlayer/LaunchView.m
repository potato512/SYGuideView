//
//  LaunchView.m
//  DemoLaunchPlayer
//
//  Created by zhangshaoyu on 2019/9/9.
//  Copyright © 2019 zhangshaoyu. All rights reserved.
//

#import "LaunchView.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface LaunchView ()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIImageView *launchImageView;
@property (nonatomic, strong) AVPlayer *launchPlayer;
@property (nonatomic, strong) AVPlayerItem *launchPlayerItem;
@property (nonatomic, strong) AVPlayerLayer *launchPlayerLayer;
@property (nonatomic, copy) void (^completeBlock)(void);

@end

@implementation LaunchView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = UIScreen.mainScreen.bounds;
        self.backgroundColor = UIColor.clearColor;
    }
    return self;
}

- (void)dealloc
{
    [self removeNotification];
    
    if (self.launchPlayer) {
        [self.launchPlayer pause];
        self.launchPlayer = nil;
    }
    if (self.launchImageView) {
        if (self.launchImageView.isAnimating) {
            [self.launchImageView stopAnimating];
        }
        [self.launchImageView removeFromSuperview];
        self.launchImageView = nil;
    }
}

#pragma mark - 图片

/// 启动静态图（单图，或多图，多图时动画效果）
- (void)launchWithImage:(NSArray <UIImage *>*)images complete:(void (^)(void))complete
{
    if (self.superview == nil) {
        [UIApplication.sharedApplication.delegate.window addSubview:self];
        [UIApplication.sharedApplication.delegate.window bringSubviewToFront:self];
    }
    
    [self imageLoad:images];
    [self imagePlay];
    self.completeBlock = complete;
}

- (void)imageLoad:(NSArray <UIImage *>*)images
{
    NSString *imageFile = [[NSBundle mainBundle] pathForResource:self.defaultImage ofType:nil];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:imageFile];
    self.imageView.image = image;
    if (self.imageView.superview == nil) {
        [self addSubview:self.imageView];
    }
    
    // 初始化图片
    self.launchImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:self.launchImageView];
    if (images.count <= 1) {
        self.launchImageView.image = images.lastObject;
    } else {
        self.launchImageView.animationImages = images;
        [self.launchImageView startAnimating];
    }
}

- (void)imagePlay
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.imageView.superview) {
            [self.imageView removeFromSuperview];
        }
    });
}

- (void)imageStop
{
    [self removeNotification];
    //
    if (self.imageView.superview) {
        [self.imageView removeFromSuperview];
    }
    
    if (self.launchImageView) {
        if (self.launchImageView.isAnimating) {
            [self.launchImageView stopAnimating];
        }
        [self.launchImageView removeFromSuperview];
        self.launchImageView = nil;
    }
    if (self.completeBlock) {
        if (self.superview) {
            [self removeFromSuperview];
        }
        self.completeBlock();
    }
}

#pragma mark - 视频

/// 启动视频
- (void)launchWithVideo:(NSString *)fileName complete:(void (^)(void))complete
{
    if (self.superview == nil) {
        [UIApplication.sharedApplication.delegate.window addSubview:self];
    }
    
    [self addNotification];
    [self videoLoad:fileName];
    [self videoPlay];
    self.completeBlock = complete;
}

- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    // 进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoPlay) name:UIApplicationDidBecomeActiveNotification object:nil];
    // 视频播放结束
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoStop) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    // 播放开始
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoPlay) name:AVPlayerItemTimeJumpedNotification object:nil];
}

- (void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)videoLoad:(NSString *)fileName
{
    NSString *imageFile = [[NSBundle mainBundle] pathForResource:self.defaultImage ofType:nil];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:imageFile];
    self.imageView.image = image;
    if (self.imageView.superview == nil) {
        [self addSubview:self.imageView];
    }
    
    // 初始化player
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
//    self.launchPlayer = [AVPlayer playerWithURL:[NSURL fileURLWithPath:filePath]];
//    [self.launchPlayer play];
    
//    NSURL *playUrl = nil;
//    if ([fileName hasPrefix:@"http://"] || [fileName hasPrefix:@"https://"]) {
//        playUrl = [NSURL URLWithString:fileName];
//    } else {
//        NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
//        playUrl = [NSURL fileURLWithPath:filePath];
//    }
//    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:playUrl];
//    //如果要切换视频需要调AVPlayer的replaceCurrentItemWithPlayerItem:方法
//    self.launchPlayer = [AVPlayer playerWithPlayerItem:playerItem];
//    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.launchPlayer];
//    playerLayer.frame = self.bounds;
//    [self.layer addSublayer:playerLayer];
//    [self.launchPlayer play];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    NSURL *videoUrl = [NSURL fileURLWithPath:filePath];
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:videoUrl];
    self.launchPlayer = [[AVPlayer alloc] initWithPlayerItem:playerItem];
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.launchPlayer];
    [self.layer addSublayer:playerLayer];
    playerLayer.frame = self.bounds;
    [self.launchPlayer play];
}

- (void)videoPlay
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.imageView.superview) {
            [self.imageView removeFromSuperview];
        }
    });
}

- (void)videoStop
{
    [self removeNotification];
    //
    if (self.imageView.superview) {
        [self.imageView removeFromSuperview];
    }

    if (self.launchPlayer) {
        [self.launchPlayer pause];
        self.launchPlayer = nil;
    }
    if (self.completeBlock) {
        if (self.superview) {
            [self removeFromSuperview];
        }
        self.completeBlock();
    }
}

#pragma mark - getter

- (UIImageView *)imageView
{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:_imageView];
    }
    return _imageView;
}

@end
