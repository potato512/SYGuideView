//
//  LaunchViewController.m
//  DemoLaunchPlayer
//
//  Created by zhangshaoyu on 2019/9/11.
//  Copyright © 2019 zhangshaoyu. All rights reserved.
//

#import "LaunchViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ViewController.h"

@interface LaunchViewController ()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) NSArray <UIImage *> *images;
@property (nonatomic, strong) NSString *fileVideo;

@property (nonatomic, strong) UIImageView *launchImageView;
@property (nonatomic, strong) AVPlayer *launchPlayer;
@property (nonatomic, strong) AVPlayerItem *launchPlayerItem;
@property (nonatomic, strong) AVPlayerLayer *launchPlayerLayer;
@property (nonatomic, copy) void (^completeBlock)(void);

@end

@implementation LaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.showsPlaybackControls = NO;
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = UIColor.orangeColor;
    self.view.frame = UIScreen.mainScreen.bounds;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 隐藏状态栏
    [UIApplication sharedApplication].statusBarHidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
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

- (void)showImage
{
    NSString *imageFile = [[NSBundle mainBundle] pathForResource:self.defaultImage ofType:nil];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:imageFile];
    self.imageView.image = image;
    if (self.imageView.superview == nil) {
        [self.view addSubview:self.imageView];
    }
//    sleep(5.0);
}

- (void)hideImage
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.imageView.alpha = 1.0;
        [UIView animateWithDuration:0.3 animations:^{
            self.imageView.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.imageView.alpha = 1.0;
            if (self.imageView.superview) {
                [self.imageView removeFromSuperview];
            }
        }];
    });
}

#pragma mark - 图片

/// 启动静态图（单图，或多图，多图时动画效果）
- (void)launchWithImage:(NSArray <UIImage *>*)images complete:(void (^)(void))complete
{
    self.images = images;
    [self imagePlay];
    self.completeBlock = complete;
}

- (void)imagePlay
{
    [self showImage];
    
    // 初始化图片
    self.launchImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.launchImageView];
    self.launchImageView.contentMode = UIViewContentModeScaleToFill;
    if (self.images.count <= 1) {
        self.launchImageView.image = self.images.lastObject;
    } else {
        self.launchImageView.animationDuration = 0.6;
        self.launchImageView.animationImages = self.images;
        [self.launchImageView startAnimating];
    }
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
        self.completeBlock();
    }
}

#pragma mark - 视频

/// 启动视频
- (void)launchWithVideo:(NSString *)fileName complete:(void (^)(void))complete
{
    [self addNotification];
    self.fileVideo = fileName;
    [self videoPlay];
    self.completeBlock = complete;
}

- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    // 进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideImage) name:UIApplicationDidBecomeActiveNotification object:nil];
    // 视频播放结束
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoStop) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    // 播放开始
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideImage) name:AVPlayerItemTimeJumpedNotification object:nil];
}

- (void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)videoPlay
{
    [self showImage];
    
    NSURL *videoUrl = nil;
    if ([self.fileVideo hasPrefix:@"http://"] || [self.fileVideo hasPrefix:@"https://"]) {
        videoUrl = [NSURL URLWithString:self.fileVideo];
    } else {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:self.fileVideo ofType:nil];
        videoUrl = [NSURL fileURLWithPath:filePath];
    }
    if (videoUrl == nil) {
        [self videoStop];
        return;
    }
    
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:videoUrl];
    self.launchPlayer = [[AVPlayer alloc] initWithPlayerItem:playerItem];
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.launchPlayer];
    [self.view.layer addSublayer:playerLayer];
    playerLayer.videoGravity = AVLayerVideoGravityResize;
    playerLayer.frame = self.view.bounds;
    [self.launchPlayer play];
}

- (void)videoStop
{
    [self removeNotification];
    //
    self.view.alpha = 1.0;
    [UIView animateWithDuration:0.6 animations:^{
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.view.alpha = 1.0;
        if (self.imageView.superview) {
            [self.imageView removeFromSuperview];
        }
        if (self.launchPlayer) {
            [self.launchPlayer pause];
            self.launchPlayer = nil;
        }
    }];
    if (self.completeBlock) {
        self.completeBlock();
    }
}

#pragma mark - getter

- (UIImageView *)imageView
{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        _imageView.contentMode = UIViewContentModeScaleToFill;
        [self.view addSubview:_imageView];
    }
    return _imageView;
}

@end
